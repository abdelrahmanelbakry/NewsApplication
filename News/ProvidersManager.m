//
//  ProvidersManager.m
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "ProvidersManager.h"

@implementation ProvidersManager

@synthesize providers;

ProvidersManager* manager =  nil;

-(id) init
{
    if (self = [super init])
    {
        self.providers = [[NSMutableArray alloc]init];
    }
    return self;
}
+(ProvidersManager*) getProvidersManager
{
    if(manager == nil)
        manager = [[ProvidersManager alloc] init];
    
    return manager;
}


-(void) addProvider:(ProviderModel*) newData
{
    ProviderModel* data = [[ProviderModel alloc]init];
    data.ID = newData.ID;
    data.Image = newData.Image;
    data.Title = newData.Title;
    data.URL = newData.URL;
    
    [providers addObject:data];
}


-(void) serializeProviders
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentsPath stringByAppendingPathComponent:@"providers.plist"];
    // BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    [NSKeyedArchiver archiveRootObject:providers toFile:path];
    //[notifications writeToFile:path atomically:YES];
}
-(BOOL) deserializeProviders
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentsPath stringByAppendingPathComponent:@"providers.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if(fileExists)
    {
        providers=[NSKeyedUnarchiver unarchiveObjectWithFile:path] ;
        return YES;
    }
    return NO;
}
@end
