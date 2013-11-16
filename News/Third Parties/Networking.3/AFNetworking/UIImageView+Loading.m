//
//  UIImageView+Loading.m
//  Template
//
//  Created by Ahmad al-Moraly on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+Loading.h"

@implementation UIImageView (Loading)

-(void)startActivityIndicator {
    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    spinner.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    [self addSubview:spinner];
}

-(void)removeActivityIndicator {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
