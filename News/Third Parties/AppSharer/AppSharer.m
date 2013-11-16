//
//  AppSharer.m
//  Fatakat Cooking
//
//  Created by Ahmad al-Moraly on 5/27/12.
//  Copyright (c) 2012 Artgin. All rights reserved.
//

#import "AppSharer.h"

#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "FBAPIWrapper.h"

typedef void (^FacebookCompletionHandler)(BOOL, NSError*);

@interface AppSharer () <MFMailComposeViewControllerDelegate, FBAPIWrapperDelegate>

@property (strong, nonatomic)FacebookCompletionHandler fbHandler;

@end

@implementation AppSharer
@synthesize fbHandler = _fbHandler;


+(BOOL)openURL:(NSURL *)url {
    return [[FBAPIWrapper sharedWrapper] facebookHandleOpenUrl:url];
}

+(void)sendEmailWithText:(NSString *)text inViewController:(UIViewController *)viewController {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        [mailComposer setMessageBody:text isHTML:NO];
        mailComposer.mailComposeDelegate = [self defaultSharer];
        [viewController presentViewController:mailComposer animated:YES completion:nil];
        [mailComposer release];
    }
    
}

+(void)tweetURL:(NSString *)url andImage:(UIImage *)image inViewController:(UIViewController *)viewController withCompletionHandler:(void (^)(BOOL))completionBlock {
    if([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetComposer = [[TWTweetComposeViewController alloc] init];
        [tweetComposer addImage:image];
        [tweetComposer addURL:[NSURL URLWithString:url]];
        tweetComposer.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [viewController dismissViewControllerAnimated:YES completion:nil];
            if (result == TWTweetComposeViewControllerResultDone) {
                if (completionBlock)
                    completionBlock(YES);
            } else if (result == TWTweetComposeViewControllerResultCancelled) {
                if (completionBlock)
                    completionBlock(NO);
            }
        };
        [viewController presentViewController:tweetComposer animated:YES completion:nil];
    }
}

+(void)postOnFacebookURL:(NSString *)url withName:(NSString *)name caption:(NSString *)caption description:(NSString *)description andImageURL:(NSString *)imageURL completionHandler:(void (^)(BOOL, NSError *))completionBlock
{
    [self defaultSharer].fbHandler = completionBlock;
    [FBAPIWrapper sharedWrapper].delegate = [self defaultSharer];
    
    [[FBAPIWrapper sharedWrapper] shareLink:url name:name caption:caption description:description image:imageURL];
    
}

+(AppSharer *)defaultSharer {
    static AppSharer *_defaultSharer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultSharer = [[self alloc] init];
    });
    return _defaultSharer;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    if (_fbHandler) {
        Block_release(_fbHandler);
        _fbHandler = nil;
    }
    [super dealloc];
}
@end
