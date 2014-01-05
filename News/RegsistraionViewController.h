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
@interface RegsistraionViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    Reachability *reach;
    NSMutableData* recievedData;
    
}

-(IBAction) regsister:(id) sender;
-(NSString *) md5:(NSString *) input;
@end
