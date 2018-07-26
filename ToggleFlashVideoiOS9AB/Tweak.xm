#import "../TFV.h"

%hook CAMViewfinderViewController

- (void)_startCapturingVideoWithRequest: (id)arg1 {
    %orig;
    if (checkModeAndDevice(self._currentMode, self._currentDevice))
        self._flashButton.allowsAutomaticFlash = NO;
}

%group iOS9

- (BOOL)_shouldHideFlashButtonForMode: (NSInteger)mode device: (NSInteger)device {
    BOOL orig = %orig;
    return checkModeAndDevice(mode, device) && [self._captureController isCapturingVideo] && orig ? NO : orig;
}

- (void)_updateTopBarStyleForMode:(NSInteger)mode device:(NSInteger)device capturing:(BOOL)capturing animated:(BOOL)animated {
    %orig(mode, device, isBackCamera(device) ? NO : capturing, animated);
}

%end

%group iOS10Up

- (BOOL)_shouldHideFlashButtonForGraphConfiguration: (CAMCaptureGraphConfiguration *)configuration {
    return checkModeAndDevice(configuration.mode, configuration.device) && [self._captureController isCapturingVideo] ? NO : %orig;
}

- (void)_updateTopBarStyleForGraphConfiguration:(CAMCaptureGraphConfiguration *)configuration capturing:(BOOL)capturing animated:(BOOL)animated {
    %orig(configuration, isBackCamera(configuration.device) ? NO : capturing, animated);
}

%end

%end

%ctor {
    openCamera9();
    if (isiOS10Up) {
        %init(iOS10Up);
    } else {
        %init(iOS9);
    }
    %init;
}
