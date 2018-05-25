//
//  ImageCache.h
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache: NSObject

+ (id)sharedManager; // singleton
- (UIImage *)getImageForKey:(NSString *)key;
- (void)downloadImageWithURLString:(NSString *)urlString completionHandler:(void (^)(NSError *, UIImage *))completion;

@end
