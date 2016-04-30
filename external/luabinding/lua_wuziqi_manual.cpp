#include "lua_wuziqi_manual.hpp"
#include "NetworkManagerProtocol.h"
#include "tolua_fix.h"
#include "CCLuaEngine.h"
#include "LuaBasicConversions.h"

//注册callback 方法 todo
int lua_wuziqi_NetworkManagerProtocol_addReceivedMessageCallBack(lua_State* tolua_S) {
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
        tolua_error(tolua_S, "invalid 'cobj' in function 'lua_wuziqi_NetworkManagerProtocol_addReceivedMessageCallBack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
        std::function<void(const char*)> arg0;
        //        void (*arg0)(const char* msg);
        //
        //        do {
        //            // Lambda binding for lua is not supported.
        //            assert(false);
        //        } while(0)
        ;
        if (!ok) {
            tolua_error(tolua_S, "invalid arguments in function 'lua_wuziqi_NetworkManagerProtocol_addReceivedMessageCallBack'", nullptr);
            return 0;
        }

        LUA_FUNCTION handler = (toluafix_ref_function(tolua_S, 2, 0));
        cobj->addReceivedMessageCallBack([=](const char* msg) {
            LuaStack* stack = LuaEngine::getInstance()->getLuaStack();

            stack->pushString(msg);
            stack->executeFunctionByHandler(handler, 1);
            //            LuaEngine::getInstance()->removeScriptHandler(handler);

        });

        lua_settop(tolua_S, 1);
        return 1;
    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManagerProtocol:addReceivedMessageCallBack", argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S, "#ferror in function 'lua_wuziqi_NetworkManagerProtocol_addReceivedMessageCallBack'.", &tolua_err);
#endif

    return 0;
}

int lua_register_wuziqi_NetworkManagerProtocol_module(lua_State* tolua_S) {
    tolua_usertype(tolua_S, "NetworkManagerProtocol");
    tolua_cclass(tolua_S, "NetworkManagerProtocol", "NetworkManagerProtocol", "", nullptr);

    tolua_beginmodule(tolua_S, "NetworkManagerProtocol");
    tolua_function(tolua_S, "addReceivedMessageCallBack", lua_wuziqi_NetworkManagerProtocol_addReceivedMessageCallBack);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetworkManagerProtocol).name();
    g_luaType[typeName] = "NetworkManagerProtocol";
    g_typeCast["NetworkManagerProtocol"] = "NetworkManagerProtocol";
    return 1;
}

TOLUA_API int register_all_wuziqi_manual(lua_State* tolua_S) {
    tolua_open(tolua_S);

    tolua_module(tolua_S, nullptr, 0);
    tolua_beginmodule(tolua_S, nullptr);

    lua_register_wuziqi_NetworkManagerProtocol_module(tolua_S);

    tolua_endmodule(tolua_S);
    return 1;
}
