//
//  MyRSSParser.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "MyRSSParser.h"
#import <AFNetworking/AFNetworking.h>
#import "DataBaseManager.h"
#import "RKXMLReaderSerialization.h"
#import <RestKit/RestKit.h>

@implementation MyRSSParser

static NSString *baseUrl = @"http://news.tut.by/rss";

#pragma mark - init methods

+(instancetype)sharedManager {
    static MyRSSParser *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyRSSParser alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        [self configureRestKit];
    }
    return self;
}

#pragma mark - configure RestKit

- (void)configureRestKit {
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:baseUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // define location object mapping
    RKObjectMapping *myMapping = [RKObjectMapping mappingForClass:[MyRSSItem class]];
    [myMapping addAttributeMappingsFromDictionary:@{@"title.text": @"title", @"pubDate.text": @"pubDateInString", @"description.text": @"itemDescription", @"link.text": @"link"}];
    [objectManager setAcceptHeaderWithMIMEType:@"application/rss+xml"];
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/rss+xml"];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:myMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"rss.channel.item" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
}

#pragma mark -

#pragma mark parser

- (void)parseRSSFeedAtPath:(NSString *) path
                   success:(SuccessBlock) success
                   failure:(FailureBlock) failure {
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDate *lastUpdate = [DataBaseManager sharedManager].myLastUpdate.lastUpdateTime;
        for (MyRSSItem *item in mappingResult.array) {
            if ([item.pubDate compare: lastUpdate] == NSOrderedDescending) {
                [[DataBaseManager sharedManager] insertNewWithTitle:item.title
                                                        withPudDate:item.pubDate
                                                           withLink:item.link
                                                withItemDescription:item.itemDescription withImageLink:item.imageUrl];
            }
        }
        [[DataBaseManager sharedManager] refreshLastUpdate];
        success(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
}

@end
