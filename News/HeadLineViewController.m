//
//  HeadLineViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "HeadLineViewController.h"

#define HEADLINE_URL @"http://young-journey-4873.herokuapp.com/"

@interface HeadLineViewController ()
{
    NSMutableArray * tempHeadlines;
    NSMutableDictionary* groupedHeadlines;
    int currentPageNumber;
}

@end

@implementation HeadLineViewController

@synthesize categroyID;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];

    
  //  [self.tableView addInfiniteScrollingWithActionHandler:^{
  //      [self loadMoreHeadlines];
   // }];
    
    [RefreshRate setLastRefreshDate:[NSDate date]];

    //Set a timer to update the clock
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(headlinesCheck:)
                                   userInfo:nil
                                    repeats:YES];
    
    UIBarButtonItem *addbutton         = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                             target:self
                                             action:@selector(addFriendDialog:)];
    
    UIBarButtonItem *settingsbutton          = [[UIBarButtonItem alloc] initWithTitle:@"الإعدادت" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsDialog:)];
                                           // initWithBarButtonSystemItem:UIbar
                                           // target:self action:@selector(settingsDialog:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addbutton, settingsbutton, nil];
    
   


}
-(IBAction)addFriendDialog:(id)sender
{
    FriendFollowViewController* friendController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsController"];
    [self.navigationController pushViewController:friendController animated:YES];
}
-(IBAction)settingsDialog:(id)sender
{
    ProvidersViewController* settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsController"];
    [self.navigationController pushViewController:settingsController animated:YES];
}
-(void) headlinesCheck:(id)sender
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    
    int intervalID = [userdefaults integerForKey:@"rate"];
    
    NSDate* checkDate;
    switch (intervalID)
    {
        case 0:
            checkDate = [[RefreshRate getLastRefreshDate] dateByAddingTimeInterval:900];
            break;
        case 1:
            checkDate = [[RefreshRate getLastRefreshDate] dateByAddingTimeInterval:1800];
            break;
        default:
            break;
    }
    NSDate* currDate = [NSDate date];

    if([[currDate laterDate:checkDate]isEqualToDate:currDate])
        [self loadHeadlines];

}
-(void) viewDidAppear:(BOOL)animated
{
    tempHeadlines = [[NSMutableArray alloc]init];
    
    groupedHeadlines = [[NSMutableDictionary alloc]init];

    [self LoadProviders];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data Functions


-(void)LoadProviders
{
    
    if (reach.isReachable)
    {
        [NetworkOperations operationWithFullURL:@"http://young-journey-4873.herokuapp.com/provider" parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"Providers"])
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
                
                [self loadHeadlines];

            }
            //else
            //   [SVProgressHUD dismiss];
        }  andFailureBlock:^(NSError *error) {
            // [SVProgressHUD dismiss];
        }] ;
    }
}

-(void) loadHeadlines
{
    [tempHeadlines removeAllObjects];
    [groupedHeadlines removeAllObjects];
    [self LoadHeadLinesShares];
   // [self LoadData];

}

-(void) loadMoreHeadlines
{
    
}
-(NSDictionary*) constructQuery
{
    NSMutableDictionary* Query = [[NSMutableDictionary alloc]init];
    
     [Query setObject:[[ProvidersManager getProvidersManager] getProrities] forKey:@"priority"];
     
     //[Query setObject:[NSNumber numberWithInt:currentAd] forKey:@"i"];
    
    
    return Query;

}



