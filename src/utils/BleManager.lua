----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-30 22:13:15
--作用: 蓝牙模块接口管理
--备注:
----------------------------

local BleManager = {}

local bleManager = NetworkManagerFactory:produceBleManager()

    -- virtual void sendMessage(const char* message) = 0;
    -- virtual void addReceivedMessageCallBack(ReceivedMessageCallback receivedMessageCallback) = 0;

function BleManager.searchBleAndConnect()
    bleManager:searchBleAndConnect()
end

function BleManager.closeConnected()
    bleManager:closeConnected()
end

--calllback(msg)
function BleManager.addReceivedMessageCallBack(callback)
    bleManager:addReceivedMessageCallBack(callback)
end

function BleManager.sendMessage(msg)
    bleManager:sendMessage(msg)
end

function BleManager.ownSideAddChess(row, col)
    bleManager:sendMessage(string.format("%d,%d",row,col))
end

--callback(row, col)
function BleManager.enemySideAddChessCallback(callback)
    bleManager:addReceivedMessageCallBack(function (msg)
        local pos = string.find(msg, ",")
        local row = tonumber(string.sub(msg, 1, pos - 1))
        local col = tonumber(string.sub(msg, pos + 1, -1))
        callback(row, col)
    end)
end


return BleManager