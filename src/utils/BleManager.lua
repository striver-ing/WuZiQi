----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-30 22:13:15
--作用: 蓝牙模块接口管理
--备注:
----------------------------

local BleManager = {}

local bleManager = NetworkManagerFactory:produceBleManager()

function BleManager.searchBleAndConnect()
    bleManager:searchBleAndConnect()
end

function BleManager.closeConnected()
    bleManager:closeConnected()
end

function BleManager.sendMessage(msg)
    bleManager:sendMessage(MSG.TALK .. msg)
end

function BleManager.ownSideAddChess(row, col)
    bleManager:sendMessage(MSG.ADD_CHESS .. string.format("%d,%d",row,col))
end

--对话calllback(msg)
function BleManager.addReceivedMessageCallback(callback)
    bleManager:addReceivedMessageCallback(function(msg)
        local headPosBegin, headPosEnd = string.find(msg, MSG.TALK)
        if headPosBegin == nil then return end
        local talkContent = string.sub(msg, headPosEnd + 1, -1)
        callback(talkContent)
    end)
end

--下棋callback(row, col)
function BleManager.enemySideAddChessCallback(callback)
    bleManager:addReceivedMessageCallback(function (msg)
        local headPosBegin, headPosEnd = string.find(msg, MSG.ADD_CHESS)
        if headPosBegin == nil then return end

        local pos = string.find(msg, ",")
        local row = tonumber(string.sub(msg, headPosEnd + 1, pos - 1))
        local col = tonumber(string.sub(msg, pos + 1, -1))
        callback(row, col)
    end)
end


return BleManager