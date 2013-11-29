//
//  NewsTests.m
//  NewsTests
//
//  Created by Abdelrahman Mohamed on 11/2/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "NewsTests.h"

@implementation NewsTests
@synthesize controller;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    [self.controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)UICategoryTest
{
    //STFail(@"Unit tests are not implemented yet in NewsTests");
   
}

@end
