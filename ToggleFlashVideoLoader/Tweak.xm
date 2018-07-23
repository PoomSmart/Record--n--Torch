#import "../../PS.h"
#import "../../PSPrefs.x"
#import <dlfcn.h>

NSString *tweakIdentifier = @"com.PS.ToggleFlashVideo";

BOOL TFVNative;

HaveCallback() {
    GetPrefs()
    GetBool(TFVNative, @"TFVNative", YES)
}

%ctor {
    if (IN_SPRINGBOARD && isiOS7Up)
        return;
    HaveObserver();
    callback();
    if (TFVNative) {
        if (isiOS9Up)
            dlopen("/Library/MobileSubstrate/DynamicLibraries/RecordNTorch/ToggleFlashVideoiOS9AB.dylib", RTLD_LAZY);
        else if (isiOS8)
            dlopen("/Library/MobileSubstrate/DynamicLibraries/RecordNTorch/ToggleFlashVideoiOS8.dylib", RTLD_LAZY);
        else if (isiOS7)
            dlopen("/Library/MobileSubstrate/DynamicLibraries/RecordNTorch/ToggleFlashVideoiOS7.dylib", RTLD_LAZY);
#if !__LP64__
        else
            dlopen("/Library/MobileSubstrate/DynamicLibraries/RecordNTorch/ToggleFlashVideoiOS56.dylib", RTLD_LAZY);
#endif
    }
}
