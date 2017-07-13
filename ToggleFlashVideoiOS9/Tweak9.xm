#import "../TFV.h"

%hook CAMViewfinderViewController

- (void)_startCapturingVideoWithRequest: (id)arg1 {
    %orig;
    if (checkModeAndDevice(self._currentMode, self._currentDevice))
        self._flashButton.allowsAutomaticFlash = NO;
}

- (BOOL)_shouldHideFlashButtonForMode:(NSInteger)mode device:(NSInteger)device {
    BOOL orig = %orig;
    return checkModeAndDevice(mode, device) && [self._captureController isCapturingVideo] && orig ? NO : orig;
}

- (void)_updateTopBarStyleForMode:(NSInteger)mode device:(NSInteger)device capturing:(BOOL)capturing animated:(BOOL)animated {
    %orig(mode, device, isBackCamera(device) ? NO : capturing, animated);
}

%end

%ctor {
    openCamera9();
    %init;
}
