//
//  ViewController.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "MyRSSParser.h"
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"
#import "DataBaseManager.h"
#import "New.h"
#import <MagicalRecord/MagicalRecord.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DescriptionDetailViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static NSString *cellIdentifier = @"MainTableViewCell";
static NSString *path = @"all.rss";
static CGFloat estimatedRowHeight = 80.0;
static NSString *imagePlaceholderName = @"logo_tut_by";

@interface MainTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic ,strong) NSFetchRequest *fetchRequest;
@property (nonatomic ,strong) NSFetchRequest *fetchRequestFavourite;
@end

@implementation MainTableViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIBarButtonItem appearance].tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isFavouriteView:) name:@"Favourite News Change" object:nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(updateData)
                  forControlEvents:UIControlEventValueChanged];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"dd MMMM yyyy";
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [self.formatter setLocale:usLocale];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.layer.zPosition = 2;
    self.tableView.layer.zPosition = 1;

    [self updateData];
    self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    self.fetchRequest = [New MR_requestAllSortedBy:@"pubDate" ascending:NO];
    
    NSString *predicateFormat = @"%K == %@";
    NSString *searchAttribute = @"favourite";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, @YES];
    self.fetchRequestFavourite = [New MR_requestAllSortedBy:@"pubDate" ascending:NO withPredicate:predicate];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    self.tableView.estimatedRowHeight = estimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) updateData {
    [[MyRSSParser sharedManager] parseRSSFeedAtPath:path success:^(NSArray *feedItems) {
        [self.tableView reloadData];
        if (self.hud) {
            [self.hud hide:YES];
        }
        if (self.refreshControl)
        {
            [self.refreshControl endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetailView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        New *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        DescriptionDetailViewController *controller = (DescriptionDetailViewController *)[segue destinationViewController];
        [controller setItem:object];
    }
}

- (void) isFavouriteView: (NSNotification *) notification {
    if ([notification.object isEqualToString:@"favourite"] && !self.isFavouriteShow)
    {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequestFavourite managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        // Configure Fetched Results Controller
        [self.fetchedResultsController setDelegate:self];
        
        // Perform Fetch
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        self.isFavouriteShow = YES;
        [self.tableView reloadData];
    }
    else if ([notification.object isEqualToString:@"all"] && self.isFavouriteShow)
    {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        // Configure Fetched Results Controller
        [self.fetchedResultsController setDelegate:self];
        
        // Perform Fetch
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        self.isFavouriteShow = NO;
        if (error) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        [self.tableView reloadData];
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (MainTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    New *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleOfCell.text = record.title;
    cell.titleOfCell.numberOfLines = 0;
    NSString *eventDate = [self.formatter stringFromDate:record.pubDate];
    cell.dateOfCell.text = [NSString stringWithFormat:@"%@ г.",eventDate];
    cell.tag = indexPath.row;
    cell.imageOfCell.image = nil;
    if (record.imageLink) {
        if (record.image) {
            cell.imageOfCell.image = [UIImage imageWithData:record.image];
        }
        else
        {
            
            [cell.imageOfCell sd_setImageWithURL:[NSURL URLWithString:record.imageLink] placeholderImage:[UIImage imageNamed:imagePlaceholderName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [[DataBaseManager sharedManager] setImage:image forNew:record];
            }];
        }
    }
    else
    {
        cell.imageOfCell.image = [UIImage imageNamed:imagePlaceholderName];
    }
    if ([record.favourite isEqual:@YES]) {
        cell.starImageView.tintColor = [UIColor orangeColor];
        cell.starImageView.hidden = NO;
    }
    else
    {
        cell.starImageView.hidden = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}


@end
