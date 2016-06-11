----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-26 18:26:22
--作用: 蓝牙对弈
--备注:
----------------------------

local BleVsScene = class("BleVsScene", require("app.game-scene.GameBaseScene"))

local BleManager = require("utils.BleManager")
local AI = require("app.ai-algorithm.AI")

local ownPlayChessType = nil
-- local isConnected = false

local FIRST_PLAY_CHESS_MSG = "对方先下了,亲后下吧"
local SECOND_PLAY_CHESS_MSG = "对方选择了后下,\n  亲可以先下子"
local LEAVEED_GAME_MSG = "对方已离开游戏"

function BleVsScene:onCreate()
    Log.d("蓝牙对弈")

    -- self:addConnectedStatus()
    BleManager:searchBleAndConnect()

    -- if BleManager.isConnected() then
    --     self._connectedStatus:setString("已连接")
    --     -- isConnected = true
    -- else
    --     BleManager:searchBleAndConnect()
    -- end

    self._chessboard:addTouchCallFunc(function(row, col)
        -- if BleManager.isConnected() then
            if ownPlayChessType == self._chessboard:getNextTurnChessType() then
                self._chessboard:addChess(row, col)
                BleManager.ownSideAddChess(row, col)
            elseif ownPlayChessType == nil then
                Dialog.show("请连接设备", "连接", "取消", function(btnPos)
                    if btnPos == 1 then
                       BleManager:searchBleAndConnect()
                    elseif btnPos == 2 then
                        self:goHome()
                    end
                end)
            end
        -- else
        --     Dialog.show("请连接设备", "连接", "取消", function(btnPos)
        --         if btnPos == 1 then
        --            BleManager:searchBleAndConnect()
        --         elseif btnPos == 2 then
        --             self:goHome()
        --         end
        --     end)
        -- end

        -- 不需要设置先后手  谁先下谁先手
        -- if ownPlayChessType == nil then
        --     self._chessboard:addChess(row, col)
        --     ownPlayChessType = self._chessboard:getCurrentChessType()
        --     BleManager.ownSideAddChess(row, col)

        -- elseif ownPlayChessType == self._chessboard:getNextTurnChessType() then
        --     self._chessboard:addChess(row, col)
        --     BleManager.ownSideAddChess(row, col)
        -- end


    end)


    self:addCallback()

end

--  连接状态显示的label
function BleVsScene:addConnectedStatus()
    self._connectedStatus = cc.Label:createWithSystemFont("未连接", "Marker Felt.ttf", 40)
    self._connectedStatus:setPosition(cc.p(display.cx, display.height * 0.75))
    self._connectedStatus:addTo(self)
    -- isConnected = false
end

function BleVsScene:setFirstPlayChess(flag)
    if flag then
        ownPlayChessType = self._chessboard:getFirstChessType()
    else
        ownPlayChessType = self._chessboard:getBehindChessType()
    end
end

--悔棋
function BleVsScene:retractChess()
        -- 当前已下棋方不是自己 不能悔棋
    if ownPlayChessType == nil or ownPlayChessType == self._chessboard:getNextTurnChessType() then
        Dialog.show("现在不能悔棋😄")
    else
        BleManager.sendRequest(MSG.RETRACT)
        Dialog.show("悔棋请求已发出...")
    end
end

--重玩
function BleVsScene:reStart()
    BleManager.sendRequest(MSG.RESTART)
    Dialog.show("重玩请求已发出...")
end

--提示
function BleVsScene:hint()
   Dialog.show("不要耍赖哦！", "好吧")
end

function BleVsScene:goHome()
    BleManager.sendMessage(LEAVEED_GAME_MSG)

    -- if BleManager.isConnected() then
    --    BleManager.closeConnected()
    -- end

    local scene = require("app.start-scene.StartScene"):create()
    display.runScene(scene)
end

