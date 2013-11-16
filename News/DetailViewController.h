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

@interface DetailViewController : UIViewController

@property (nonatomic) int topicID;
@property (nonatomic,retain) TopicModel* topicDataModel;


@property(nonatomic,retain) IBOutlet UILabel* topicTitle;
@property(nonatomic,retain) IBOutlet UILabel* topicContent;
@property(nonatomic,retain) IBOutlet UIImageView* topicImg;

@end
