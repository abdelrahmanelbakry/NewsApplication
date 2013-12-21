//
//  ProviderModel.m
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "ProviderModel.h"

@implementation ProviderModel
@synthesize Title;
@synthesize ID;
@synthesize Image;
@synthesize URL;
@synthesize IsSelected;


#define kProviderId            @"ID"
#define kProviderImage      @"Image"
#define kProviderTitle        @"title"
#define kProviderURL      @"URL"
#define kProviderSelected      @"isSelected"



//
- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:ID forKey:kProviderId];
    [encoder encodeObject:Image forKey:kProviderImage];
    [encoder encodeObject:Title forKey:kProviderTitle];
    [encoder encodeObject:URL forKey:kProviderURL];
   
    [encoder encodeBool:IsSelected forKey:kProviderSelected];
    
}

-(id) init
{
    if (self = [super init])
    {
        
        ID = @"";
        Title=@"";
        Image=@"";
        URL=@"";
 
        IsSelected = NO;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        ID = [decoder decodeObjectForKey:kProviderId];
        Title = [decoder decodeObjectForKey:kProviderTitle];
        URL = [decoder decodeObjectForKey:kProviderURL];
        Image = [decoder decodeObjectForKey:kProviderImage];
     
        IsSelected = [decoder decodeBoolForKey:kProviderSelected];
    }
    
    return self;
}

@end
