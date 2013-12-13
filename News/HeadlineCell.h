//
//  HeadlineCell.h
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"
#import "NetworkOperations.h"

@interface HeadlineCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *topicID;
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UIImageView *topicImage;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;

-(void)setCellDataWith:(TopicModel *)model;
@end
