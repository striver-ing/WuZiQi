----------------------------
--版权: 564773807@qq.com
--作用: 游戏基类
--作者: liubo
--时间: 20160129
--备注:
----------------------------

local GameBaseScene = class("GameBaseScene", function()
    return display.newScene()
end)

local AI = require("app.ai-algorithm.AI")
local GameoverLayer = require("app.gameover-layer.GameoverLayer")


local _retractCount = 1 --悔棋步数

function GameBaseScene:ctor()
     -- add background image
    display.newSprite("bg.jpg")
        :move(display.center)
        :addTo(self)

    ------------------------------------------------

    self._gameTime = 0
    --时间 label
    self._timeLabel = cc.Label:createWithSystemFont("00:00", "Marker Felt.ttf", 60)
    self._timeLabel:setAnchorPoint(cc.p(1, 0))
    self._timeLabel:setPosition(cc.p(display.width - 30, display.height * 0.82))
    self._timeLabel:enableOutline(cc.c4b(82, 45, 13, 255), 1)
    self._timeLabel:addTo(self)

    ------------------------------------------------
    --棋盘
    self._chessboard = require("app.game-scene.ChessboardNode"):new()
    self._chessboard:setPosition(cc.p(display.cx,  display.visibleoriginY + 150))
    self._chessboard:addTo(self)

    --功能菜单
    self:addMenu()
    -- 游戏时间
    self:addGameTime()
    -- 游戏结束callback
    self:addGameoverCallback()

    self:tipWhoAddChess()
    self:addAddingChessTip()
    self:hideAddingChess()

    --子类程序入口
    if self.onCreate then self:onCreate() end
end

--设置悔棋步数
function GameBaseScene:setRetractChessStep(retractCount)
    _retractCount = retractCount
end

--提示
function GameBaseScene:hint()
    local position = AI.getMaxSorcePoint(self._chessboard:getChessBoardArray())
        AI.setComputerChessType(self._chessboard:getNextTurnChessType())
        self._chessboard:addChess(position.row, position.col, function ()
    end)
end

--悔棋
function GameBaseScene:retractChess()
    for i = 1, _retractCount do
       self._chessboard:retractChess()
    end
end

--重玩
function GameBaseScene:reStart()
    self:stopAction(self._scheduleAction)
    self._chessboard:restartGame()
    self:resetGameTime()
end

--返回主页
function GameBaseScene:goHome()
    local scene = require("app.start-scene.StartScene"):create()
    display.runScene(scene)

end

--游戏时间
function GameBaseScene:addGameTime()
    self._chessboard:addStartGameCallback(function()
        self._scheduleAction = schedule(self, function()
        self._gameTime = self._gameTime + 1
        self:changeGameTimeLabel()
    end, 1)

    end)
end

--下子方提示
function GameBaseScene:tipWhoAddChess()
    local function addChessTip(file)
        local tip = display.newSprite(file)
        tip:setPosition(cc.p(self._timeLabel:getPositionX() - self._timeLabel:getContentSize().width / 2 , self._timeLabel:getPositionY() - 50))
        tip:addTo(self)
        return tip
    end

    local wihteChessTip = addChessTip("white_img.png")
    local blackChessTip = addChessTip("black_img.png")

    self._chessboard:addNextTurnNotifyCallback(function(nextChessType)
        if nextChessType == BLACK then
            wihteChessTip:setVisible(false)
            blackChessTip:setVisible(true)
        elseif nextChessType ==WHITE then
            blackChessTip:setVisible(false)
            wihteChessTip:setVisible(true)
        end
    end)
end

-- 正在下子  等待
function GameBaseScene:addAddingChessTip()
    self._addingChessTip = display.newSprite("rotate.png")
    self._addingChessTip:setPosition(cc.p(self._timeLabel:getPositionX() - self._timeLabel:getContentSize().width / 2 , self._timeLabel:getPositionY() - 50))
    self._addingChessTip:addTo(self)

    -- 旋转
    local rotate = cc.RotateBy:create(2, 360)
    local repeatRotate = cc.RepeatForever:create(rotate)
    self._addingChessTip:runAction(repeatRotate)
end

function GameBaseScene:showAddingChessTip()
    self._addingChessTip:setVisible(true)
end

function GameBaseScene:hideAddingChess()
    self._addingChessTip:setVisible(false)
end

--改变 time label
function GameBaseScene:changeGameTimeLabel()
    local minute = self._gameTime / 60
    local second = self._gameTime % 60
    self._gameTimeStr = string.format("%02d:%02d", minute, second)
    Log.d(self._gameTimeStr)
    self._timeLabel:setString(self._gameTimeStr)
end

