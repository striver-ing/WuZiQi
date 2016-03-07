----------------------------
--版权：
--作用: 开始界面
--作者: liubo
--时间: 20160306
--备注:
----------------------------

local StartScene = class("StartScene", cc.load("mvc").ViewBase)

function StartScene:onCreate()
    -- add background image
    display.newSprite("bk.jpg")
        :move(display.center)
        :addTo(self)

    --人机对战
    self:addButton("model.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.6 , function(sender, eventType)
         Log.d("人机对战")
    end)

    --双人对弈
    self:addButton("doublem.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.45 , function(sender, eventType)
        Log.d("双人对弈")
        local scene = display.newScene()
        scene:addChild(require("app.game-scene.MainScene"):create())
        display.runScene(scene)
    end)

    --联网对弈
     self:addButton("doublem.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.3, function(sender, eventType)
        Log.d("双人对弈")
    end)


    --残局对弈
    self:addButton("doublem.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.15, function(sender, eventType)
        Log.d("双人对弈")
    end)




end

function StartScene:addButton(img, posX, posY, callFunc)
    local btn = ccui.Button:create()
    btn:loadTextureNormal(img)
    btn:setPosition(cc.p(posX, posY))
    btn:addTo(self)
    btn:addTouchEventListener(callFunc)
end



return StartScene