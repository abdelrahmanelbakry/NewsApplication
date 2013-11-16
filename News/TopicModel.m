//
//  TopicModel.m
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel
@synthesize Title;
@synthesize ID;
@synthesize SectionName;
@synthesize topicLink;
@synthesize Date;
@synthesize Author;
@synthesize Content;
@synthesize AllImgs;
@synthesize NumberOfReadings;
@synthesize NumberOfViews;


#define kAdId            @"ID"
#define kAdTitle         @"title"
#define kAdSecName       @"SectionName"
#define kAdDate          @"Date"
#define kAdAuthor        @"Author"
#define kAdContent       @"Content"
#define kAdAllImgs       @"AllImgs"
#define kAdNViews        @"NumberOfViews"
#define kAdNRead         @"NumberOfReads"
#define kAdLink          @"topiclink"



//
- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:ID forKey:kAdId];
    [encoder encodeObject:Title forKey:kAdTitle];
    [encoder encodeObject:Content forKey:kAdContent];
    [encoder encodeObject:Author forKey:kAdAuthor];
    [encoder encodeObject:Date forKey:kAdDate];
    [encoder encodeObject:SectionName forKey:kAdSecName];
    [encoder encodeObject:AllImgs forKey:kAdAllImgs];
    
    [encoder encodeObject:topicLink forKey:kAdLink];
    
    [encoder encodeObject:NumberOfViews forKey:kAdNViews];
    [encoder encodeObject:NumberOfReadings forKey:kAdNRead];
    
    
    
    
}

-(id) init
{
    if (self = [super init])
    {
        
        ID = @"";
        Title=@"";
        Content=@"";
        Author=[NSString stringWithFormat:@""];
        Date=@"";
        SectionName=@"";
        NumberOfReadings=@"";
        NumberOfViews=@"";
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        ID = [decoder decodeObjectForKey:kAdId];
        Title = [decoder decodeObjectForKey:kAdTitle];
        Content = [decoder decodeObjectForKey:kAdContent];
        Author = [decoder decodeObjectForKey:kAdAuthor];
        Date = [decoder decodeObjectForKey:kAdDate];
        SectionName = [decoder decodeObjectForKey:kAdSecName];
        AllImgs = [decoder decodeObjectForKey:kAdAllImgs];
        
        topicLink = [decoder decodeObjectForKey:kAdLink];
        NumberOfReadings = [decoder decodeObjectForKey:kAdNRead];
        NumberOfViews = [decoder decodeObjectForKey:kAdNViews];
    }
    
    return self;
}


@end
