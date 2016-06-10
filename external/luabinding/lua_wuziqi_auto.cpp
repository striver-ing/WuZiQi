#include "lua_wuziqi_auto.hpp"
#include "NetworkManagerProtocol.h"
#include "NetworkManagerFactory.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"

int lua_wuziqi_NetworkManagerProtocol_closeConnected(lua_State* tolua_S) {
    int argc = 0;
    NetworkManagerProtocol* cobj = nullptr;
    bool ok = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S, 1, "NetworkManagerProtocol", 0, &tolua_err))
        goto tolua_lerror;
#endif

    cobj = (NetworkManagerProtocol*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) {
        tolua_error(tolua_S, "invalid 'cobj' in function 'lua_wuziqi_NetworkManagerProtocol_closeConnected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S) - 1;
    if (argc == 0) {
        if (!ok) {
            tolua_error(tolua_S, "invalid arguments in function 'lua_wuziqi_NetworkManagerProtocol_closeConnected'", nullptr);
            return 0;
        }
        cobj->closeConnected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManagerProtocol:closeConnected", argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'lua_wuziqi_NetworkManagerProtocol_closeConnected'.", &tolua_err);
#endif

    return 0;
}

int lua_wuziqi_NetworkManagerProtocol_isConnected(lua_State* tolua_S) {
    int argc = 0;
    NetworkManagerProtocol* cobj = nullptr;
    bool ok = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S, 1, "NetworkManagerProtocol", 0, &tolua_err))
        goto tolua_lerror;
#endif

    cobj = (NetworkManagerProtocol*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) {
        tolua_error(tolua_S, "invalid 'cobj' in function 'lua_wuziqi_NetworkManagerProtocol_isConnected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S) - 1;
    if (argc == 0) {
        if (!ok) {
            tolua_error(tolua_S, "invalid arguments in function 'lua_wuziqi_NetworkManagerProtocol_isConnected'", nullptr);
            return 0;
        }
        bool ret = cobj->isConnected();
        tolua_pushboolean(tolua_S, (bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManagerProtocol:isConnected", argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'lua_wuziqi_NetworkManagerProtocol_isConnected'.", &tolua_err);
#endif

    return 0;
}
int lua_wuziqi_NetworkManagerProtocol_searchBleAndConnect(lua_State* tolua_S) {
    int argc = 0;
    NetworkManagerProtocol* cobj = nullptr;
    bool ok = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S, 1, "NetworkManagerProtocol", 0, &tolua_err))
        goto tolua_lerror;
#endif

    cobj = (NetworkManagerProtocol*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) {
        tolua_error(tolua_S, "invalid 'cobj' in function 'lua_wuziqi_NetworkManagerProtocol_searchBleAndConnect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S) - 1;
    if (argc == 0) {
        if (!ok) {
            tolua_error(tolua_S, "invalid arguments in function 'lua_wuziqi_NetworkManagerProtocol_searchBleAndConnect'", nullptr);
            return 0;
        }
        cobj->searchBleAndConnect();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManagerProtocol:searchBleAndConnect", argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'lua_wuziqi_NetworkManagerProtocol_searchBleAndConnect'.", &tolua_err);
#endif

    return 0;
}

int lua_wuziqi_NetworkManagerProtocol_sendMessage(lua_State* tolua_S) {
    int argc = 0;
    NetworkManagerProtocol* cobj = nullptr;
    bool ok = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S, 1, "NetworkManagerProtocol", 0, &tolua_err))
        goto tolua_lerror;
#endif

    cobj = (NetworkManagerProtocol*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) {
        tolua_error(tolua_S, "invalid 'cobj' in function 'lua_wuziqi_NetworkManagerProtocol_sendMessage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
        const char* arg0;

        std::string arg0_tmp;
        ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "NetworkManagerProtocol:sendMessage");
        arg0 = arg0_tmp.c_str();
        if (!ok) {
            tolua_error(tolua_S, "invalid arguments in function 'lua_wuziqi_NetworkManagerProtocol_sendMessage'", nullptr);
            return 0;
        }
        cobj->sendMessage(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManagerProtocol:sendMessage", argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'lua_wuziqi_NetworkManagerProtocol_sendMessage'.", &tolua_err);
#endif

    return 0;
}

static int lua_wuziqi_NetworkManagerProtocol_finalize(lua_State* tolua_S) {
    printf("luabindings: finalizing LUA object (NetworkManagerProtocol)");
    return 0;
}

int lua_register_wuziqi_NetworkManagerProtocol(lua_State* tolua_S) {
    tolua_usertype(tolua_S, "NetworkManagerProtocol");
    tolua_cclass(tolua_S, "NetworkManagerProtocol", "NetworkManagerProtocol", "", nullptr);

    tolua_beginmodule(tolua_S, "NetworkManagerProtocol");
    tolua_function(tolua_S, "closeConnected", lua_wuziqi_NetworkManagerProtocol_closeConnected);
    tolua_function(tolua_S, "isConnected", lua_wuziqi_NetworkManagerProtocol_isConnected);
    tolua_function(tolua_S, "searchBleAndConnect", lua_wuziqi_NetworkManagerProtocol_searchBleAndConnect);
    tolua_function(tolua_S, "sendMessage", lua_wuziqi_NetworkManagerProtocol_sendMessage);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetworkManagerProtocol).name();
    g_luaType[typeName] = "NetworkManagerProtocol";
    g_typeCast["NetworkManagerProtocol"] = "NetworkManagerProtocol";
    return 1;
}

int lua_wuziqi_NetworkManagerFactory_produceBleManager(lua_State* tolua_S) {
    int argc = 0;
    bool ok = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S, 1, "NetworkManagerFactory", 0, &tolua_err))
        goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0) {
        if (!ok) {
            tolua_error(tolua_S, "invalid arguments in function 'lua_wuziqi_NetworkManagerFactory_produceBleManager'", nullptr);
            return 0;
        }
        NetworkManagerProtocol* ret = NetworkManagerFactory::produceBleManager();
        object_to_luaval<NetworkManagerProtocol>(tolua_S, "NetworkManagerProtocol", (NetworkManagerProtocol*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetworkManagerFactory:produceBleManager", argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'lua_wuziqi_NetworkManagerFactory_produceBleManager'.", &tolua_err);
#endif
    return 0;
}
static int lua_wuziqi_NetworkManagerFactory_finalize(lua_State* tolua_S) {
    printf("luabindings: finalizing LUA object (NetworkManagerFactory)");
    return 0;
}

int lua_register_wuziqi_NetworkManagerFactory(lua_State* tolua_S) {
    tolua_usertype(tolua_S, "NetworkManagerFactory");
    tolua_cclass(tolua_S, "NetworkManagerFactory", "NetworkManagerFactory", "", nullptr);

    tolua_beginmodule(tolua_S, "NetworkManagerFactory");
    tolua_function(tolua_S, "produceBleManager", lua_wuziqi_NetworkManagerFactory_produceBleManager);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetworkManagerFactory).name();
    g_luaType[typeName] = "NetworkManagerFactory";
    g_typeCast["NetworkManagerFactory"] = "NetworkManagerFactory";
    return 1;
}
TOLUA_API int register_all_wuziqi(lua_State* tolua_S) {
    tolua_open(tolua_S);

    tolua_module(tolua_S, nullptr, 0);
    tolua_beginmodule(tolua_S, nullptr);

    lua_register_wuziqi_NetworkManagerProtocol(tolua_S);
    lua_register_wuziqi_NetworkManagerFactory(tolua_S);

    tolua_endmodule(tolua_S);
    return 1;
}
