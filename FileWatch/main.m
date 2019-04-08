//
//  main.m
//  FileWatch
//
//  Created by Logan Semenuk on 3/28/19.
//  Copyright © 2019 Logan Semenuk. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FileWatchInterface/FWDataClass.h"
#include <CoreServices/CoreServices.h>

void myCallbackFunction(//where all the data processing is handled
                ConstFSEventStreamRef streamRef,
                void *info, //a pointer allowing u to pass export stream data
                size_t numEvents,
                void *eventPaths,
                const FSEventStreamEventFlags eventFlags[],
                const FSEventStreamEventId eventIds[])

{
    int i;
    char **paths = eventPaths;
    for (i=0; i<numEvents; i++) {
        /* flags are unsigned long, IDs are uint64_t */
        NSString* fsString = [NSString stringWithFormat:@"Change %llu in %s, flags %lu\n", eventIds[i], paths[i], eventFlags[i]];
        printf("%s", [fsString UTF8String]);
        [(__bridge FWDataObj*)info addNewFSEvent:fsString];
        [(__bridge FWDataObj*)info incrOperations];
        
    }
    
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        CFStringRef mypath = CFSTR("/Users/logansemenuk/Desktop");
//        CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
//        void *callbackInfo = NULL; // could put stream-specific data here.
//        FSEventStreamRef stream;
//        CFAbsoluteTime latency = 3.0; /* Latency in seconds */
//
//        stream = FSEventStreamCreate(NULL, &myCallbackFunction, callbackInfo, pathsToWatch,
//                                     kFSEventStreamEventIdSinceNow, /* Or a previous event ID */ latency,
//                                     kFSEventStreamCreateFlagNone /* Flags explained in reference */);
//        FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
//        FSEventStreamStart(stream);
//        CFRunLoopRun();
        CFStringRef mydir = CFSTR("/Users/logansemenuk/Desktop");
        void* callback = myCallbackFunction;
        FWDataObj* test = [[FWDataObj alloc] initDirectory:mydir callBack:callback];
        [test startMonitoring];
        [test displayFSEvents];
    }
}
