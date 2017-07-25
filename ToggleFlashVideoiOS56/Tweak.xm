#import "../TFV.h"

static PLCameraController *cameraInstance() {
    return (PLCameraController *)[NSClassFromString(@"PLCameraController") sharedInstance];
}

#define shouldRun() checkModeAndDevice(cameraInstance().cameraMode, cameraInstance().cameraDevice)

%hook PLCameraFlashButton

- (void)_collapseAndSetMode: (NSInteger)mode animated: (BOOL)animated {
    BOOL isCapturingVideo = [cameraInstance() isCapturingVideo];
    if (shouldRun() && mode == 0 && isCapturingVideo) {
        %orig(-1, animated);
        return;
    }
    %orig;
}

%end

%hook PLCameraView

- (void)_updateOverlayControls {
    %orig;
    if (shouldRun())
        MSHookIvar<PLCameraFlashButton *>(self, "_flashButton").hidden = NO;
}

- (void)_postCaptureCleanup {
    %orig;
    if (shouldRun())
        MSHookIvar<PLCameraFlashButton *>(self, "_flashButton").hidden = NO;
}

- (void)cameraShutterClicked:(id)arg1 {
    %orig;
    if (shouldRun()) {
        PLCameraFlashButton *flashBtn = MSHookIvar<PLCameraFlashButton *>(self, "_flashButton");
        flashBtn.hidden = NO;
        flashBtn.userInteractionEnabled = YES;
    }
}

- (void)cameraControllerVideoCaptureDidStart:(id)start {
    %orig;
    if (shouldRun())
        MSHookIvar<PLCameraFlashButton *>(self, "_flashButton").autoHidden = NO;
}

%end

%ctor {
    openCamera6();
    %init;
}
