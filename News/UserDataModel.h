//
//  UserDataModel.h
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataModel : NSObject<NSCoding>

@property(nonatomic, retain)  NSString *ID;
@property(nonatomic, retain)  NSString *FirstName;
@property(nonatomic, retain)  NSString *LastName;
@property(nonatomic, retain)  NSString *MobileNo;

@end
