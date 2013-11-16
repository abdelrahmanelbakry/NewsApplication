//
//  FacebookAPIWrapper.h
//  UsingFacebookWrapper
//
//  Created by Amr Saqr on 3/12/12.
//  Copyright (c) 2012 __Lascivio__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBAPIWrapperDelegate <NSObject>

@optional
- (void)shareDialogCompletedSuccessfully;
- (void)shareDialogDidFailWithError:(NSError *)error;
- (void)loginDialogDidFail:(BOOL)userCancelled;

@end

@interface FBAPIWrapper : NSObject

@property (nonatomic, assign) id<FBAPIWrapperDelegate> delegate;

+ (FBAPIWrapper *)sharedWrapper;

- (void)shareLink:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *) description image:(NSString *)image;

- (BOOL)facebookHandleOpenUrl:(NSURL *)url;

@end
