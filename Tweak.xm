#import "Header.h"
#import "../PSHeader/CameraApp/CAMViewfinderViewController.h"
#import "../PSHeader/CameraMacros.h"
#import "../PSPrefs/PSPrefs.x"

NSString *tweakIdentifier = @"com.PS.ToggleFlashVideo";

BOOL TFVNative;

HaveCallback() {
    GetPrefs();
    GetBool(TFVNative, @"TFVNative", YES);
}

%hook CAMViewfinderViewController

- (void)_startCapturingVideoWithRequest:(id)arg1 {
    %orig;
    if (checkModeAndDevice(self._currentMode, self._currentDevice))
        self._flashButton.allowsAutomaticFlash = NO;
}

- (BOOL)_shouldHideFlashButtonForGraphConfiguration:(CAMCaptureGraphConfiguration *)configuration {
    return checkModeAndDevice(configuration.mode, configuration.device) && [self._captureController isCapturingVideo] ? NO : %orig;
}

- (void)_updateTopBarStyleForGraphConfiguration:(CAMCaptureGraphConfiguration *)configuration capturing:(BOOL)capturing animated:(BOOL)animated {
    %orig(configuration, isBackCamera(configuration.device) ? NO : capturing, animated);
}

%end

%ctor {
    HaveObserver();
    callback();
    if (TFVNative) {
        openCamera10();
        %init;
    }
}
