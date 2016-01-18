//
//  LastUpdate+CoreDataProperties.h
//  
//
//  Created by Александр Карцев on 1/17/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LastUpdate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LastUpdate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *lastUpdateTime;

@end

NS_ASSUME_NONNULL_END
