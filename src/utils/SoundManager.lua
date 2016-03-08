----------------------------
--版权: 564773807@qq.com
--作用: 声音管理
--作者: liubo
--时间: 20160307
--备注:
----------------------------
cc.exports.SoundManager = {}

local _useEffect = true
local bgMusic = "chq.mp3"

function SoundManager.init()
    cc.SimpleAudioEngine:getInstance():preloadEffect("btn.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect("chess.wav")

    local button = ccui.Button

    --因为addTouchEventListener是widget的函数，所以两层getmetatable
    local mt = getmetatable(getmetatable(button))

    local oldTouchFunc = mt.addTouchEventListener
    button.addTouchEventListener = function (self, func, soundFile)
        oldTouchFunc(self, function (sender, eventType)
            if eventType == ccui.TouchEventType.began then
                 SoundManager.playEffect(soundFile or "btn.wav")
            end

            if eventType == ccui.TouchEventType.ended then
                func(sender, eventType)
            end
        end)
    end

    SoundManager.startMusic()
end

function SoundManager.startMusic()
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusic, true)
end

function SoundManager.stopMusic()
    cc.SimpleAudioEngine:getInstance():stopMusic()
end

function SoundManager.setMusicVolume(volume)
    cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end

function SoundManager.setEffectsEnable(bOpen)
    _useEffect = bOpen
    ccUserDefault:setBoolForKey(SAVA_STRING_SOUND_EFFECT_ENABLE, _useEffect)
end

function SoundManager.isEffectsEnable()
    _useEffect = ccUserDefault:getBoolForKey(SAVA_STRING_SOUND_EFFECT_ENABLE, true);
    return _useEffect
end

function SoundManager.playEffect(soundFile)
    if _useEffect then
        cc.SimpleAudioEngine:getInstance():playEffect(soundFile)
    end
end

return SoundManager




