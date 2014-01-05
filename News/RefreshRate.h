//
//  RefreshRate.h
//  News
//
//  Created by Abdelrahman Mohamed on 1/5/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshRate : NSObject

+(void) setLastRefreshDate:(NSDate*) lastRefresh;
+(NSDate*) getLastRefreshDate;
@end
