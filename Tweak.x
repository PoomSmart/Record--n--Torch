#import "Header.h"
#import <PSHeader/CameraApp/CAMViewfinderViewController.h>
#import <PSHeader/CameraMacros.h>

BOOL isFlashIndicator = NO;

%hook CAMViewfinderViewController

- (void)_startCapturingVideoWithRequest:(id)arg1 {
    %orig;
    if (checkModeAndDevice(self._currentMode, self._currentDevice))
        self._flashButton.allowsAutomaticFlash = NO;
}

- (BOOL)_shouldShowIndicatorOfType:(NSUInteger)type forGraphConfiguration:(CAMCaptureGraphConfiguration *)configuration {
    return type == 0 && checkModeAndDevice(configuration.mode, configuration.device) && ([self._captureController isCapturingVideo] || [self._captureController isCapturingTimelapse]) ? YES : %orig;
}

- (BOOL)_shouldHideFlashButtonForGraphConfiguration:(CAMCaptureGraphConfiguration *)configuration {
    return checkModeAndDevice(configuration.mode, configuration.device) && [self._captureController isCapturingVideo] ? NO : %orig;
}

- (void)_updateTopBarStyleForGraphConfiguration:(CAMCaptureGraphConfiguration *)configuration capturing:(BOOL)capturing animated:(BOOL)animated {
    %orig(configuration, isBackCamera(configuration.device) ? NO : capturing, animated);
}

- (void)_handleFlashIndicator {
    isFlashIndicator = YES;
    %orig;
    isFlashIndicator = NO;
}

- (void)_handleUserChangedToFlashMode:(NSInteger)flashMode {
    %orig(flashMode == 2 && isFlashIndicator ? 1 : flashMode);
}

%end

%hook CUCaptureController

- (BOOL)isCapturingVideo {
    return isFlashIndicator ? NO : %orig;
}

%end

%ctor {
    openCamera10();
    %init;
}
