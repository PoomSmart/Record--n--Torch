TARGET = iphone:latest
DEBUG = 0
PACKAGE_VERSION = 1.7.8

include $(THEOS)/makefiles/common.mk

AGGREGATE_NAME = ToggleFlashVideo
SUBPROJECTS = ToggleFlashVideoiOS56 ToggleFlashVideoiOS7 ToggleFlashVideoiOS8 ToggleFlashVideoiOS9 ToggleFlashVideoiOS10

include $(THEOS_MAKE_PATH)/aggregate.mk

TWEAK_NAME = ToggleFlashVideo
ToggleFlashVideo_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -R TFV $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)
