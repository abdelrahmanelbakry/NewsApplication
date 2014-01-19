//
//  FriendFollowCell.h
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperations.h"

@interface FriendFollowCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel* lblName;
@property(nonatomic,retain) IBOutlet UILabel* lblNumber;

-(IBAction)followUser:(id)sender;

@end
