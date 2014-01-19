//
//  UserDataModel.m
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import "UserDataModel.h"

@implementation UserDataModel
@synthesize ID;
@synthesize FirstName;
@synthesize LastName;
@synthesize MobileNo;


#define kUserId          @"ID"
#define kFistName        @"firstName"
#define kLastName        @"lastName"
#define kMobileNo        @"mobileNo"


//
- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:ID forKey:kUserId];
    [encoder encodeObject:LastName forKey:kLastName];
    [encoder encodeObject:FirstName forKey:kFistName];
    [encoder encodeObject:MobileNo forKey:kMobileNo];
  
    
    
}

-(id) init
{
    if (self = [super init])
    {
        
        ID = @"";
        FirstName=@"";
        LastName=@"";
        MobileNo=@"";
           }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        ID = [decoder decodeObjectForKey:kUserId];
        FirstName = [decoder decodeObjectForKey:kFistName];
        LastName = [decoder decodeObjectForKey:kLastName];
        MobileNo = [decoder decodeObjectForKey:kMobileNo];
    }
    
    return self;
}


@end
