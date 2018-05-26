//
//  EventDetailViewController.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "EventDetailViewController.h"
#import "ImageCache.h"
#import "NSKeyedArchiverHelper.h"

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
    self.title = @"Event";
     if ([[NSKeyedArchiverHelper sharedManager] isAlreadySaved:_event])
         [_saveMeetupButton setImage:[UIImage imageNamed:@"favorite_filled"]];
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
        _rsvpCountLabel.text = [@"RSVP: " stringByAppendingString:[@(_event.rsvpCount) stringValue]];
        //_rsvpCountLabel.text = [@(_event.rsvpCount) stringValue];
    
    if (!_event.eventDescription)
        _eventDescriptionTextView.text = @"No Event Description";
    else {
        _eventDescriptionTextView.text = _event.eventDescription;
        [_eventDescriptionTextView setValue:self.event.eventDescription forKey:@"contentToHTMLString"];
    }

}
- (IBAction)saveMeetupPressed:(UIBarButtonItem *)sender {
    if ([[NSKeyedArchiverHelper sharedManager] isAlreadySaved:_event]){
        BOOL removed = [[NSKeyedArchiverHelper sharedManager] removeFromFaves:_event];
        if (removed)
            [_saveMeetupButton setImage:[UIImage imageNamed:@"favorite_unfilled"]];
        else
            NSLog(@"Error removing event");
        return;
    }
    
    BOOL saved = [[NSKeyedArchiverHelper sharedManager] addEventToFaves:_event];
    if (saved)
        [_saveMeetupButton setImage:[UIImage imageNamed:@"favorite_filled"]];
    else
        NSLog(@"Error saving event");
}


@end
