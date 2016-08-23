#!/usr/bin/python

# This script is used to generate luabinding glue codes.
# Android ndk version must be ndk-r9b.


import sys
import os, os.path
import shutil
import ConfigParser
import subprocess
import re
from contextlib import contextmanager

proj_name = "wuziqi"


def _check_ndk_root_env():
    ''' Checking the environment NDK_ROOT, which will be used for building
    '''

    try:
        NDK_ROOT = os.environ['NDK_ROOT']
    except Exception:
        print "NDK_ROOT not defined. Please define NDK_ROOT in your environment."
        sys.exit(1)

    return NDK_ROOT

def _check_python_bin_env():
    ''' Checking the environment PYTHON_BIN, which will be used for building
    '''

    try:
        PYTHON_BIN = os.environ['PYTHON_BIN']
    except Exception:
        print "PYTHON_BIN not defined, use current python."
        PYTHON_BIN = sys.executable

    return PYTHON_BIN


class CmdError(Exception):
    pass


@contextmanager
def _pushd(newDir):
    previousDir = os.getcwd()
    os.chdir(newDir)
    yield
    os.chdir(previousDir)

def _run_cmd(command):
    ret = subprocess.call(command, shell=True)
    if ret != 0:
        message = "Error running command"
        raise CmdError(message)

def _replace_str(file, oldStr, newStr):
    targetfile = open(file, 'r')
    try:
        content = targetfile.read()
        content = content.replace(oldStr, newStr)
    finally:
        targetfile.close()

    targetfile = open(file, 'w')
    try:
        targetfile.write(content)
    finally:
        targetfile.close()

