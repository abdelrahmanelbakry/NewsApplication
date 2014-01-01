//
//  RegsistraionViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperations.h"
#import "Reachability.h"
@interface RegsistraionViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    Reachability *reach;
    NSMutableData* recievedData;
    
}

-(IBAction) regsister:(id) sender;
@end
