#import "../TFV.h"
#import <objc/runtime.h>

static CAMCaptureController *cameraInstance(){
    return (CAMCaptureController *)[objc_getClass("CAMCaptureController") sharedInstance];
}

#define shouldRun() checkModeAndDevice(cameraInstance().cameraMode, cameraInstance().cameraDevice)

BOOL timelapseOverride;

%hook CAMTopBar

- (void)setStyle: (NSInteger)style animated: (BOOL)animated {
    if (timelapseOverride)
        return;
    %orig;
}

- (void)cam_setHidden:(BOOL)hidden animated:(BOOL)animated {
    %orig(timelapseOverride ? NO : hidden, animated);
}

%end

%hook CAMCameraView

- (void)captureController: (id)arg1 didStartRecordingForVideoRequest: (id)arg2 {
    %orig;
    self._flashButton.allowsAutomaticFlash = NO;
}

- (BOOL)_shouldHideFlashButtonForMode:(NSInteger)mode {
    if ([self _isCapturing] && checkModeAndDevice(mode, [cameraInstance() cameraDevice])) {
        MSHookIvar<BOOL>(self, "__capturing") = NO;
        BOOL orig = %orig;
        MSHookIvar<BOOL>(self, "__capturing") = YES;
        return orig;
    }
    return %orig;
}

- (BOOL)_shouldEnableFlashButton {
    if ([self _isCapturing] && shouldRun()) {
        MSHookIvar<BOOL>(self, "__capturing") = NO;
        BOOL orig = %orig;
        MSHookIvar<BOOL>(self, "__capturing") = YES;
        return orig;
    }
    return %orig;
}

- (void)_showControlsForCapturingVideoAnimated:(BOOL)animated {
    %orig;
    [self._flashButton cam_setHidden:NO animated:animated];
}

- (void)_showControlsForCapturingTimelapseAnimated:(BOOL)animated {
    timelapseOverride = YES;
    %orig;
    timelapseOverride = NO;
    self._flashButton.allowsAutomaticFlash = NO;
}

%end

%ctor {
    openCamera8();
    %init;
}
