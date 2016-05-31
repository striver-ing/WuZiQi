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

-- function ScreenShoot.screenShotCut(savedPicName)
--     local winSize = cc.Director:getInstance():getWinSize()
--     local fullScreenRender = cc.RenderTexture:create(winSize.width, winSize.height)
--     local runningScene = cc.Director:getInstance():getRunningScene()
--     fullScreenRender:begin()
--     runningScene:visit()
--     fullScreenRender:endToLua()
--     local picType = string.sub(savedPicName, -3)
--     if picType == "png" then
--         fullScreenRender:saveToFile(savedPicName, 1, false)
--     elseif picType == "jpg" then
--         fullScreenRender:saveToFile(savedPicName, 0, false)
--     else
--         fullScreenRender:saveToFile(savedPicName .. ".png", 1)
--     end
-- end

return ScreenShoot;