//
//  EventDetailViewController.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "EventDetailViewController.h"
#import "ImageCache.h"

@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveMeetupButton;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEvent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _eventImageView.clipsToBounds = YES;
}

- (void)setEvent{
    
    if (_event.highResLink) {
        UIImage *image = [[ImageCache sharedManager] getImageForKey:_event.highResLink];
        if (image) {
                self.eventImageView.image = image;
        } else {
            [[ImageCache sharedManager] downloadImageWithURLString:_event.highResLink completionHandler:^(NSError * error, UIImage *image) {
                if (error)
                    NSLog(@"download image error: %@", error.localizedDescription);
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                            self.eventImageView.image = image;
                    });
                }
            }];
        }
    } else {
        _eventImageView.image = [UIImage imageNamed:@"placeholderImage"];
    }
    
    
    if (!_event.eventName)
        _eventNameLabel.text = @"No Event Name";
    else
        _eventNameLabel.text = _event.eventName;
    
    if (!_event.groupName)
        _groupNameLabel.text = @"No Group Name";
    else
        _groupNameLabel.text = _event.groupName;
    
    if (!_event.localDate)
        _dateLabel.text = @"No Date";
    else
        _dateLabel.text = _event.localDate;
    
    if (!_event.rsvpCount)
        _rsvpCountLabel.text = @"No RSVP Count";
    else
        _rsvpCountLabel.text = _event.eventName;
    
    
    if (!_event.eventDescription)
        _eventDescriptionTextView.text = @"No Event Description";
    else {
        _eventDescriptionTextView.text = _event.eventDescription;
        [_eventDescriptionTextView setValue:self.event.eventDescription forKey:@"contentToHTMLString"];
    }

}
- (IBAction)saveMeetupPressed:(UIBarButtonItem *)sender {
    NSLog(@"Pressed save");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *filename = @"meetups.plist";
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSLog(@"%@", path);
    
    NSMutableArray <Event *> *loadedEvents = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (loadedEvents == nil) {
        loadedEvents = [[NSMutableArray alloc] init];
    }
    [loadedEvents addObject:_event];
    
    BOOL archived = [NSKeyedArchiver archiveRootObject:loadedEvents toFile:path];
    if (!archived) {
        NSLog(@"Error saving event");
    } else {
        NSLog(@"Saved successfully");
    }
    
}


@end
