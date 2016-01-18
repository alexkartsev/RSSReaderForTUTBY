//
//  MyRSSParser.h
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MyRSSItem.h"
#import <UIKit/UIKit.h>

typedef void (^SuccessBlock)(NSArray *feedItems);
typedef void (^FailureBlock)(NSError *error);

@interface MyRSSParser : NSObject
@property (copy, nonatomic) SuccessBlock block;
@property (copy, nonatomic) FailureBlock failblock;

+(instancetype)sharedManager;
- (void)parseRSSFeedAtPath:(NSString *) path
                   success:(SuccessBlock) success
                   failure:(FailureBlock) failure;

@end
