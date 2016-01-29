----------------------------
--版权：
--作用: app 入口
--作者: liubo
--时间: 20160109
--备注:
----------------------------

cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")

require "utils.Constants"
require "config"
require "cocos.init"
require "utils.GameInit"

function __G__TRACKBACK__(errorMessage)
    Log.d("-----------------------------------------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage))
    debug.tracebackex()
    Log.d("-----------------------------------------------------------------------")
end

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
