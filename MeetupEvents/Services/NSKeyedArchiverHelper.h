//
//  NSKeyedArchiverHelper.h
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface NSKeyedArchiverHelper : NSObject

+ (instancetype)sharedManager;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSMutableArray <Event *> *meetupEvents;

- (NSString *)documentsDirectory;
- (NSString *)dataFilePath;
- (BOOL)saveMeetupEvents;
- (void)loadMeetupEvents;
- (BOOL)addEventToFaves:(Event*)eventToAdd;
- (NSMutableArray*)getFaveMeetups;
- (BOOL)isAlreadySaved:(Event*)eventToSave;
- (BOOL)removeFromFaves:(Event*)eventToRemove;

@end
