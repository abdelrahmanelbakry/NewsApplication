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
-(ProviderModel*) getProviderModel:(int) providerID
{
    for(int i=0;i< [[[ProvidersManager getProvidersManager] providers] count];i++)
    {
        ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:i];
        if(providerID == provider.ID)
        {
            return provider;
            break;
        }
    }
    return nil;
}

-(NSString*) getProrities
{
    NSMutableString* prorities = [[NSMutableString alloc] init];
    for(int i=0;i< [[[ProvidersManager getProvidersManager] providers] count];i++)
    {
        ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:i];
        
        [prorities appendString:[NSString stringWithFormat:@"%i",provider.ID]];
        if(i+1 < [[[ProvidersManager getProvidersManager] providers] count])
            [prorities appendString:@","];

    }
    return prorities;
}

-(void) insertProvider:(ProviderModel*) newData atIndex:(NSInteger) index
{
    if(![[ProvidersManager getProvidersManager] providerExists:newData.ID])
    {
        ProviderModel* data = [[ProviderModel alloc]init];
        data.ID = newData.ID;
        data.Image = newData.Image;
        data.Title = newData.Title;
        data.URL = newData.URL;
        data.IsSelected = newData.IsSelected;
        [providers insertObject:data atIndex:index];
        
    }

}
-(void) addProvider:(ProviderModel*) newData
{
    if(![[ProvidersManager getProvidersManager] providerExists:newData.ID])
    {
        ProviderModel* data = [[ProviderModel alloc]init];
        data.ID = newData.ID;
        data.Image = newData.Image;
        data.Title = newData.Title;
        data.URL = newData.URL;
        data.IsSelected = newData.IsSelected;
        [providers addObject:data];

    }
}

-(void) removeProviderByID :(int) providerID
{
    for(int i=0;i< [[[ProvidersManager getProvidersManager] providers] count];i++)
    {
        ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:i];
        if(providerID == provider.ID)
        {
            [[[ProvidersManager getProvidersManager] providers] removeObjectAtIndex:i];
            break;
        }
    }

}

-(void) setIsSelected: (int) providerID withValue:(BOOL) selectionValue
{
    
    for(int i=0;i< [[[ProvidersManager getProvidersManager] providers] count];i++)
    {
        ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:i];
         if(providerID == provider.ID)
             provider.IsSelected = selectionValue;
        
    }
}
-(BOOL) providerExists:(int) providerID
{
    for(int i=0;i< [[[ProvidersManager getProvidersManager] providers] count];i++)
    {
        ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:i];
        if(providerID == provider.ID)
            return YES;
    }
    return NO;
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
