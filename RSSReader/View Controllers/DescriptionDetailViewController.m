//
//  DescriptionDetailViewViewController.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "DescriptionDetailViewController.h"
#import "MBProgressHUD.h"
#import "WebDetailViewController.h"
#import <MagicalRecord/MagicalRecord.h>

@interface DescriptionDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *starBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL isFavourite;
@end

static NSString *kPlaceHolderImageKey = @"logo_tut_by";

@implementation DescriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.item.title;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.descriptionTextView.text = self.item.itemDescription;
    if ([self.item.favourite isEqual:@YES]) {
        self.starBarButtonItem.tintColor=[UIColor orangeColor];
        self.isFavourite = YES;
    }
    else
    {
        self.starBarButtonItem.tintColor=[UIColor blackColor];
        self.isFavourite = NO;
    }
    if (self.item.image) {
        self.myImageView.image = [UIImage imageWithData:self.item.image];
    }
    else {
        self.myImageView.image = [UIImage imageNamed:kPlaceHolderImageKey];
    }
}

- (IBAction)didPressFavouriteButton:(id)sender {
    if (self.isFavourite) {
        self.starBarButtonItem.tintColor=[UIColor blackColor];
        self.isFavourite = NO;
        self.item.favourite = @NO;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    }
    else
    {
        self.starBarButtonItem.tintColor=[UIColor orangeColor];
        self.isFavourite = YES;
        self.item.favourite = @YES;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        New *object = self.item;
        WebDetailViewController *controller = (WebDetailViewController *)[segue destinationViewController];
        [controller setItem:object];
    }
}

@end
