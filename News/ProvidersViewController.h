//
//  ProvidersViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 12/21/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperations.h"
#import "Reachability.h"
#import "ProviderModel.h"

@interface ProvidersViewController : UITableViewController
{
    Reachability *reach;
    NSMutableData* receivedData;
}
@end
