//
//  HeadLineViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "HeadlineCell.h"
#import "AppSharer.h"
#import "TwitterShare.h"
#import "TopicModel.h"
#import "NetworkOperations.h"
#import "Reachability.h"
#import "SVPullToRefresh.h"

@interface HeadLineViewController : UITableViewController
{
    Reachability *reach;
    NSMutableData* receivedData;
    NSMutableSet* providersSet;
}
@property(nonatomic) int categroyID;

-(void) loadHeadlines;
-(void) loadMoreHeadlines;
@end
