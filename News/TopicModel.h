//
//  TopicModel.h
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject

@property(nonatomic, retain)  NSString *ID;
@property(nonatomic, retain)  NSString *ProviderID;
@property(nonatomic, retain)  NSString *Title;
@property(nonatomic, retain)  NSString *Content;
@property(nonatomic, retain)  NSString *Author;
@property(nonatomic, retain)  NSString *Date;
@property(nonatomic, retain)  NSString *SectionName;
@property(nonatomic, retain)  NSMutableArray  *AllImgs;
@property(nonatomic,retain)   NSString *topicLink;
@property(nonatomic,retain)   NSString* NumberOfViews;
@property(nonatomic,retain)   NSString* NumberOfReadings;
@property(nonatomic) BOOL isDisplayed;
@end
