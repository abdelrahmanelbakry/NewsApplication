//
//  DetailViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>
#import "NetworkOperations.h"
#import "Reachability.h"
#import "AppSharer.h"
#import "TwitterShare.h"
#import "TopicModel.h"
#import "HeadlineCell.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) int topicID;
@property (nonatomic,retain) TopicModel* topicDataModel;


@property(nonatomic,retain) IBOutlet UILabel* topicTitle;
@property(nonatomic,retain) IBOutlet UITextView* topicContent;
@property(nonatomic,retain) IBOutlet UIImageView* topicImg;


@property(nonatomic,retain) IBOutlet UITableView* mytableView;


-(IBAction)LoadNewTopic:(id)sender;

@end
