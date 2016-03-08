----------------------------
--版权: 564773807@qq.com
--作用: 初始化lua相关模块
--作者: liubo
--时间: 20160129
--备注:
----------------------------

cc.FileUtils:getInstance():addSearchPath("res/sound/effect")
cc.FileUtils:getInstance():addSearchPath("res/sound/music")
cc.FileUtils:getInstance():addSearchPath("res/images/playui/")
cc.FileUtils:getInstance():addSearchPath("res/images/startui/")

require "utils.Log"
require "utils.SoundManager"