//
//  FavoritesViewController.m
//  MeetupEvents
//
//  Created by Luis Calle on 5/25/18.
//  Copyright © 2018 Lucho. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Event.h"
#import "EventCell.h"
#import "NSKeyedArchiverHelper.h"
#import "EventDetailViewController.h"

@interface FavoritesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (nonatomic) NSArray <Event *> *loadedMeetups;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Favorites";
    _favoritesTableView.delegate = self;
    _favoritesTableView.dataSource = self;
    [_favoritesTableView registerClass:EventCell.class forCellReuseIdentifier:@"EventCell"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_favoritesTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"FaveEventDetailSegue"]) {
        EventDetailViewController *eventDVC = (EventDetailViewController *)[segue destinationViewController];
        NSInteger tagIndex = _favoritesTableView.indexPathForSelectedRow.row;
        eventDVC.event = [[NSKeyedArchiverHelper sharedManager] getFaveMeetups][tagIndex];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    Event *meetup = [[NSKeyedArchiverHelper sharedManager] getFaveMeetups][indexPath.row];
    [cell configureViewWithEvent:meetup];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[NSKeyedArchiverHelper sharedManager] getFaveMeetups].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"FaveEventDetailSegue" sender:self];
}

@end
