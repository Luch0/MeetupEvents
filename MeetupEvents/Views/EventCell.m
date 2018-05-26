//
//  EventCell.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "EventCell.h"
#import "ImageCache.h"

#define PADDING 10

// class extension
@interface EventCell ()
@property (nonatomic) UIImageView *eventImage;
@property (nonatomic) UILabel *eventDate;
@property (nonatomic) UILabel *eventName;
@property (nonatomic) UILabel *groupName;
@property (nonatomic, copy) NSString *urlString;
@end

@implementation EventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:@"EventCell"];
    if (self) {
        // setup views
        [self setupViews];
        _urlString = [[NSString alloc] init];
    }
    return self;
}

- (void)setupViews {
    [self setupEventImage];
    [self setupEventDate];
    [self setupEventName];
    [self setupGroupName];
}

- (void)setupEventImage {
    if (!_eventImage)
        _eventImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder-image"]];
    [self addSubview:self.eventImage];
    self.eventImage.contentMode = UIViewContentModeScaleAspectFill;
    self.eventImage.clipsToBounds = YES;
    
    // set constraints using batch constraints
    self.eventImage.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.eventImage.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [self.eventImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                              [self.eventImage.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                              [self.eventImage.widthAnchor constraintEqualToAnchor:self.heightAnchor]
                                              ]];
}

- (void)setupEventDate {
    if (!_eventDate)
        _eventDate = [[UILabel alloc] init];
    [self addSubview:self.eventDate];
    self.eventDate.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    self.eventDate.numberOfLines = 1;
    
    // setup constraints
    self.eventDate.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.eventDate.topAnchor constraintEqualToAnchor:self.topAnchor constant: PADDING],
                                              [self.eventDate.leadingAnchor constraintEqualToAnchor:self.eventImage.trailingAnchor constant: PADDING]
                                              ]];
}

- (void)setupEventName {
    if (!_eventName)
        _eventName = [[UILabel alloc] init];
    [self addSubview:self.eventName];
    self.eventName.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.eventName.numberOfLines = 0;
    
    // setup constraints
    self.eventName.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.eventName.topAnchor constraintEqualToAnchor:self.eventDate.bottomAnchor constant: PADDING],
                                              [self.eventName.leadingAnchor constraintEqualToAnchor:self.eventImage.trailingAnchor constant: PADDING],
                                              [self.eventName.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -PADDING]
                                              ]];
}

- (void)setupGroupName {
    //setup group name
    if (!_groupName)
        _groupName = [[UILabel alloc] init];
    [self addSubview:self.groupName];
    self.groupName.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    self.groupName.numberOfLines = 1;
    
    // setup constraints
    self.groupName.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.groupName.topAnchor constraintEqualToAnchor:self.eventName.bottomAnchor constant: PADDING],
                                              [self.groupName.leadingAnchor constraintEqualToAnchor:self.eventImage.trailingAnchor constant: PADDING],
                                              [self.groupName.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -PADDING],
                                              [self.groupName.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant: -PADDING]
                                              ]];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.eventImage.image = [UIImage imageNamed:@"placeholder-image"];
    self.urlString = @"";
}

- (void)configureViewWithEvent:(Event *)event {
    self.eventImage.image = [UIImage imageNamed:@"placeholder-image"];
    // configure date
    if (!event.localDate)
        self.eventDate.text = @"No Date";
    else
        self.eventDate.text = event.localDate;
    
    // configure event name
    if (!event.eventName)
        self.eventName.text = @"No Name";
    else
        self.eventName.text = event.eventName;
    
    // configure group name
    if (!event.groupName)
        self.groupName.text = @"No Group Name";
    else
        self.groupName.text = event.groupName;
    
    // configure image using ImageCache
    // this solution can be achieved through the use a cocoapod e.g SDWebImage...
    if (event.highResLink) {
        self.urlString = event.highResLink;
        UIImage *image = [[ImageCache sharedManager] getImageForKey:event.highResLink];
        if (image) {
            if([self.urlString isEqualToString:event.highResLink])
                self.eventImage.image = image;
        }
        else {
            [[ImageCache sharedManager] downloadImageWithURLString:event.highResLink completionHandler:^(NSError * error, UIImage *image) {
                if (error)
                    NSLog(@"download image error: %@", error.localizedDescription);
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([self.urlString isEqualToString:event.highResLink])
                            self.eventImage.image = image;
                    });
                }
            }];
        }
    } else {
        _eventImage.image = [UIImage imageNamed:@"placeholderImage"];
    }
}

@end
