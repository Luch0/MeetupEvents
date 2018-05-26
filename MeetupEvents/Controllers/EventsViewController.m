//
//  EventsViewController.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "EventsViewController.h"
#import "EventDetailViewController.h"
#import "MeetupAPI.h"
#import "Event.h"
#import "EventCell.h"

// class extension - private properties and methods
@interface EventsViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <Event *> *events;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    [self.tableView registerClass:EventCell.class forCellReuseIdentifier:@"EventCell"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EventDetailSegue"]) {
        EventDetailViewController *eventDVC = (EventDetailViewController *)[segue destinationViewController];
        NSInteger tagIndex = _tableView.indexPathForSelectedRow.row;
        eventDVC.event = _events[tagIndex];
    }
}

#pragma mark UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    Event *event = self.events[indexPath.row];
    [cell configureViewWithEvent:event];
    return cell;
}

#pragma mark UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"EventDetailSegue" sender:self];
}

#pragma mark UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [MeetupAPI searchEventWithKeyword:searchBar.text completionHandler:^(NSError *error, NSArray<Event *> *events) {
        if (error) {
            NSLog(@"search event error: %@", error.localizedDescription);
        } else {
            self.events = events;
            // UI needs to be updated on Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.title = [NSString stringWithFormat:@"Events (%ld)", self.events.count];
                [self.tableView reloadData];
            });
        }
    }];
}

@end

