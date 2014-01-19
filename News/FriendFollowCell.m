//
//  FriendFollowCell.m
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import "FriendFollowCell.h"

@implementation FriendFollowCell

@synthesize lblName,lblNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)followUser:(id)sender
{
    [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/followSession/%i",self.tag] parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
        if (response.count >0)
        {
            //1- get the favorite topics
            //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
            //2- set up the topics array
        /*    for (NSDictionary* dic in [response objectForKey:@"Providers"])
            {
                ProviderModel* tmpModel=[[ProviderModel alloc]init];
                
                tmpModel.ID=[[dic objectForKey:@"provider_id"]intValue] ;//!=[NSNull null]?[dic objectForKey:@"provider_id"]:-1;
                tmpModel.Title=[dic objectForKey:@"name"]!=[NSNull null]?[dic objectForKey:@"name"]:@"";
                tmpModel.URL =[dic objectForKey:@"url"]!=[NSNull null]?[dic objectForKey:@"url"]:@"";
                tmpModel.Image =[dic objectForKey:@"img"]!=[NSNull null]?[dic objectForKey:@"img"]:@"";
                tmpModel.IsSelected = YES;
                //[self AddToProviders:tmpModel];
                
                [[ProvidersManager getProvidersManager] addProvider:tmpModel];
            }
            
            [self loadHeadlines];*/
            
        }
        //else
        //   [SVProgressHUD dismiss];
    }  andFailureBlock:^(NSError *error) {
        // [SVProgressHUD dismiss];
    }] ;

}
@end
