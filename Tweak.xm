#import "../PS.h"
#import "../PSPrefs.x"
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
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS910.dylib", RTLD_LAZY);
        else if (isiOS8)
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS8.dylib", RTLD_LAZY);
        else if (isiOS7)
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS7.dylib", RTLD_LAZY);
#if !__LP64__
        else
            dlopen("/Library/Application Support/RecordNTorch/ToggleFlashVideoiOS56.dylib", RTLD_LAZY);
#endif
    }
}
