//
//  MyRSSItem.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "MyRSSItem.h"

@implementation MyRSSItem

-(NSArray *)imagesFromItemDescription {
    if (self.itemDescription) {
        return [self imagesFromHTMLString:self.itemDescription];
    }
    
    return nil;
}

#pragma mark - retrieve images from html string using regexp

-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr {
    NSMutableArray *imagesURLStringArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(https?)\\S*(png|jpg|jpeg|gif)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    [regex enumerateMatchesInString:htmlstr
                            options:0
                              range:NSMakeRange(0, htmlstr.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             [imagesURLStringArray addObject:[htmlstr substringWithRange:result.range]];
                         }];
    
    return [NSArray arrayWithArray:imagesURLStringArray];
}

- (NSDate *)pubDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, dd-MMMM-yyyy HH:mm:ss z"];
    NSDate *date = [formatter dateFromString:self.pubDateInString];
    return date;
}

- (void)setItemDescription:(NSString *)itemDescription {
    if (itemDescription.length) {
        self.imageUrl = [[self imagesFromHTMLString:itemDescription] firstObject];
        int startRange = (int)[itemDescription rangeOfString:@"/>"].location;
        if (startRange<itemDescription.length) {
            itemDescription = [itemDescription substringFromIndex:startRange+2];
        }
        int endRange = (int)[itemDescription rangeOfString:@"<br"].location;
        if (endRange<itemDescription.length) {
            itemDescription = [itemDescription substringToIndex:endRange];
        }
        _itemDescription = itemDescription;
    }
}


@end
