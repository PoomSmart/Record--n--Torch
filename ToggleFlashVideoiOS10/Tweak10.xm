#import "../TFV.h"

%hook CAMViewfinderViewController

- (void)_startCapturingVideoWithRequest: (id)arg1 {
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
    openCamera10();
    %init;
}