function GameBaseScene:resetGameTime()
    self._gameTime = 0
    self:changeGameTimeLabel()
end

function GameBaseScene:addGameoverCallback()
    self._gameoverLayer = nil

    --游戏结束掉出结束层
    self._chessboard:setGameoverCallback(function(chessType, step)
        -- 停止时间计时
        self:stopAction(self._scheduleAction)

        performWithDelay(self, function()
            self._gameoverLayer = GameoverLayer.new(chessType, step, self._gameTimeStr)
            self._gameoverLayer:addTo(self, 100)

            -- 设置 悔棋 重玩 和 回到主页的回调
            self._gameoverLayer:setRetractCallback(function()
                self:retractChess()
                self._gameoverLayer:removeSelf()
            end)

            self._gameoverLayer:setRetryCallback(function()
                self:reStart()
                self._gameoverLayer:removeSelf()
            end)

            self._gameoverLayer:setGoHomeCallback(function()
                self:goHome()
            end)
        end, 1.5)
    end)


end

--添加一些功能按钮
function GameBaseScene:addMenu()
    local menuBtnPositionX = display.visiblesizeWidth / 7
    local menuBtnPositionY = display.top - 80

    --音乐 和 音效承载层
    local soundFrame = display.newSprite("sound/frame.png")
    soundFrame:setAnchorPoint(cc.p(0.5, 1))
    soundFrame:setPosition(menuBtnPositionX * 2 - 30, menuBtnPositionY - 25)
    soundFrame:addTo(self, 10)
    soundFrame:setVisible(false)

    local musicBtnBg = SoundManager.isMusicEnable() == true and "sound/music.png" or "sound/music_an.png"
    local effectBtnBg = SoundManager.isEffectsEnable() == true and "sound/effect.png" or "sound/effect_an.png"
    --音乐
    self:addButton(musicBtnBg, soundFrame:getContentSize().width / 2 , soundFrame:getContentSize().height / 3 * 2 + 10, soundFrame, function(sender, eventType)
        if SoundManager.isMusicEnable() then
            SoundManager.setMusicEnable(false)
            SoundManager.stopMusic()
            sender:loadTextureNormal("sound/music_an.png")
        else
            SoundManager.setMusicEnable(true)
            SoundManager.startMusic()
            sender:loadTextureNormal("sound/music.png")
        end

    end)

    --音效
    self:addButton(effectBtnBg, soundFrame:getContentSize().width / 2 , soundFrame:getContentSize().height / 3 - 10, soundFrame, function(sender, eventType)
        if SoundManager.isEffectsEnable() then
            SoundManager.setEffectsEnable(false)
            sender:loadTextureNormal("sound/effect_an.png")
        else
            SoundManager.setEffectsEnable(true)
            sender:loadTextureNormal("sound/effect.png")
        end
    end)

    --返回主菜单
    self:addButton("back.png", menuBtnPositionX - 50, menuBtnPositionY - 20, self, function(sender, eventType)
        self:goHome()
    end)

    --声音
    self:addButton("sound.png", menuBtnPositionX * 2 - 30, menuBtnPositionY, self, function(sender, eventType)
        if soundFrame:isVisible() then
            soundFrame:setVisible(false)
        else
            soundFrame:setVisible(true)
        end
    end)

    --重玩
    self:addButton("replay.png", menuBtnPositionX * 3 - 10, menuBtnPositionY, self, function(sender, eventType)
        self:reStart()
    end)

    --悔棋
    self:addButton("undo.png", menuBtnPositionX * 4 + 10, menuBtnPositionY, self, function(sender, eventType)
         self:retractChess()
    end)

    --提示
    self:addButton("hint.png", menuBtnPositionX * 5 + 30, menuBtnPositionY, self, function(sender, eventType)
        self:hint()
    end)

    --帮助
    self:addButton("help.png", menuBtnPositionX * 6 + 50, menuBtnPositionY, self, function(sender, eventType)
        --截屏分享 todo
    end)


    --点击声音frame外  使frame隐藏
    local frameListener = cc.EventListenerTouchOneByOne:create()
    frameListener:registerScriptHandler(function(touch, event)
        if soundFrame:isVisible() then
            soundFrame:setVisible(false)
        end
        return false
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(frameListener, self)

end

function GameBaseScene:addButton(img, posX, posY, addToTarget, callFunc, text, fontSize)
    local btn = ccui.Button:create()
    btn:setPosition(cc.p(posX, posY))
    btn:addTo(addToTarget)
    btn:addTouchEventListener(callFunc)

    if text then
        btn:setTitleText(text)
        btn:setTitleFontSize(fontSize)
    end

    if img then btn:loadTextureNormal(img) end

    return btn
end

return GameBaseScene
