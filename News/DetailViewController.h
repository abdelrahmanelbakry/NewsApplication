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
#import "iCarousel.h"


@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,iCarouselDataSource, iCarouselDelegate>

@property (nonatomic) int topicID;
@property (nonatomic,retain) TopicModel* topicDataModel;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@property(nonatomic,retain) IBOutlet UILabel* topicTitle;
@property(nonatomic,retain) IBOutlet UITextView* topicContent;
@property(nonatomic,retain) IBOutlet UIImageView* topicImg;


@property(nonatomic,retain) IBOutlet UITableView* mytableView;


-(IBAction)LoadNewTopic:(id)sender;

@end
