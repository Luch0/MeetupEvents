//
//  ImageCache.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "ImageCache.h"
#import "NetworkHelper.h"

@interface ImageCache ()
// NSCache stores objects to the caches directory. This prevents the redownloading of existing assets.
@property (nonatomic) NSCache *sharedCache;
@property (nonatomic) NSMutableURLRequest *urlRequest;
@end

@implementation ImageCache
// Singleton pattern in Objective-C
+ (instancetype)sharedManager {
    static ImageCache *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // initialize properties here...
        _sharedCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    [self.sharedCache setObject:image forKey:key];
}

- (UIImage *)getImageForKey:(NSString *)key {
    return [self.sharedCache objectForKey:key];
}

- (void)downloadImageWithURLString:(NSString *)urlString completionHandler:(void (^)(NSError *, UIImage *))completion {
    if (!_urlRequest)
        _urlRequest = [[NSMutableURLRequest alloc] init];
    self.urlRequest.URL = [NSURL URLWithString:urlString];
    [[NetworkHelper sharedManager] performRequestWithRequest:self.urlRequest completionHandler:^(NSError *error, NSData *data) {
        if (error) {
            completion(error, nil);
        } else {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self cacheImage:image forKey:urlString];
            completion(nil, image);
        }
    }];
}
@end
