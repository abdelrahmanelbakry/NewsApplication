//
//  FriendFollowViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperations.h"
#import "Reachability.h"
#import "UserDataModel.h"
#import "FriendFollowCell.h"
#import <AddressBookUI/AddressBookUI.h>

@interface FriendFollowViewController : UITableViewController
{
    Reachability *reach;
    NSMutableData* receivedData;
}

@end
