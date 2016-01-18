//
//  DataBaseManager.h
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "New.h"
#import <UIKit/UIKit.h>
#import "LastUpdate.h"

@interface DataBaseManager : NSObject

@property (nonatomic, strong) LastUpdate *myLastUpdate;

+ (instancetype) sharedManager;
- (void)setImage:(UIImage *)image forNew: (New *)myNew;
- (void)insertNewWithTitle:(NSString *)title
               withPudDate:(NSDate *) pudDate
                  withLink:(NSString *)link
       withItemDescription:(NSString *)itemDescription
             withImageLink:(NSString *)imageLink;
-(void) refreshLastUpdate;
@end
