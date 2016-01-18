//
//  LeftMenuTableViewController.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "LeftMenuTableViewController.h"
#import <iOS-Slide-Menu/SlideNavigationController.h>
#import "SlideNavigationContorllerAnimator.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "MainTableViewController.h"

static NSString *cellIdentifier = @"LeftMenuTableViewCell";
static CGFloat maximumFadeAlpha = .8;
static CGFloat slideMovement = 100;
static CGFloat animationDuration = .19;
static CGFloat portraitSlideOffset = 170;
static NSString *imageStarName = @"star";
static NSString *imageNewspaperName = @"newspaper";

@interface LeftMenuTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *arrayOfNames;

@end

@implementation LeftMenuTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //animation
    id <SlideNavigationContorllerAnimator> revealAnimator;
    revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:maximumFadeAlpha fadeColor:[UIColor blackColor] andSlideMovement:slideMovement];
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
    [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
    [SlideNavigationController sharedInstance].portraitSlideOffset = portraitSlideOffset;
    
    //selecting cell at start
    NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.myTableView didSelectRowAtIndexPath:selectedCellIndexPath];
    [self.myTableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    self.arrayOfNames = [NSArray arrayWithObjects:@"Все новости", @"Избранные", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfNames.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    MainTableViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainTableView"];
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Favourite News Change" object:@"all"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Favourite News Change" object:@"favourite"];
    }
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:YES
                                                                     andCompletion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.arrayOfNames objectAtIndex:indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:imageNewspaperName];
            break;
        }
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:imageStarName];
            cell.imageView.tintColor = [UIColor orangeColor];
            break;
        }
        default:
            break;
    }
    return cell;
}

@end
