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
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>
#import "AppSharer.h"
#import "TwitterShare.h"
#import "ProvidersManager.h"


@interface HeadLineViewController : UITableViewController<UIActionSheetDelegate>
{
    Reachability *reach;
    NSMutableData* receivedData;
    NSMutableSet* providersSet;
    SLComposeViewController *mySLComposerSheet;
    int selectedTopic;
    TopicModel* sharedTopic;

}
@property(nonatomic) int categroyID;

-(void) loadHeadlines;
-(void) loadMoreHeadlines;
-(IBAction)shareTopic:(id)sender;
@end
