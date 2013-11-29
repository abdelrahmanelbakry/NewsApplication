//
//  CategoriesViewController.h
//  News
//
//  Created by Abdelrahman Mohamed on 11/26/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperations.h"
#import "Reachability.h"
#import "TopicModel.h"
#import "HeadLineViewController.h"

@interface CategoriesViewController : UITableViewController
{
    Reachability *reach;
    NSMutableData* receivedData;
}


@end
