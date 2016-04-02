----------------------------
--版权: 564773807@qq.com
--作用: lua的log相关封装
--作者: liubo
--时间: 20160129
--备注:
----------------------------

cc.exports.Log = {}

--log文件路径
Log.logPath = nil
Log.logName = nil
Log.dateFormat = "_%Y_%m_%d_"
Log.timeFormat = "_%H_%M_%S"

function Log.getLogDir()
    if device.platform == "android" then
        return "/sdcard/logs/"
    else
        return ccFileUtils:getWritablePath() .. "logs/"
    end
end

function Log.saveLogToFile()
    local dir = Log.getLogDir()
    cc.FileUtils:getInstance():createDirectory(dir)
    Log.logName = device.platform .. os.date(Log.dateFormat .. Log.timeFormat) .. ".log"
    Log.logPath = dir .. Log.logName
    cc.Director:getInstance():getConsole():saveLogToFile(Log.logPath)
end

--[[
@brief 关闭日志保存功能
--]]
function Log.stopSaveLog()
    cc.Director:getInstance():getConsole():saveLogToFile(nil)
end

function Log.e( ... )
    if ... == nil then return end
    print("[E]: " .. string.format( ... ))
end

function Log.w( ... )
    if ... == nil then return end
    print("[W]: " .. string.format( ... ))
end

function Log.d( ... )
    if ... == nil then return end
    print("[D]".. os.date() ..": " .. string.format( ... ))
end