-(void)LoadHeadLinesShares
{
    //[NetworkOperations operationWithFullURL:@"http://young-journey-4873.herokuapp.com/category" parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response)
    
    if (reach.isReachable)
    {
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        //NSString* userId = [userdefaults objectForKey:@"user_id"];
        //NSString* URL = [NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/getStoriesSharedByUsersIFollow/%@",userId];
        [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/getStoriesSharedByUsersIFollow/%@",[userdefaults objectForKey:@"user_id"]] parameters: nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"headlines"])
                {
                    TopicModel* tmpModel=[[TopicModel alloc]init];
                    tmpModel.AllImgs = [[NSMutableArray alloc]init];
                    [tmpModel.AllImgs addObject:[dic objectForKey:@"img"]!=[NSNull null]?[dic objectForKey:@"img"]:@""];
                    tmpModel.Date=[dic objectForKey:@"date"]!=[NSNull null]?[dic objectForKey:@"date"]:@"";
                    tmpModel.ID=[dic objectForKey:@"id"]!=[NSNull null]?[dic objectForKey:@"id"]:@"";
                    tmpModel.ProviderID=[dic objectForKey:@"providerId"]!=[NSNull null]?[dic objectForKey:@"providerId"]:@"";
                    tmpModel.Title=[dic objectForKey:@"title"]!=[NSNull null]?[dic objectForKey:@"title"]:@"";
                    tmpModel.SectionName = [dic objectForKey:@"categoryId"]!=[NSNull null]?[dic objectForKey:@"categoryId"]:@"";
                    
                    ProviderModel* provider = [[ProvidersManager getProvidersManager] getProviderModel:[tmpModel.ProviderID intValue] ];
                    if(provider.IsSelected)
                        [self AddToTopicsShares:tmpModel];
                }
                [self.tableView reloadData];
                
                [RefreshRate setLastRefreshDate:[NSDate date]];
                [self LoadHeadLinesFollows];

            }
            //else
            //   [SVProgressHUD dismiss];
        }  andFailureBlock:^(NSError *error) {
            // [SVProgressHUD dismiss];
        }] ;
    }
}

-(void)LoadHeadLinesFollows
{
    //[NetworkOperations operationWithFullURL:@"http://young-journey-4873.herokuapp.com/category" parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response)
    
    if (reach.isReachable)
    {
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];

        [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/getStoriesReadByUsersFollowedByMe/%@",[userdefaults objectForKey:@"user_id"]] parameters: nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"headlines"])
                {
                    TopicModel* tmpModel=[[TopicModel alloc]init];
                    tmpModel.AllImgs = [[NSMutableArray alloc]init];
                    [tmpModel.AllImgs addObject:[dic objectForKey:@"img"]!=[NSNull null]?[dic objectForKey:@"img"]:@""];
                    tmpModel.Date=[dic objectForKey:@"date"]!=[NSNull null]?[dic objectForKey:@"date"]:@"";
                    tmpModel.ID=[dic objectForKey:@"id"]!=[NSNull null]?[dic objectForKey:@"id"]:@"";
                    tmpModel.ProviderID=[dic objectForKey:@"providerId"]!=[NSNull null]?[dic objectForKey:@"providerId"]:@"";
                    tmpModel.Title=[dic objectForKey:@"title"]!=[NSNull null]?[dic objectForKey:@"title"]:@"";
                    tmpModel.SectionName = [dic objectForKey:@"categoryId"]!=[NSNull null]?[dic objectForKey:@"categoryId"]:@"";
                    
                    ProviderModel* provider = [[ProvidersManager getProvidersManager] getProviderModel:[tmpModel.ProviderID intValue] ];
                    if(provider.IsSelected)
                        [self AddToTopicsFollows:tmpModel];
                }
                [self.tableView reloadData];
                
                [RefreshRate setLastRefreshDate:[NSDate date]];
                [self LoadData];
            }
            //else
            //   [SVProgressHUD dismiss];
        }  andFailureBlock:^(NSError *error) {
            // [SVProgressHUD dismiss];
        }] ;
    }
}

