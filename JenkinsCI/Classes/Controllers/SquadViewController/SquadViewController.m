//
//  SquadViewController.m
//  JenkinsCI
//
//  Created by Ciprian Redinciuc on 17/10/14.
//  Copyright (c) 2014 Ciprian Redinciuc. All rights reserved.
//

#import "SquadViewController.h"
#import "PlayerProfileViewController.h"
#import "SquadViewController+TableViewDatasource.h"
#import "Club.h"

static NSString * const kSquadPresentPlayerSegue = @"segue_squadShowPlayer";

@interface SquadViewController ()

@end

@implementation SquadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareFetchedResultsController];
    
    self.title = self.presentedClub.clubName;
}


#pragma mark - NSFetchedResultsController

- (void)prepareFetchedResultsController {
    CoreDataManager *manager = [CoreDataManager sharedInstance];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"club.clubId == %@", self.presentedClub.clubId];
    NSArray *sortingKeys = @[@"position", @"lastName", @"firstName"];
    
    self.fetchedResultsController = [manager fetchedResultsControllerWithEntityName:@"Player"
                                                                          predicate:predicate
                                                                        sortingKeys:sortingKeys
                                                                     sectionNameKey:nil
                                                                          ascending:YES
                                                                           delegate:self];
    self.cellConfigurer = self;
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        DDLogError(@"Fetch Erorr: %@", error);
    }

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kSquadPresentPlayerSegue]) {
        PlayerProfileViewController *playerViewController = (PlayerProfileViewController *)segue.destinationViewController;
        Player *player = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [playerViewController setPresentedPlayer:player];
    }
}

@end
