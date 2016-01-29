----------------------------
--版权：
--作用: 初始化lua相关模块
--作者: liubo
--时间: 20160129
--备注:
----------------------------

cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("res/playui/")

require "utils.Log"