-(void)LoadData
{
    //[NetworkOperations operationWithFullURL:@"http://young-journey-4873.herokuapp.com/category" parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response)
    
    if (reach.isReachable)
    {
        [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/orderedCategory/%i?priority=%@",categroyID,[[ProvidersManager getProvidersManager] getProrities]] parameters: nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"headlines"])
                {
                    TopicModel* tmpModel=[[TopicModel alloc]init];
                    tmpModel.AllImgs = [[NSMutableArray alloc]init];
                    [tmpModel.AllImgs addObject:[dic objectForKey:@"img"]!=[NSNull null]?[dic objectForKey:@"img"]:@""];
                    tmpModel.Date=[dic objectForKey:@"date"]!=[NSNull null]?[dic objectForKey:@"date"]:@"";
                    tmpModel.ID=[dic objectForKey:@"id"]!=[NSNull null]?[dic objectForKey:@"id"]:@"";
                    tmpModel.ProviderID=[dic objectForKey:@"providerId"]!=[NSNull null]?[dic objectForKey:@"providerId"]:@"";
                    tmpModel.Title=[dic objectForKey:@"title"]!=[NSNull null]?[dic objectForKey:@"title"]:@"";
                    tmpModel.SectionName = [dic objectForKey:@"categoryId"]!=[NSNull null]?[dic objectForKey:@"categoryId"]:@"";
                    
                    ProviderModel* provider = [[ProvidersManager getProvidersManager] getProviderModel:[tmpModel.ProviderID intValue] ];
                    if(provider.IsSelected)
                        [self AddToTopics:tmpModel];
                }
                [self.tableView reloadData];
                
                [RefreshRate setLastRefreshDate:[NSDate date]];
            }
            //else
            //   [SVProgressHUD dismiss];
        }  andFailureBlock:^(NSError *error) {
            // [SVProgressHUD dismiss];
        }] ;
    }
}
- (void) AddToTopics:(TopicModel*) newAd
{
    TopicModel* ad = [[TopicModel alloc]init];
    ad.AllImgs = [[NSMutableArray alloc]initWithArray:[newAd.AllImgs copy] copyItems:YES];
    ad.Date = newAd.Date;//[values objectAtIndex:4];
    ad.ID = newAd.ID;//[values objectAtIndex:6];
    ad.NumberOfViews = newAd.NumberOfViews;//[values objectAtIndex:14];
    ad.NumberOfReadings = newAd.NumberOfReadings;//[values objectAtIndex:16];
    ad.Title = newAd.Title;//[values objectAtIndex:22];
    ad.Author = newAd.Author;//[values objectAtIndex:26];
    ad.ProviderID = newAd.ProviderID;
    ad.isDisplayed = newAd.isDisplayed;
    
    if([groupedHeadlines objectForKey:ad.ProviderID]!=nil)
    {
        [[groupedHeadlines objectForKey:ad.ProviderID] addObject:ad];
    }
    else
    {
        [groupedHeadlines setObject:[NSMutableArray arrayWithObject:ad] forKey:ad.ProviderID];
    }
    [tempHeadlines addObject:ad];
    
}
- (void) AddToTopicsFollows:(TopicModel*) newAd
{
    TopicModel* ad = [[TopicModel alloc]init];
    ad.AllImgs = [[NSMutableArray alloc]initWithArray:[newAd.AllImgs copy] copyItems:YES];
    ad.Date = newAd.Date;//[values objectAtIndex:4];
    ad.ID = newAd.ID;//[values objectAtIndex:6];
    ad.NumberOfViews = newAd.NumberOfViews;//[values objectAtIndex:14];
    ad.NumberOfReadings = newAd.NumberOfReadings;//[values objectAtIndex:16];
    ad.Title = newAd.Title;//[values objectAtIndex:22];
    ad.Author = newAd.Author;//[values objectAtIndex:26];
    ad.ProviderID = newAd.ProviderID;
    ad.isDisplayed = newAd.isDisplayed;
    
    if([groupedHeadlines objectForKey:@"Follows"]!=nil)
    {
        [[groupedHeadlines objectForKey:@"Follows"] addObject:ad];
    }
    else
    {
        [groupedHeadlines setObject:[NSMutableArray arrayWithObject:ad] forKey:@"Follows"];
    }
    [tempHeadlines addObject:ad];
    
}

- (void) AddToTopicsShares:(TopicModel*) newAd
{
    TopicModel* ad = [[TopicModel alloc]init];
    ad.AllImgs = [[NSMutableArray alloc]initWithArray:[newAd.AllImgs copy] copyItems:YES];
    ad.Date = newAd.Date;//[values objectAtIndex:4];
    ad.ID = newAd.ID;//[values objectAtIndex:6];
    ad.NumberOfViews = newAd.NumberOfViews;//[values objectAtIndex:14];
    ad.NumberOfReadings = newAd.NumberOfReadings;//[values objectAtIndex:16];
    ad.Title = newAd.Title;//[values objectAtIndex:22];
    ad.Author = newAd.Author;//[values objectAtIndex:26];
    ad.ProviderID = newAd.ProviderID;
    ad.isDisplayed = newAd.isDisplayed;
    
    if([groupedHeadlines objectForKey:@"Shares"]!=nil)
    {
        [[groupedHeadlines objectForKey:@"Shares"] addObject:ad];
    }
    else
    {
        [groupedHeadlines setObject:[NSMutableArray arrayWithObject:ad] forKey:@"Shares"];
    }
    [tempHeadlines addObject:ad];
    
}

