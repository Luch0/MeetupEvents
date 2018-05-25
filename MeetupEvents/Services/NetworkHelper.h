//
//  NetworkHelper.h
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

// class method is denoted by a + symbol
+ (instancetype)sharedManager;

// instance method is denoted by a - symbol
- (void)performRequestWithRequest:(NSURLRequest *)request completionHandler:(void(^)(NSError *error, NSData *data))completion;

@end
