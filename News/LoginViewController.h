//
//  LoginViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 1/4/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//
/*
 {"utf8":"✓", "session":{"email":"human6@earth.com", "password":"123456"}, "commit":"Login"} Server will reply with JSON
 {"Login Status":"Success"}
 or
 {"Login Status":"Failure"}
 */
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "NetworkOperations.h"
#import "Reachability.h"
#import "CategoriesViewController.h"

@interface LoginViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    Reachability *reach;
    NSMutableData* recievedData;
    
}

@property(nonatomic,retain) IBOutlet UITextField* txtUser;
@property(nonatomic,retain) IBOutlet UITextField* txtPassword;

-(IBAction)login:(id)sender;
-(IBAction)hidekeyboard:(id)sender;
- (NSString *) md5:(NSString *) input;
@end
