//
//  NSKeyedArchiverHelper.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "NSKeyedArchiverHelper.h"
#import "Event.h"

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


- (BOOL)saveMeetupEvents {
    NSString *path = [[NSKeyedArchiverHelper sharedManager] dataFilePath];
    return [NSKeyedArchiver archiveRootObject:_meetupEvents toFile:path];
}

- (void)loadMeetupEvents {
    NSString *path = [[NSKeyedArchiverHelper sharedManager] dataFilePath];
    _meetupEvents = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (_meetupEvents == nil) {
        _meetupEvents = [[NSMutableArray alloc] init];
    }
}

- (BOOL)addEventToFaves:(Event*)eventToAdd {
    [_meetupEvents addObject:eventToAdd];
    return [[NSKeyedArchiverHelper sharedManager] saveMeetupEvents];
}

- (NSMutableArray*)getFaveMeetups {
    return _meetupEvents;
}

- (BOOL)isAlreadySaved:(Event*)eventToSave {
    return [_meetupEvents containsObject:eventToSave];
}

- (BOOL)removeFromFaves:(Event*)eventToRemove {
    [_meetupEvents removeObject:eventToRemove];
    return [[NSKeyedArchiverHelper sharedManager] saveMeetupEvents];
}

@end
