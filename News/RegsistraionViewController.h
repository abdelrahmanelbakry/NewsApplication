//
//  RegsistraionViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "NetworkOperations.h"
#import "Reachability.h"
@interface RegsistraionViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate>
{
    Reachability *reach;
    NSMutableData* recievedData;
    
}

@property(nonatomic,retain) IBOutlet UITextField* txtFirstName;
@property(nonatomic,retain) IBOutlet UITextField* txtLastName;
@property(nonatomic,retain) IBOutlet UITextField* txtMail;
@property(nonatomic,retain) IBOutlet UITextField* txtPassword;
@property(nonatomic,retain) IBOutlet UITextField* txtMobile;

-(IBAction) regsister:(id) sender;
-(NSString *) md5:(NSString *) input;
-(IBAction)hidekeyboard:(id)sender;

@end
