//
//  TwitterShare.m
//  TwitterApi
//
//  Created by Islam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterShare.h"
#import <Twitter/Twitter.h>

@implementation TwitterShare

@synthesize viewController_;


- (id) owner :(UIViewController *)view_ {
    if (self = [super init]) {
        viewController_ = view_;
    }
    return self;
}

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)TweetWithImageString:(NSString *)image_ Link:(NSString *)link_ Text:(NSString *)initText_ {
    
    TWTweetComposeViewController *tweetContent_ = [[TWTweetComposeViewController alloc] init];
    
    [tweetContent_ addImage:[UIImage imageNamed:image_]];
    [tweetContent_ setInitialText:initText_];
    [tweetContent_ addURL:[NSURL URLWithString:link_]];
    
    [viewController_ presentModalViewController:tweetContent_ animated:YES];
    
    tweetContent_.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        
        if (result == TWTweetComposeViewControllerResultCancelled) {
            //IF_NSLOG_ENABLED(@"Tweet has been canceld");
        }
        else {
            //IF_NSLOG_ENABLED(@"Tweet has been tweeted");
        }
        
        [viewController_ dismissModalViewControllerAnimated:YES];
    };
    
}

- (void)TweetWithImage:(UIImage *)image_ Link:(NSString *)link_ Text:(NSString *)initText_ {
    
    TWTweetComposeViewController *tweetContent_ = [[TWTweetComposeViewController alloc] init];
    
    [tweetContent_ addImage:image_];
    [tweetContent_ setInitialText:initText_];
    [tweetContent_ addURL:[NSURL URLWithString:link_]];
    
    [viewController_ presentModalViewController:tweetContent_ animated:YES];
    
    tweetContent_.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        
        if (result == TWTweetComposeViewControllerResultCancelled) {
            //IF_NSLOG_ENABLED(@"Tweet has been canceld");
        }
        else {
            //IF_NSLOG_ENABLED(@"Tweet has been tweeted");
        }
        
        [viewController_ dismissModalViewControllerAnimated:YES];
    };
    
}

@end
