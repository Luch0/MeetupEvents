//
//  NSKeyedArchiverHelper.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "NSKeyedArchiverHelper.h"

@implementation NSKeyedArchiverHelper


+ (instancetype)sharedManager {
    static NSKeyedArchiverHelper *nsKeyedArchiverHelper;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        nsKeyedArchiverHelper = [[NSKeyedArchiverHelper alloc] init];
    });
    return nsKeyedArchiverHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _filename = @"meetups.plist";
    }
    return self;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    return documentsDirectory;
}


- (NSString *)dataFilePath {
    return [[[NSKeyedArchiverHelper sharedManager] documentsDirectory] stringByAppendingPathComponent:_filename];
}


- (void)saveMeetupEvents {
    NSString *path = [[NSKeyedArchiverHelper sharedManager] dataFilePath];
    [NSKeyedArchiver archiveRootObject:_meetupEvents toFile:path];
}

- (void)loadMeetupEvents {
    NSString *path = [[NSKeyedArchiverHelper sharedManager] dataFilePath];
    _meetupEvents = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (_meetupEvents == nil) {
        _meetupEvents = [[NSMutableArray alloc] init];
    }
}

- (void)addEventToFaves:(Event*)eventToAdd {
    [_meetupEvents addObject:eventToAdd];
    [[NSKeyedArchiverHelper sharedManager] saveMeetupEvents];
}

- (NSMutableArray*)getFaveMeetups {
    return _meetupEvents;
}

@end
