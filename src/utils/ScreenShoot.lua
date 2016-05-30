----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-05-30 18:50:37
--作用: 截屏
--备注:
----------------------------

local ScreenShoot = {}

-- afterCapturedCallFunc(succeed, outputFile)
function ScreenShoot.captured(fileName, afterCapturedCallFunc)
    cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
    cc.utils:captureScreen(afterCapturedCallFunc, fileName)
end

return ScreenShoot;