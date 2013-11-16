//
//  AppSharer.h
//  Fatakat Cooking
//
//  Created by Ahmad al-Moraly on 5/27/12.
//  Copyright (c) 2012 Artgin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSharer : NSObject

+(void)sendEmailWithText:(NSString *)text inViewController:(UIViewController *)viewController;

+(void)tweetURL:(NSString *)url andImage:(UIImage *)image inViewController:(UIViewController *)viewController withCompletionHandler:(void (^)(BOOL success))completionBlock;

+(void)postOnFacebookURL:(NSString*)url withName:(NSString *)name caption:(NSString *)caption description:(NSString *) description andImageURL:(NSString *)imageURL completionHandler:(void (^)(BOOL success, NSError *error))completionBlock;

+(BOOL)openURL:(NSURL *)url;

@end
