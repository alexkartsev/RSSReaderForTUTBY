//
//  DataBaseManager.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "DataBaseManager.h"
#import "LastUpdate.h"
#import "LastUpdate+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>

@interface DataBaseManager()

@end
@implementation DataBaseManager

+ (instancetype) sharedManager {
    static DataBaseManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc] init];
        // Fetch entities with MagicalRecord
        NSArray *array = [[LastUpdate MR_findAll] mutableCopy];
        if (!array.count)
        {
            NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
            mmddccyy.timeStyle = NSDateFormatterNoStyle;
            mmddccyy.dateFormat = @"MM/dd/yyyy";
            manager.myLastUpdate = [LastUpdate MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            manager.myLastUpdate.lastUpdateTime = [mmddccyy dateFromString:@"12/11/2005"];

            // Save Managed Object Context
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
        }
        else
        {
            manager.myLastUpdate = [array firstObject];
        }
    });
    
    return manager;
}

- (void)setImage: (UIImage *)image forNew: (New *)myNew {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        myNew.image = UIImageJPEGRepresentation(image, 1.0);
    }];
}

- (void)insertNewWithTitle:(NSString *)title
               withPudDate:(NSDate *) pudDate
                  withLink:(NSString *)link
       withItemDescription:(NSString *)itemDescription
             withImageLink:(NSString *)imageLink {
    New *new = [New MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    new.title = title;
    new.pubDate = pudDate;
    new.itemDescription = itemDescription;
    new.imageLink = imageLink;
    new.link = link;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

-(void) refreshLastUpdate {
    self.myLastUpdate.lastUpdateTime = [NSDate date];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

@end
