//
//  HeadlineCell.m
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "HeadlineCell.h"

@implementation HeadlineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setCellDataWith:(TopicModel *)model
{
    //please always fill the cell by this function to maintain code in one place
    [self.topicID setText:model.ID];
    [self.topicTitle setText:model.Title];
    
    if([model.AllImgs count]<=0)
        [self.topicImage setHidden:YES];
    else
        [self.topicImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [model.AllImgs objectAtIndex:0] ]]];
    
}

@end
