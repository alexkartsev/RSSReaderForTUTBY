//
//  MyRSSItem.h
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRSSItem : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *itemDescriptionWithImage;
@property (strong,nonatomic) NSString *itemDescription;
@property (strong,nonatomic) NSString *pubDateInString;
@property (strong,nonatomic) NSDate *pubDate;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *link;

-(NSArray *)imagesFromItemDescription;

@end
