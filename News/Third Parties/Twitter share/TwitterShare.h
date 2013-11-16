//
//  TwitterShare.h
//  TwitterApi
//
//  Created by Islam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Topic;

@interface TwitterShare : UIViewController {

}

@property (nonatomic, assign) UIViewController *viewController_;

- (id) owner :(UIViewController *)view_;
- (void)TweetWithImageString:(NSString *)image_ Link:(NSString *)link_ Text:(NSString *)initText_;
- (void)TweetWithImage:(UIImage *)image_ Link:(NSString *)link_ Text:(NSString *)initText_;

@end
