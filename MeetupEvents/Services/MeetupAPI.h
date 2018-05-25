//
//  MeetupAPI.h
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface MeetupAPI: NSObject

// Making this a class method helps us call the method directly e.g [MeetupAPI searchEventWithKeyword:]
+ (void)searchEventWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSError *error, NSArray <Event *> *events))completion;

@end
