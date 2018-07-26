#define UNRESTRICTED_AVAILABILITY
#import "../PS.h"

#define isBackCamera(device) (device != 1)
#define checkModeAndDevice(mode, device) (isBackCamera(device) && (mode == 1 || mode == 2 || mode == 6))
