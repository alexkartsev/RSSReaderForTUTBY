//
//  ViewController.h
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOS-Slide-Menu/SlideNavigationController.h>

@interface MainTableViewController : UITableViewController <SlideNavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfRSSItems;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic) BOOL isFavouriteShow;

@end

