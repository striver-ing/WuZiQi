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

function BleManager.isConnected()
    return bleManager:isConnected()
end
--------------------------------------
function BleManager.sendMessage(msg)
    bleManager:sendMessage(MSG.TALK .. msg)
end

--对话calllback(msg)
function BleManager.addReceivedMessageCallback(callback)
    bleManager:addReceivedMessageCallback(function(msg)
        if msg == nil then return end
        local headPosBegin, headPosEnd = string.find(msg, MSG.TALK)
        if headPosBegin == nil then return end
        local talkContent = string.sub(msg, headPosEnd + 1, -1)
        callback(talkContent)
    end)
end
--------------------------------------

function BleManager.ownSideAddChess(row, col)
    bleManager:sendMessage(MSG.ADD_CHESS .. string.format("%d,%d",row,col))
end

--收到对方下棋callback(row, col)
function BleManager.enemySideAddChessCallback(callback)
    bleManager:addReceivedMessageCallback(function (msg)
        if msg == nil then return end
        local headPosBegin, headPosEnd = string.find(msg, MSG.ADD_CHESS)
        if headPosBegin == nil then return end

        local pos = string.find(msg, ",")
        local row = tonumber(string.sub(msg, headPosEnd + 1, pos - 1))
        local col = tonumber(string.sub(msg, pos + 1, -1))
        callback(row, col)
    end)
end
--------------------------------------

--请求悔棋 重玩等
function BleManager.sendRequest(msg)
    bleManager:sendMessage(MSG.REQUEST .. msg)
end

--收到请求 calllback(request)
function BleManager.addReceivedRequestCallback(callback)
    bleManager:addReceivedMessageCallback(function(msg)
        if msg == nil then return end
        local headPosBegin, headPosEnd = string.find(msg, MSG.REQUEST)
        if headPosBegin == nil then return end
        local request = string.sub(msg, headPosEnd + 1, -1)
        callback(tonumber(request))
    end)
end
--------------------------------------

--连接上设备
function BleManager.addOnConnectedCallback(callback)
    if callback then
        bleManager:addOnConnectedCallback(callback)
    end
end

--连接断开
function BleManager.addOnDisconnectedCallback(callback)
    if callback then
        bleManager:addOnDisconnectedCallback(callback)
    end
end

--取消连接
function BleManager.addCannelConnectedCallback(callback)
    if callback then
        bleManager:addCannelConnectedCallback(callback)
    end
end


return BleManager