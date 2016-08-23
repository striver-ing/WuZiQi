----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-05-31 17:55:15
--作用: 对话框
--备注:
----------------------------

cc.exports.Dialog = {}

local dialog = nil
local sheildLayer = nil

local dialogTag = 10
local sheildLayerTag = 11

--[[
弹出通用对话框，最多能有两个按钮，
params context: 提示的文字
params text1, text2: 按钮上的文字，可以为nil
params callback: 点击按钮的回调函数，会传入所点击按钮的index(1或2)，可以为nil
]]
function Dialog.show(context, text1, text2, callback)
    -- 如果原来已出现弹框，则先消失弹窗
    Dialog.dismiss()

    local runningScene = cc.Director:getInstance():getRunningScene()
     --屏蔽层
    Dialog.createSheildLayer()


    --背景
    dialog = display.newSprite("dialog/dialog.png")
    dialog:setPosition(display.center)
    dialog:addTo(runningScene, 1000)
    dialog:setTag(dialogTag)

    --内容信息
    local msgLabel = cc.Label:createWithSystemFont(context, "Marker Felt.ttf", 50)
    msgLabel:setPosition(cc.p(dialog:getContentSize().width / 2, dialog:getContentSize().height * 0.6))
    msgLabel:setTextColor(cc.c4b(82, 45, 13, 255))
    msgLabel:addTo(dialog)

    --按钮
    --如果text1 为空 text2 不为空 text1 ＝ text2， text2 ＝ nil
    --如果text1为空 text2 为空  text1 ＝ 确定
    text1 = text1 == nil and (text2 == nil and "确定" or text2) or text1
    text2 = text2 == text1 and nil or text2

    if not text2 then --说明只有一按钮
        local btn = Dialog.createButton("dialog/dialogBtn.png", text1, function()
            if callback then callback() end
            Dialog.dismiss()
        end)
        btn:addTo(dialog)
        btn:setAnchorPoint(cc.p(0.5, 0))
        btn:setPosition(cc.p(dialog:getContentSize().width / 2, dialog:getContentSize().height * 0.1))

    else
        if text1 then
            local btn = Dialog.createButton("dialog/dialogBtn.png", text1, function()
                Dialog.dismiss()
                if callback then callback(1) end
            end)
            btn:addTo(dialog)
            btn:setAnchorPoint(cc.p(0, 0))
            btn:setPosition(cc.p(dialog:getContentSize().width * 0.1, dialog:getContentSize().height * 0.1))
        end

        if text2 then
            local btn = Dialog.createButton("dialog/dialogBtn.png", text2, function()
                Dialog.dismiss()
                if callback then callback(2) end
            end)
            btn:addTo(dialog)
            btn:setAnchorPoint(cc.p(1, 0))
            btn:setPosition(cc.p(dialog:getContentSize().width * 0.9, dialog:getContentSize().height * 0.1))
        end
    end


end

function Dialog.dismiss()
    local runningScene = cc.Director:getInstance():getRunningScene()
    if runningScene:getChildByTag(dialogTag) then
        dialog:removeSelf()
    end

    if runningScene:getChildByTag(sheildLayerTag) then
        sheildLayer:removeSelf()
    end
end

--屏蔽底层按钮
function Dialog.createSheildLayer()
    local runningScene = cc.Director:getInstance():getRunningScene()
    sheildLayer = require("utils.MarkLayer").new()
    sheildLayer:addTo(runningScene, 1000)
    sheildLayer:setTag(sheildLayerTag)
end

function Dialog.createButton(img, text, callFunc)
    local btn = ccui.Button:create()
    btn:addTouchEventListener(callFunc)


    if text then
        btn:setTitleText(text)
        btn:setTitleColor(cc.c3b(254, 211, 145))
        btn:setTitleFontSize(40)
    end

    if img then btn:loadTextureNormal(img) end

    return btn
end

return Dialog