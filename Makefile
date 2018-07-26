PACKAGE_VERSION = 1.7.10

include $(THEOS)/makefiles/common.mk

AGGREGATE_NAME = ToggleFlashVideo
SUBPROJECTS = ToggleFlashVideoiOS56 ToggleFlashVideoiOS7 ToggleFlashVideoiOS8 ToggleFlashVideoiOS9AB ToggleFlashVideoLoader

include $(THEOS_MAKE_PATH)/aggregate.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -R TFV $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)