#pragma mark - Table view data source
-(NSInteger) getNumberofProviders
{
    providersSet = [[NSMutableSet alloc]init];
    for(int i=0; i<[tempHeadlines count];i++)
    {
        TopicModel* tmpModel = (TopicModel*)[tempHeadlines objectAtIndex:i];
        if(![providersSet containsObject:tmpModel.ProviderID])
            [providersSet addObject: tmpModel.ProviderID];
    }
    
    return [providersSet count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self getNumberofProviders]+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0)
         return [[groupedHeadlines objectForKey:@"Shares"] count];
    if(section ==1)
         return [[groupedHeadlines objectForKey:@"Follows"] count];
    
    ProviderModel* provider = [[ProvidersManager getProvidersManager].providers objectAtIndex:section-2];

   // NSArray* providers = [providersSet allObjects];
    // Return the number of rows in the section.
    return [[groupedHeadlines objectForKey:[NSNumber numberWithInt:provider.ID]] count];//[tempHeadlines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"headLineCell";
    HeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
 //   NSArray* providers = [providersSet allObjects];
    NSArray* headlines; //= [groupedHeadlines]

    if(indexPath.section == 0)
        headlines = [groupedHeadlines objectForKey:@"Shares"];
    else if(indexPath.section ==1)
        headlines = [groupedHeadlines objectForKey:@"Follows"];
    else
    {
        ProviderModel* provider = [[ProvidersManager getProvidersManager].providers objectAtIndex:indexPath.section-2];
        headlines = [groupedHeadlines objectForKey:[NSNumber numberWithInt:provider.ID]];

    }
    TopicModel* tmpModel = (TopicModel*) [headlines objectAtIndex:indexPath.row];
    [cell setCellDataWith:tmpModel ];
    cell.tag = [tmpModel.ID intValue];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0) return @"مشاركات من الأصدقاء";
    if(section==1) return @"مقروء من الأصدقاء";
    
   // NSArray* providers = [providersSet allObjects];
    
    //int providerID = section-2;
    ProviderModel* provider = [[ProvidersManager getProvidersManager].providers objectAtIndex:section-2];
    
    return provider.Title;
    
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewTopicSegueIdentifier"])
    {
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        UITableViewCell* senderCell = (UITableViewCell*) sender;
        
        DetailViewController* detailVC = segue.destinationViewController;
        detailVC.topicID = senderCell.tag ;
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        
        //Mark this story as read
        [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/readTest/%@?story_id=%i",[userdefaults objectForKey:@"user_id"],senderCell.tag] parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                           
                
            }
            //else
            //   [SVProgressHUD dismiss];
        }  andFailureBlock:^(NSError *error) {
            // [SVProgressHUD dismiss];
        }] ;

    }
}

#pragma mark -Sharing Code
-(IBAction)shareTopic:(id)sender
{
    UIButton* btnSender = (UIButton*) sender;
    selectedTopic= btnSender.tag;
    
       //share
    [self showActionSheet];
    
}
//===============================================================
//Sharing Code
//===============================================================
- (void)showActionSheet
{
    NSString *actionSheetTitle = @"اختر كيفية المشاركة"; //Action Sheet Title
    NSString *other1 = @"مشاركة عبر الفيس بوك";
    NSString *other2 = @"مشاركة عبر تويتر";
    NSString *cancelTitle = @"إلغاء";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self markAsShared];
           // [self shareAtFB];
            break;
        case 1:
           // [self shareAtTwitter];
            [self markAsShared];
            break;
    }
    
}

-(void) markAsShared
{
    ///shared/{user_id}?story_id={story_id}
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];

    //Mark this story as shared
    [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/shared/%@?story_id=%i",[userdefaults objectForKey:@"user_id"],selectedTopic] parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
        if (response.count >0)
        {
            
            
        }
        //else
        //   [SVProgressHUD dismiss];
    }  andFailureBlock:^(NSError *error) {
        // [SVProgressHUD dismiss];
    }] ;

}

