//
//  ProvidersManager.h
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderModel.h"

@interface ProvidersManager : NSObject
{
    NSMutableArray* providers;
}

@property(nonatomic,retain) NSMutableArray* providers;

+(ProvidersManager*) getProvidersManager;
-(void) addProvider:(ProviderModel*) provider;


-(void) serializeProviders;
-(BOOL) deserializeProviders;
-(BOOL) providerExists:(int) providerID;
-(void) removeProviderByID :(int) providerID;
-(void) setIsSelected: (int) providerID withValue:(BOOL) selectionValue;
-(ProviderModel*) getProviderModel:(int) providerID;
-(void) insertProvider:(ProviderModel*) newData atIndex:(NSInteger) index;

@end
