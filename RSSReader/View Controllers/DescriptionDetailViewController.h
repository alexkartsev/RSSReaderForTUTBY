//
//  DescriptionDetailViewViewController.h
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "New.h"

@interface DescriptionDetailViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) New *item;

@end
