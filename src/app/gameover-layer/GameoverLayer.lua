----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-05-10 14:13:33
--作用:
--备注:
----------------------------
local GameoverLayer = class("GameoverLayer", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
    -- return display.newLayer()
end)

function GameoverLayer:ctor(chessType, step)
    --花 和 竹的装饰
    self:addSprite("taohua_right.png", cc.p(1, 1), cc.p(display.width, display.height))
    self:addSprite("taohua_left.png", cc.p(0, 1), cc.p(0, display.height))
    self:addSprite("zhu_right.png", cc.p(1, 0), cc.p(display.width, 0))
    self:addSprite("zhu_left.png", cc.p(0, 0), cc.p(0, 0))

    -- self:okOrUndo()
    self:result(chessType, step)

end

function GameoverLayer:okOrUndo()
    --五子连珠
    local fiveBk = display.newSprite("kill/five_bk.png")
    fiveBk:setPosition(cc.p(display.cx, display.height * 0.6))
    fiveBk:addTo(self)

    -- 确定
    local okBtn = self:addButton("kill/ok.png", display.cx - 150, display.height * 0.4, self, function()
    end)

     -- 悔棋
    local undoBtn = self:addButton("kill/undo.png", display.cx + 150, display.height * 0.45, self, function()

    end)
end

--悔棋callback
function GameoverLayer:setRetractCallback(callback)
    self._retractCallback = callback
end

--再次尝试callback
function GameoverLayer:setRetryCallback(callback)
    self._reTryCallback = callback
end

--回到主页callback
function GameoverLayer:setGoHomeCallback(callback)
    self._goHomeCallback = callback
end

function GameoverLayer:result(chessType, step)

    local time = "60:00s"

    local resultBg = display.newSprite("bk.png")
    resultBg:setPosition(cc.p(display.cx, display.height * 0.55))
    resultBg:setScale((display.width / resultBg:getContentSize().width) * 0.95)
    resultBg:addTo(self)

    local resultBgWidth = resultBg:getContentSize().width
    local resultBgHeight = resultBg:getContentSize().height

    local winer = nil
    if chessType == nil then
        Log.d("*************和棋***********")
        winer = display.newSprite("same.png")
    elseif chessType == WHITE then
        Log.d("*************白棋赢***********")
        winer = display.newSprite("wht_win.png")
    elseif chessType == BLACK then
        Log.d("*************黑棋赢***********")
        winer = display.newSprite("blk_win.png")
    end
    winer:setScale(0.7)
    winer:addTo(resultBg)
    winer:setAnchorPoint(cc.p(0.5, 1))
    winer:setPosition(cc.p(resultBgWidth / 2,resultBgHeight + 100))

    --时间
    local timeSprite = display.newSprite("time_img.png")
    timeSprite:setAnchorPoint(cc.p(1, 0,5))
    timeSprite:setPosition(cc.p(resultBgWidth / 2 - 20, resultBgHeight * 0.58))
    timeSprite:addTo(resultBg)
    --时间label
    self:addLabel(time, cc.p(resultBgWidth / 2 + 25, resultBgHeight * 0.58), resultBg)

    --步数
    local stepSprite = display.newSprite("step_img.png")
    stepSprite:setAnchorPoint(cc.p(1, 0,5))
    stepSprite:setPosition(cc.p(resultBgWidth / 2 - 20, resultBgHeight * 0.46))
    stepSprite:addTo(resultBg)
    --步数label
    self:addLabel(step, cc.p(resultBgWidth / 2 + 25, resultBgHeight * 0.46), resultBg)

    -- 悔棋
    local undoBtn = self:addButton("kill/undo.png", resultBgWidth * 0.5, resultBgHeight * 0.35, resultBg, function()
        if self._retractCallback then self._retractCallback() end
    end)

    -- 重新挑战
    local reTryBtn = self:addButton("re_try.png", resultBgWidth / 3 - 25, resultBgHeight * 0.15, resultBg, function()
        if self._reTryCallback then self._reTryCallback() end
    end)

    --返回主页
    local goHomeBtn = self:addButton("home.png", resultBgWidth / 3 * 2 + 25, resultBgHeight * 0.15, resultBg, function()
        if self._goHomeCallback then self._goHomeCallback() end
    end)

end

function GameoverLayer:addSprite(image, anchorPoint, position, target)
    local sprite = display.newSprite(image)
    sprite:setPosition(position)

    if anchorPoint then
        sprite:setAnchorPoint(anchorPoint)
    end

    if target == nil then target = self end
    sprite:addTo(target)
    -- sprite:setRotation(30)

    -- --摇摆动画
    -- local waveDown = cc.RotateBy:create(8, -60)
    -- local waveUp = waveDown:reverse()
    -- local repeatWave = cc.RepeatForever:create(cc.Sequence:create(waveDown, waveUp))
    -- sprite:runAction(repeatWave)
end

function GameoverLayer:addLabel(text, position, target)
    -- local label = cc.Label:createWithSystemFont(text, "", 40.0)
    local label = cc.Label:create()
    label:setString(text)
    label:setSystemFontSize(40)
    label:setTextColor(cc.c4b(82, 45, 13, 255))
    label:setAnchorPoint(cc.p(0, 0,5))
    label:setPosition(position)
    label:addTo(target)
end

function GameoverLayer:addButton(img, posX, posY, addToTarget, callFunc, text, fontSize)
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

return GameoverLayer