--回调
function BleVsScene:addCallback()
    --添加对方下棋的回调
    BleManager.enemySideAddChessCallback(function(row, col)
        self._chessboard:addChess(row, col)
        self._chessboard:notifyGameStarted()
    end)

    --添加连接上设备的回调
    BleManager.addOnConnectedCallback(function()
        -- isConnected = true
        -- self._connectedStatus:setString("已连接")
        self:setPlayChessSequence("  成功连接设备\n亲是先下还是后下")
    end)

    --添加断开设备的回调
    BleManager.addOnDisconnectedCallback(function()
        -- isConnected = false
        -- self._connectedStatus:setString("未连接")
        Dialog.show("  连接断开啦\n是否重新连接？", "是", "否", function(btnPos)
                if btnPos == 1 then
                   BleManager:searchBleAndConnect()
                elseif btnPos == 2 then
                    self:goHome()
                end
        end)
    end)

    --添加取消连接的回调
    BleManager.addCannelConnectedCallback(function()
        Log.d("取消连接")
        self:goHome()
    end)

    --收到请求回调
    BleManager.addReceivedRequestCallback(function(request)
        if request == MSG.RETRACT then              -- 悔棋请求
            Log.d("悔棋请求")
            Dialog.show("让我悔下棋吧😭...", "允 许", "拒 绝", function(btnPos)
                if btnPos == 1 then                 --同意
                    self._chessboard:retractChess()
                    BleManager.sendRequest(MSG.RETRACT_OK)
                elseif btnPos == 2 then             --拒绝
                    BleManager.sendRequest(MSG.RETRACT_REFUSED)
                end

            end)

        elseif request == MSG.RETRACT_OK then       -- 同意悔棋
            Dialog.show("对方同意了您的请求")
            self._chessboard:retractChess()

        elseif request == MSG.RETRACT_REFUSED then  -- 拒绝悔棋
            Dialog.show("对方拒绝了您的请求")

        elseif request == MSG.RESTART then          -- 重玩请求
            Dialog.show("咱俩重玩吧😭...", "允 许", "拒 绝", function(btnPos)
                if btnPos == 1 then                 --同意
                    if self:getChildByName("gameoverLayer") then -- 如果游戏结束 收到重玩请求 同意 需要撤掉己方的gameverLayer 然后进入游戏场景
                        self._gameoverLayer:removeSelf()
                    end

                    self:setPlayChessSequence()

                    BleManager.sendRequest(MSG.RESTART_OK)

                elseif btnPos == 2 then             --拒绝
                    BleManager.sendRequest(MSG.RESTART_REFUSED)
                end

            end)

        elseif request == MSG.RESTART_OK then       -- 同意重玩
            Dialog.show("对方同意了您的请求")

            self:setPlayChessSequence()

        elseif request == MSG.RESTART_REFUSED then  -- 拒绝重玩
            Dialog.show("对方拒绝了您的请求")
        end
    end)

    --接收到消息的回调(先手 后手的消息)
    BleManager.addReceivedMessageCallback(function (msg)
        if msg == FIRST_PLAY_CHESS_MSG then -- 对方先手 设置己方后手
            Dialog.show(msg, "好吧")
            self:setFirstPlayChess(false)
        elseif msg == SECOND_PLAY_CHESS_MSG then  -- 对方后手 设置己方先手
            Dialog.show(msg, "好的")
            self:setFirstPlayChess(true)
        elseif msg == LEAVEED_GAME_MSG then  -- 对方离开游戏通知
            Dialog.show(msg, "好的", nil, function(btnPos)
                local scene = require("app.start-scene.StartScene"):create()
                display.runScene(scene)

            end)
        end
    end)
end

--设置先后手
function BleVsScene:setPlayChessSequence(context)
    context = context == nil and "亲是先下子还是后下子" or context

    local function resetChessboard()
        self:stopAction(self._scheduleAction)
        self._chessboard:restartGame()
        self:resetGameTime()
    end

    Dialog.show(context, "先下", "后下", function(btnPos)
        if btnPos == 1 then
            self:setFirstPlayChess(true)
            BleManager.sendMessage(FIRST_PLAY_CHESS_MSG)
            resetChessboard()
        elseif btnPos == 2 then
            self:setFirstPlayChess(false)
            BleManager.sendMessage(SECOND_PLAY_CHESS_MSG)
            resetChessboard()
        end
    end)

end


return BleVsScene