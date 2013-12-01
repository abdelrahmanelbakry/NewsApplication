//
//  HeadLineViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "HeadLineViewController.h"

#define HEADLINE1 @"خضيرة يصاب بقطع في الرباط الصليبي ويغيب ستة أشهر"
#define HEADLINE2 @"فالكاو سعيد في موناكو"

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
    tempHeadlines = [[NSMutableArray alloc]init];
    
    groupedHeadlines = [[NSMutableDictionary alloc]init];
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    [self loadHeadlines];

  //  [self.tableView addPullToRefreshWithActionHandler:^{
  //      [self loadHeadlines];
 //   }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreHeadlines];
    }];
   // [self.tableView triggerPullToRefresh];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data Functions

-(void) loadHeadlines
{
    [self LoadData];

}

-(void) loadMoreHeadlines
{
    
}

-(void)LoadData
{
    
    if (reach.isReachable)
    {
        [NetworkOperations operationWithParamerters:nil  requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
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
                    [self AddToTopics:tmpModel];
                }
                [self.tableView reloadData];
                
                
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
    return [self getNumberofProviders];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* providers = [providersSet allObjects];
    // Return the number of rows in the section.
    return [[groupedHeadlines objectForKey:[providers objectAtIndex:section]] count];//[tempHeadlines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"headLineCell";
    HeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    NSArray* providers = [providersSet allObjects];
    
    NSArray* headlines = [groupedHeadlines objectForKey:[providers objectAtIndex:indexPath.section]];
    
    for(int i=0;i<[headlines count];i++)
    {
        TopicModel* tmpModel = (TopicModel*) [headlines objectAtIndex:i];
        if(!tmpModel.isDisplayed)
        {
            [cell setCellDataWith:tmpModel ];
            
            [[groupedHeadlines objectForKey:[providers objectAtIndex:indexPath.section]] removeObject:tmpModel];
            tmpModel.isDisplayed = YES;
            [self AddToTopics:tmpModel];
            
            break;
        }
    }
    // Configure the cell...
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Provider # %i",section+1];
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
    if ([segue.identifier isEqualToString:@"ViewTopicSegueIdentifier"]) {
        TopicModel * topic=[tempHeadlines objectAtIndex:[self.tableView indexPathForCell:sender].row] ;

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailViewController* detailVC = segue.destinationViewController;
    detailVC.topicID = [topic.ID intValue];
    }
}



@end
