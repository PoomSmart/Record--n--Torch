#define KILL_PROCESS
#import "../PS.h"
#import "TFV.h"
#import <dlfcn.h>

CFStringRef PreferencesChangedNotification = CFSTR("com.PS.ToggleFlashVideo.settingschanged");
NSString *PREF_PATH = @"/var/mobile/Library/Preferences/com.PS.ToggleFlashVideo.plist";
NSString *tfvNativeKey = @"TFVNative";

BOOL TFVNative = YES;

static void TFVLoader() {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    TFVNative = prefs[tfvNativeKey] ? [prefs[tfvNativeKey] boolValue] : YES;
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    killProcess("Camera");
    TFVLoader();
}

%ctor {
    if (IN_SPRINGBOARD && isiOS7Up)
        return;
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, PreferencesChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
    TFVLoader();
    if (TFVNative) {
        if (isiOS10Up)
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS10.dylib", RTLD_LAZY);
        else if (isiOS9)
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS9.dylib", RTLD_LAZY);
        else if (isiOS8)
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS8.dylib", RTLD_LAZY);
        else if (isiOS7)
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS7.dylib", RTLD_LAZY);
        else
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS56.dylib", RTLD_LAZY);
    }
}
