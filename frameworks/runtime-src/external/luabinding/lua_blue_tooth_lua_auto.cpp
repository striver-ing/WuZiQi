#include "lua_blue_tooth_lua_auto.hpp"
#include "BlueToothControllerForCplus.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_blue_tooth_lua_BlueToothControllerForCplus_sendMessage(lua_State* tolua_S)
{
    int argc = 0;
    BlueToothControllerForCplus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"BlueToothControllerForCplus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (BlueToothControllerForCplus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_sendMessage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "BlueToothControllerForCplus:sendMessage"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_sendMessage'", nullptr);
            return 0;
        }
        cobj->sendMessage(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "BlueToothControllerForCplus:sendMessage",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_sendMessage'.",&tolua_err);
#endif

    return 0;
}
int lua_blue_tooth_lua_BlueToothControllerForCplus_closeConnect(lua_State* tolua_S)
{
    int argc = 0;
    BlueToothControllerForCplus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"BlueToothControllerForCplus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (BlueToothControllerForCplus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_closeConnect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_closeConnect'", nullptr);
            return 0;
        }
        cobj->closeConnect();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "BlueToothControllerForCplus:closeConnect",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_closeConnect'.",&tolua_err);
#endif

    return 0;
}
int lua_blue_tooth_lua_BlueToothControllerForCplus_getMessage(lua_State* tolua_S)
{
    int argc = 0;
    BlueToothControllerForCplus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"BlueToothControllerForCplus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (BlueToothControllerForCplus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getMessage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getMessage'", nullptr);
            return 0;
        }
        const char* ret = cobj->getMessage();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "BlueToothControllerForCplus:getMessage",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getMessage'.",&tolua_err);
#endif

    return 0;
}
int lua_blue_tooth_lua_BlueToothControllerForCplus_getConnect(lua_State* tolua_S)
{
    int argc = 0;
    BlueToothControllerForCplus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"BlueToothControllerForCplus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (BlueToothControllerForCplus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getConnect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getConnect'", nullptr);
            return 0;
        }
        cobj->getConnect();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "BlueToothControllerForCplus:getConnect",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getConnect'.",&tolua_err);
#endif

    return 0;
}
int lua_blue_tooth_lua_BlueToothControllerForCplus_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"BlueToothControllerForCplus",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getInstance'", nullptr);
            return 0;
        }
        BlueToothControllerForCplus* ret = BlueToothControllerForCplus::getInstance();
        object_to_luaval<BlueToothControllerForCplus>(tolua_S, "BlueToothControllerForCplus",(BlueToothControllerForCplus*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "BlueToothControllerForCplus:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_blue_tooth_lua_BlueToothControllerForCplus_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_blue_tooth_lua_BlueToothControllerForCplus_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (BlueToothControllerForCplus)");
    return 0;
}

int lua_register_blue_tooth_lua_BlueToothControllerForCplus(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"BlueToothControllerForCplus");
    tolua_cclass(tolua_S,"BlueToothControllerForCplus","BlueToothControllerForCplus","",nullptr);

    tolua_beginmodule(tolua_S,"BlueToothControllerForCplus");
        tolua_function(tolua_S,"sendMessage",lua_blue_tooth_lua_BlueToothControllerForCplus_sendMessage);
        tolua_function(tolua_S,"closeConnect",lua_blue_tooth_lua_BlueToothControllerForCplus_closeConnect);
        tolua_function(tolua_S,"getMessage",lua_blue_tooth_lua_BlueToothControllerForCplus_getMessage);
        tolua_function(tolua_S,"getConnect",lua_blue_tooth_lua_BlueToothControllerForCplus_getConnect);
        tolua_function(tolua_S,"getInstance", lua_blue_tooth_lua_BlueToothControllerForCplus_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(BlueToothControllerForCplus).name();
    g_luaType[typeName] = "BlueToothControllerForCplus";
    g_typeCast["BlueToothControllerForCplus"] = "BlueToothControllerForCplus";
    return 1;
}
TOLUA_API int register_all_blue_tooth_lua(lua_State* tolua_S)
{
	tolua_open(tolua_S);

	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_blue_tooth_lua_BlueToothControllerForCplus(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