def main():

    cur_platform= '??'
    llvm_path = '??'
    ndk_root = _check_ndk_root_env()
    # del the " in the path
    ndk_root = re.sub(r"\"", "", ndk_root)
    python_bin = _check_python_bin_env()

    platform = sys.platform
    if platform == 'win32':
        cur_platform = 'windows'
    elif platform == 'darwin':
        cur_platform = platform
    elif 'linux' in platform:
        cur_platform = 'linux'
    else:
        print 'Your platform is not supported!'
        sys.exit(1)

    if platform == 'win32':
        x86_llvm_path = os.path.abspath(os.path.join(ndk_root, 'toolchains/llvm-3.3/prebuilt', '%s' % cur_platform))
        if not os.path.exists(x86_llvm_path):
            x86_llvm_path = os.path.abspath(os.path.join(ndk_root, 'toolchains/llvm-3.4/prebuilt', '%s' % cur_platform))
    else:
        x86_llvm_path = os.path.abspath(os.path.join(ndk_root, 'toolchains/llvm-3.3/prebuilt', '%s-%s' % (cur_platform, 'x86')))
        if not os.path.exists(x86_llvm_path):
            x86_llvm_path = os.path.abspath(os.path.join(ndk_root, 'toolchains/llvm-3.4/prebuilt', '%s-%s' % (cur_platform, 'x86')))

    x64_llvm_path = os.path.abspath(os.path.join(ndk_root, 'toolchains/llvm-3.3/prebuilt', '%s-%s' % (cur_platform, 'x86_64')))
    if not os.path.exists(x64_llvm_path):
        x64_llvm_path = os.path.abspath(os.path.join(ndk_root, 'toolchains/llvm-3.4/prebuilt', '%s-%s' % (cur_platform, 'x86_64')))

    if os.path.isdir(x86_llvm_path):
        llvm_path = x86_llvm_path
    elif os.path.isdir(x64_llvm_path):
        llvm_path = x64_llvm_path
    else:
        print 'llvm toolchain not found!'
        print 'path: %s or path: %s are not valid! ' % (x86_llvm_path, x64_llvm_path)
        sys.exit(1)

    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
    cocos_root = os.path.abspath(os.path.join(project_root, '..', 'cocos2d-x'))
    cxx_generator_root = os.path.abspath(os.path.join(cocos_root, 'tools/bindings-generator'))

    # save config to file
    config = ConfigParser.ConfigParser()
    config.set('DEFAULT', 'androidndkdir', ndk_root)
    config.set('DEFAULT', 'clangllvmdir', llvm_path)
    config.set('DEFAULT', 'cocosdir', cocos_root)
    config.set('DEFAULT', 'cxxgeneratordir', cxx_generator_root)
    config.set('DEFAULT', 'extra_flags', '')
    config.set('DEFAULT', 'project_root', project_root)

    # To fix parse error on windows, we must difine __WCHAR_MAX__ and undefine __MINGW32__ .
    if platform == 'win32':
        config.set('DEFAULT', 'extra_flags', '-D__WCHAR_MAX__=0x7fffffff -U__MINGW32__')

    conf_ini_file = os.path.abspath(os.path.join(os.path.dirname(__file__), 'userconf.ini'))

    print 'generating userconf.ini...'
    with open(conf_ini_file, 'w') as configfile:
        config.write(configfile)
        configfile.close()


    # set proper environment variables
    if 'linux' in platform or platform == 'darwin':
        os.putenv('LD_LIBRARY_PATH', '%s/libclang' % cxx_generator_root)
    if platform == 'win32':
        path_env = os.environ['PATH']
        os.putenv('PATH', r'%s;%s\libclang;%s\tools\win32;' % (path_env, cxx_generator_root, cxx_generator_root))


    try:

        tolua_root = '%s/tools/tolua' % project_root
        output_dir = '%s/../../external/luabinding' % project_root
        output_file = '%s/lua_%s_auto.cpp' % (output_dir, proj_name)
        print output_dir

        cmd_args = {'%s.ini' % proj_name : ('%s' % proj_name, 'lua_%s_auto' % proj_name), \
                    }
        target = 'lua'
        generator_py = '%s/generator.py' % cxx_generator_root
        for key in cmd_args.keys():
            args = cmd_args[key]
            cfg = '%s/%s' % (tolua_root, key)
            print 'Generating bindings for %s...' % (key[:-4])
            command = '%s %s %s -s %s -t %s -o %s -n %s' % (python_bin, generator_py, cfg, args[0], target, output_dir, args[1])
            _run_cmd(command)

        # if platform == 'win32':
        #     with _pushd(output_dir):
        #         _run_cmd('dos2unix %s' %output_file)
        #         _run_cmd('dos2unix api/*')

        print '---------------------------------'
        print 'Generating lua bindings succeeds.'
        print '---------------------------------'

    except Exception as e:
        if e.__class__.__name__ == 'CmdError':
            print '---------------------------------'
            print 'Generating lua bindings fails.'
            print '---------------------------------'
            sys.exit(1)
        else:
            raise

    _replace_str(output_file, 'object_to_luaval<std::vector<cocos2d::Node , std::allocator<cocos2d::Node > >&>(tolua_S, "std::vector<cocos2d::Node *, std::allocator<cocos2d::Node *> >",(std::vector<cocos2d::Node *, std::allocator<cocos2d::Node *> >&)ret);', 'object_to_luaval<std::vector<cocos2d::Node*> >(tolua_S, "std::vector<cocos2d::Node *, std::allocator<cocos2d::Node *> >", &ret);')
    _replace_str(output_file, ' object_to_luaval<std::vector<Wanaka::BaseEvent , std::allocator<Wanaka::BaseEvent > >&>(tolua_S, "std::vector<Wanaka::BaseEvent *, std::allocator<Wanaka::BaseEvent *> >",(std::vector<Wanaka::BaseEvent *, std::allocator<Wanaka::BaseEvent *> >&)ret);', 'object_to_luaval<std::vector<Wanaka::BaseEvent *> >(tolua_S, "std::vector<Wanaka::BaseEvent *, std::allocator<Wanaka::BaseEvent *> >", &ret);')
    _replace_str(output_file, ' object_to_luaval<std::vector<Wanaka::Track , std::allocator<Wanaka::Track > >&>(tolua_S, "std::vector<Wanaka::Track *, std::allocator<Wanaka::Track *> >",(std::vector<Wanaka::Track *, std::allocator<Wanaka::Track *> >&)ret);', 'object_to_luaval<std::vector<Wanaka::Track *> >(tolua_S, "std::vector<Wanaka::Track *, std::allocator<Wanaka::Track *> >", &ret);')
    _replace_str(output_file, 'luaval_to_object<LuaFunction>', 'toluafix_ref_lua_function')

# -------------- main --------------
if __name__ == '__main__':
    main()
