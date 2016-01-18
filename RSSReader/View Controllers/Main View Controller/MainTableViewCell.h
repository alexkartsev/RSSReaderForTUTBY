//
//  MainTableViewCell.h
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleOfCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfCell;
@property (weak, nonatomic) IBOutlet UILabel *dateOfCell;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@end
