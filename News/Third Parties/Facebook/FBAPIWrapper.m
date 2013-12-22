//
//  FacebookAPIWrapper.m
//  UsingFacebookWrapper
//
//  Created by Amr Saqr on 3/12/12.
//  Copyright (c) 2012 __Lascivio__. All rights reserved.
//

#import "FBAPIWrapper.h"
#import "FBConnect.h"

#define kAccessTokenKey @"FBAccessTokenKey"
#define kExpirationDateKey @"FBExpirationDateKey"

#define DEBUGGING 1

typedef void (^ActionFn)();

// Paste your application id instead of this
static NSString * const appId = @"715740885105282";

@interface FBAPIWrapper () <FBSessionDelegate, FBDialogDelegate>{
    Facebook *facebook;
    ActionFn feedCompletion;
}

- (void) openFeedDialog:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *)description image:(NSString *)image;
- (void)loginWithFeedCompletion:(ActionFn)actionFn;
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expirationDate;

- (void)extendFacebookAccessTokenIfNeeded;

- (void)initializeFacebook;

@end

@implementation FBAPIWrapper

@synthesize delegate = _delegate;

#pragma mark - Helper Methods
- (void) openFeedDialog:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *)description image:(NSString *)image {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name, @"name",
                                   link, @"link",
                                   caption, @"caption",
                                   description, @"description",
                                   image, @"picture",
                                   nil];
    
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
}

- (void)loginWithFeedCompletion:(ActionFn)actionFn {
    [facebook authorize:[NSArray arrayWithObjects:@"publish_stream", nil]];
    feedCompletion = Block_copy(actionFn);
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expirationDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:kAccessTokenKey];
    [defaults setObject:expirationDate forKey:kExpirationDateKey];
    [defaults synchronize];
}

#pragma mark - Public Interface
- (void)shareLink:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *)description image:(NSString *)image {
    if (![facebook isSessionValid]) {
        [self loginWithFeedCompletion:^{
            [self openFeedDialog:link name:name caption:caption description:description image:image];
        }];
        return;
    }
    
    [self openFeedDialog:link name:name caption:caption description:description image:image];
}

#pragma mark - FBSessionDelegate Methods
- (void)fbDidLogin {
    [self storeAuthData:facebook.accessToken expiresAt:facebook.expirationDate];
    if (DEBUGGING)
        NSLog(@"User successfuly logged in");
    
    if (feedCompletion) {
        feedCompletion();
        Block_release(feedCompletion);
        feedCompletion = nil;
    }
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kAccessTokenKey];
    [defaults removeObjectForKey:kExpirationDateKey];
    [defaults synchronize];
    if (DEBUGGING)
        NSLog(@"User logged out");
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        if (DEBUGGING)
            NSLog(@"The user cancelled the login dialog");
    }
    else {
        if (DEBUGGING)
            NSLog(@"An error occured");
    }
    
    if ([_delegate respondsToSelector:@selector(loginDialogDidFail:)])
        [_delegate loginDialogDidFail:cancelled];
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    [self storeAuthData:accessToken expiresAt:expiresAt];
    if (DEBUGGING)
        NSLog(@"Facebook extended your access token");
}

- (void)fbSessionInvalidated {
    [self fbDidLogout];
    if (DEBUGGING)
        NSLog(@"Facebook session expired");
}

#pragma mark - FBDialogDelegate Methods
- (void)dialogDidNotComplete:(FBDialog *)dialog {
    if (DEBUGGING)
        NSLog(@"Dialog dismissed");
}

- (void) dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        if (DEBUGGING)
            NSLog(@"User canceled dialog or there was an error");
        return;
    }
    if (DEBUGGING)
        NSLog(@"Dialog posted to your profile successfully");
    
    if ([_delegate respondsToSelector:@selector(shareDialogCompletedSuccessfully)])
        [_delegate shareDialogCompletedSuccessfully];
}

- (void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error {
    if (DEBUGGING)
        NSLog(@"Error message: %@", [error localizedDescription]);
    
    if ([_delegate respondsToSelector:@selector(shareDialogDidFailWithError:)])
        [_delegate shareDialogDidFailWithError:error];
}

#pragma mark - UIApplicationDelegate Notifications
- (BOOL)facebookHandleOpenUrl:(NSURL *)url {
    return [facebook handleOpenURL:url];
    if (DEBUGGING)
        NSLog(@"Facebook handled opening a url");
}

- (void)extendFacebookAccessTokenIfNeeded {
    [facebook extendAccessTokenIfNeeded];
}

#pragma mark - Initialization and Memory Management
+ (FBAPIWrapper *)sharedWrapper {
    static FBAPIWrapper *sharedFBAPIWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFBAPIWrapper = [[FBAPIWrapper alloc] init];
        
        [sharedFBAPIWrapper initializeFacebook];
    });
//    if (sharedFBAPIWrapper == nil) {
//        sharedFBAPIWrapper = [[FBAPIWrapper alloc] init];
//        
//        [sharedFBAPIWrapper initializeFacebook];
//    }
    
    return sharedFBAPIWrapper;
}

- (void)initializeFacebook {
    facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kAccessTokenKey] && [defaults objectForKey:kExpirationDateKey]) {
        facebook.accessToken = [defaults objectForKey:kAccessTokenKey];
        facebook.expirationDate = [defaults objectForKey:kExpirationDateKey];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extendFacebookAccessTokenIfNeeded) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [facebook release];
    [super dealloc];
}

- (id)retain {
    return self;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

@end
