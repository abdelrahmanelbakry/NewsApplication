//
//  RefreshRate.m
//  News
//
//  Created by Abdelrahman Mohamed on 1/5/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import "RefreshRate.h"

@implementation RefreshRate

NSDate* refreshDate=nil;

+(void) setLastRefreshDate:(NSDate*) lastRefresh
{
    refreshDate = lastRefresh;
}
+(NSDate*) getLastRefreshDate
{
    return refreshDate;
}
@end
