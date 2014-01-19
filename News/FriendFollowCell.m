//
//  FriendFollowCell.m
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import "FriendFollowCell.h"

@implementation FriendFollowCell

@synthesize lblName,lblNumber;

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

@end
