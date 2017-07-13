#import "../TFV.h"
#import <objc/runtime.h>

static PLCameraController *cameraInstance(){
    return (PLCameraController *)[objc_getClass("PLCameraController") sharedInstance];
}

#define shouldRun() checkModeAndDevice(cameraInstance().cameraMode, cameraInstance().cameraDevice)

BOOL override;

%group iOS71

%hook CAMTopBar

- (void)_updateHiddenViewsForButtonExpansionAnimated: (BOOL)animated {
    %orig;
    BOOL isCapturingVideo = [cameraInstance() isCapturingVideo];
    if (isCapturingVideo && shouldRun())
        [self.flashButton pl_setHidden:NO animated:YES];
}

%end

%end

%group Common

%hook CAMTopBar

- (void)_setFlashButtonExpanded: (BOOL)expand {
    %orig;
    BOOL isCapturingVideo = [cameraInstance() isCapturingVideo];
    if (isCapturingVideo && shouldRun())
        [self.elapsedTimeView pl_setHidden:expand animated:YES];
}

%end

%hook PLCameraView

- (BOOL)_flashButtonShouldBeHidden {
    BOOL isCapturingVideo = [cameraInstance() isCapturingVideo];
    override = isCapturingVideo && shouldRun();
    BOOL orig = %orig;
    override = NO;
    return orig;
}

- (BOOL)_shouldHideFlashButtonForMode:(int)mode {
    if ([self _isCapturing] && shouldRun()) {
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
    if (shouldRun()) {
        [self._topBar setStyle:0 animated:NO];
        [self _updateTopBarStyleForDeviceOrientation:[cameraInstance() cameraOrientation]];
        if (isiOS70) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.28 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                [self._flashButton pl_setHidden:NO animated:animated];
            });
        } else
            [self._flashButton pl_setHidden:NO animated:animated];
    }
}

- (void)cameraControllerVideoCaptureDidStart:(id)start {
    %orig;
    if (shouldRun())
        MSHookIvar<CAMFlashButton *>(self, "__flashButton").autoHidden = YES;
}

%end

%end

%ctor {
    openCamera7();
    if (isiOS71) {
        %init(iOS71);
    }
    %init(Common);
}
