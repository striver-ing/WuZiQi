LOCAL_PATH := $(call my-dir)
EXTERNAL_PATH := $(LOCAL_PATH)/../../../../../external

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

# 遍历目录及子目录的函数
define walk
$(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))
endef

# 遍历Classes目录
ALLFILES = $(call walk, $(LOCAL_PATH)/../../../Classes)

# 手动添加些cpp文件
FILE_LIST := hellolua/main.cpp \
$(EXTERNAL_PATH)/BleManager.cpp \
$(EXTERNAL_PATH)/NetworkManagerFactory.cpp \
$(EXTERNAL_PATH)/NetworkManagerProtocol.cpp \
$(EXTERNAL_PATH)/luabinding/lua_wuziqi_auto.cpp \
$(EXTERNAL_PATH)/luabinding/lua_wuziqi_manual.cpp \
$(EXTERNAL_PATH)/platform/android/BleManagerImpl.cpp \

# 从所有文件中提取出所有.cpp文件
FILE_LIST += $(filter %.cpp, $(ALLFILES))
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

#文件夹包含
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
$(EXTERNAL_PATH) \
$(EXTERNAL_PATH)\luabinding \
$(EXTERNAL_PATH)\platform/android

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