-(void) shareAtFB
{
    for(int i=0;i<[tempHeadlines count];i++)
    {
        TopicModel* tmpModel = (TopicModel*) [tempHeadlines objectAtIndex:i];
        
        if([tmpModel.ID isEqualToString:[NSString stringWithFormat:@"%i",selectedTopic]])
        {
            sharedTopic = tmpModel;
            break;
        }
    }

    ///////////////////Facebook Share Code
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=6) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            [mySLComposerSheet setInitialText: sharedTopic.Title];
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output=@"";
                switch (result) {
                    case SLComposeViewControllerResultDone:
                        output = @"تم النشر";
                        break;
                    default:
                        break;
                } //check if everythink worked properly. Give out a message on the state.
                if (output.length>0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
                
            }];
            
            //the message you want to post
            //[mySLComposerSheet addImage:nil];
            //an image you could post
            //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }else{
            
            [AppSharer postOnFacebookURL:sharedTopic.Title withName:@"" caption:@"" description:@"" andImageURL:nil completionHandler:nil];
        }
    }else{
        [AppSharer postOnFacebookURL:sharedTopic.Title withName:@"" caption:@"" description:@"" andImageURL:nil completionHandler:^(BOOL success, NSError *error) {}];
    }
}
-(void) shareAtTwitter
{
    
    for(int i=0;i<[tempHeadlines count];i++)
    {
        TopicModel* tmpModel = (TopicModel*) [tempHeadlines objectAtIndex:i];
        
        if([tmpModel.ID isEqualToString:[NSString stringWithFormat:@"%i",selectedTopic]])
        {
            sharedTopic = tmpModel;
            break;
        }
    }
    
    NSError *jsonError = nil;
    
    //NSString *jsonRequest=[NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",receiptBase64];
    
    //NSLog(@"Sending this JSON: %@",jsonRequest);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:sharedTopic.Title,@"longUrl",nil] options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    NSLog(@"JSON: %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] );
    
    // URL for sandbox receipt validation; replace "sandbox" with "buy" in production or you will receive
    
    // error codes 21006 or 21007
    
    NSURL *requestURL = [NSURL URLWithString:@"https://www.googleapis.com/urlshortener/v1/url"];
    
    
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    [req setHTTPMethod:@"POST"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    [req setHTTPBody:jsonData];
    
    
    
    NSURLConnection *tweetconn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    
    
    if(tweetconn) {
        
        receivedData = [[NSMutableData alloc]init];
        
    }
    
}

-(BOOL)isTwitterAvailable
{
    return NSClassFromString(@"TWTweetComposeViewController") != nil;
}

-(BOOL)isSocialAvailable
{
    return NSClassFromString(@"SLComposeViewController") != nil;
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot transmit receipt data. %@",[error localizedDescription]);
    
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}



-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    
    NSLog(@"JSON: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"iTunes response: %@",response);
    
    NSLog(@"%@",[[[[[response componentsSeparatedByString:@"id\":"] objectAtIndex:1]componentsSeparatedByString:@"\","]objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\"" withString:@""]) ;
    
    NSString*x=[[[[[response componentsSeparatedByString:@"id\":"] objectAtIndex:1]componentsSeparatedByString:@"\","]objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"%@",[[response componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",:"]] objectAtIndex:3]);
    
    [self contTweet:x];
    
}



-(void)contTweet:(NSString*)shortURL{
    for(int i=0;i<[tempHeadlines count];i++)
    {
        TopicModel* tmpModel = (TopicModel*) [tempHeadlines objectAtIndex:i];
        
        if([tmpModel.ID isEqualToString:[NSString stringWithFormat:@"%i",selectedTopic]])
        {
            sharedTopic = tmpModel;
            break;
        }
    }
    
    NSLog(@"short url : %@",shortURL);
    
    if ([self isSocialAvailable]) {
        
        NSLog(@"ert");
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            
        {
            
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            NSString* tweetStr=[NSString stringWithFormat:@"%@ \n %@ \n   %@  ", sharedTopic.Title.length>0? sharedTopic.Title:sharedTopic.Content,shortURL,@"#mostaml"];//selectedForumName
            
         //   NSLog(@"ios 6 twitter string : %@ ",tweetStr);
            
          //  [tweetSheet setInitialText:tweetStr];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
        }
        
        else
            
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"عفوا" message:@"لا يمكن ارسال التغريدة حاليا,من فضلك تأكد من الاتصال بالانترنت و وجود حساب تويتر معرف على الاقل " delegate:self cancelButtonTitle:@"تم" otherButtonTitles:nil];
            
            [alertView show];
            
        }
        
        
        
    } else{
        
        TwitterShare *twitterShare = [[TwitterShare alloc] owner:self];
        
        NSString* imgStr=@"";
        
        //  if (adDataModel.AllImgs.count>0) {
        
        //       imgStr=[adDataModel.AllImgs objectAtIndex:0];
        
        //   }
        
    //    NSString* tweetStr=[NSString stringWithFormat:@"%@ \n %@ \n   %@  ", selectedAd.Title.length>0? selectedAd.Title:selectedAd.Content,shortURL,@"#mostaml"];//selectedForumName
        
       // NSLog(@"ios 5 twitter string : %@ ",tweetStr);
        
       // [twitterShare TweetWithImageString:imgStr.length>0?imgStr:nil Link:shortURL Text:tweetStr];
        
    }
    
}


@end
