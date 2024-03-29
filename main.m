#include <Foundation/Foundation.h>
#include <AVFoundation/AVFoundation.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        // Ensure there's an argument for the executable path
        if (argc < 2) {
            printf("Usage: %s <path_to_executable> [arguments...]\n\n", argv[0]);
            return 1;
        }

        NSString *executablePath = [NSString stringWithUTF8String:argv[1]];
        NSMutableArray *argumentsArray = [NSMutableArray array];

        // Start from 2 to skip the program name and executable path
        for (int i = 2; i < argc; i++) {
            [argumentsArray addObject:[NSString stringWithUTF8String:argv[i]]];
        }

        // Check microphone permission status
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
            case AVAuthorizationStatusAuthorized:
                printf("Microphone access previously granted.\n");
                break;
            case AVAuthorizationStatusNotDetermined: {
                // Request permission
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        printf("Microphone access granted.\n");
                    } else {
                        printf("Microphone access denied.\n");
                    }
                }];
                break;
            }
            case AVAuthorizationStatusDenied:
                printf("Microphone access denied.\n");
                return 2;
            case AVAuthorizationStatusRestricted:
                printf("Microphone access restricted.\n");
                return 3;
        }

        // Setup and launch the executable as a subprocess
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:executablePath];
        [task setArguments:argumentsArray];

        @try {
            [task launch];
            [task waitUntilExit];
        } @catch (NSException *exception) {
            printf("Failed to launch the specified executable. Exception: %s\n", [[exception reason] UTF8String]);
            return 4;
        }

        printf("Executable finished running.\n");
    }
    return 0;
}
