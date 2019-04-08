//
//  FWDataClass.m
//  FileWatch
//
//  Created by Logan Semenuk on 4/2/19.
//  Copyright © 2019 Logan Semenuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWDataClass.h"

@implementation FWDataObj
-(id)initDirectory:(CFStringRef)directory callBack:(void(*))callBackFunc{
    //printf("In custom constructor\n");
    self = [super init];
    
    if(self) {
        _max = 4;
        _FSOperations = [[NSMutableArray alloc] init];
        _context.copyDescription = NULL;
        _context.info = (__bridge void *)self;
        _context.release = NULL;
        _context.version = 0;
        _dirToSearch = directory;
        _pathsToWatch = CFArrayCreate(NULL, (const void **)&_dirToSearch, 1, NULL);
        _callbackInfo = &_context;
        _latency = 2.0;
        _stream = FSEventStreamCreate(NULL, callBackFunc, _callbackInfo, _pathsToWatch,
                                     kFSEventStreamEventIdSinceNow, _latency,
                                     kFSEventStreamCreateFlagNone);
        
        //printf("object pointer: %p\n", self);
    }
    return self;
}

-(void)addNewFSEvent:(NSString*)fileOperation {
    [_FSOperations addObject:fileOperation];
}

-(void)incrOperations {
    if(_NumFSOperations == _max) {
        [self stopMonitoring];
    }
    ++_NumFSOperations;
}
-(void)startMonitoring {
    FSEventStreamScheduleWithRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamStart(_stream);
    CFRunLoopRun();
}
-(void)stopMonitoring {
    printf("You have reached the max number of events recorded... Please update _max to change");
    FSEventStreamStop(_stream);
    FSEventStreamInvalidate(_stream);
    FSEventStreamRelease(_stream);
    CFRunLoopStop(CFRunLoopGetMain());
}
-(void)displayFSEvents {
    for(int i = 0; i < [_FSOperations count]; ++i) {
        printf("array: %s", [_FSOperations[i] UTF8String]);
    }
}

@end
