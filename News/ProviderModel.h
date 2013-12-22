//
//  ProviderModel.h
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProviderModel : NSObject<NSCoding>


@property(nonatomic)  int ID;
@property(nonatomic, retain)  NSString *Title;
@property(nonatomic, retain)  NSString *Image;
@property(nonatomic, retain)  NSString *URL;
@property(nonatomic) BOOL IsSelected;

@end
