#define UNRESTRICTED_AVAILABILITY
#import "../PS.h"

#define isBackCamera(device) (device != 1 && device <= 7)
#define checkModeAndDevice(mode, device) (isBackCamera(device) && (mode == 1 || mode == 2 || mode == 5))
