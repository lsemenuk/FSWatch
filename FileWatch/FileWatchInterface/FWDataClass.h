//
//  FWDataClass.h
//  FileWatch
//
//  Created by Logan Semenuk on 4/1/19.
//  Copyright © 2019 Logan Semenuk. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef FWDataClass_h
#define FWDataClass_h


@interface FWDataObj : NSObject
@property FSEventStreamRef stream;
@property CFStringRef dirToSearch;
@property CFArrayRef pathsToWatch;
@property void* callbackInfo;
@property CFAbsoluteTime latency;
@property NSMutableArray* FSOperations;
@property int NumFSOperations;
@property FSEventStreamContext context;
@property int max;

//Initializer
-(id)initDirectory:(CFStringRef)directory callBack:(void(*))callBackFunc; //specify own callback
//methods
-(void)addNewFSEvent:(NSString*)fileOperation; //appends to string to FSOperations array
-(void)incrOperations; //increments number of file operations when a new one is deteceted
-(void)startMonitoring;
-(void)stopMonitoring;
-(void)displayFSEvents;
@end


#endif /* FWDataClass_h */
