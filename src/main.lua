----------------------------
--版权: 564773807@qq.com
--作用: app 入口
--作者: liubo
--时间: 20160109
--备注:
----------------------------

cc.FileUtils:getInstance():setPopupNotify(true)
cc.FileUtils:getInstance():addSearchPath("src/")

require "utils.Constants"
require "config"
require "cocos.init"
require "utils.GameInit"

function __G__TRACKBACK__(errorMessage)
    Log.d("-----------------------------------------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage))
    print(debug.tracebackex("", 2))
    Log.d("-----------------------------------------------------------------------")
end

local function main()
    Log.d("\n***************** enter main *****************\n")

    --垃圾回收
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    cc.Director:getInstance():setAnimationInterval(1.0 / FPS)
    cc.Director:getInstance():setDisplayStats(CC_SHOW_FPS or false)

    --按钮声音
    SoundManager.init()

    local startScene = require("app.start-scene.StartScene"):create()
    display.runScene(startScene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
