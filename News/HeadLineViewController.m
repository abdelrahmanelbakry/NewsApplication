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


@interface HeadLineViewController ()
{
    NSMutableArray * tempHeadlines;
    int currentPageNumber;
}

@end

@implementation HeadLineViewController

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
//Constructing the Query String
-(NSDictionary*) constructQuery
{
    
    NSMutableDictionary* Query = [[NSMutableDictionary alloc]init];
    /*[Query setObject:[NSString stringWithFormat:@"%i",currentPageNumber] forKey:@"p"];
    
    [Query setObject:@"ads" forKey:@"operation"];
    
    if([sectionID integerValue]!=-1 && [subSectionID integerValue]!=-1)
        [Query setObject:[NSString stringWithFormat:@"%@",subSectionID] forKey:@"t"];
    else if([sectionID integerValue]!=-1)
        [Query setObject:sectionID forKey:@"t"];
    
    if([modelID integerValue]!=-1 && [subModelID integerValue]!=-1)
        [Query setObject:subModelID forKey:@"m"];
    else if([modelID integerValue]!=-1)
        [Query setObject:modelID forKey:@"m"];
    
    
    
    if([locationID integerValue]!=-1)
        [Query setObject:locationID forKey:@"l"];
    if([periodID integerValue]!=-1)
        [Query setObject:periodID forKey:@"d"];
    if([order integerValue]!=-1)
        [Query setObject:order forKey:@"o"];*/
    
    
    return Query;
}


-(void) loadHeadlines
{
    TopicModel* tmpModel1 = [[TopicModel alloc]init];
    tmpModel1. Title = HEADLINE1;
    tmpModel1.AllImgs =[[NSMutableArray alloc]init];
    [tmpModel1.AllImgs addObject:@"img1.jpg"];
    tmpModel1.ID = @"1";
    [self AddToTopics: tmpModel1];
    
    TopicModel* tmpModel2 = [[TopicModel alloc]init];
    tmpModel2. Title = HEADLINE2;
    tmpModel2.AllImgs =[[NSMutableArray alloc]init];
    [tmpModel2.AllImgs addObject:@"img2.jpg"];
    tmpModel2.ID = @"2";
    [self AddToTopics: tmpModel2];

   // [tempHeadlines addObject:tmpModel1];
    //[tempHeadlines addObject:tmpModel2];
    
    [self.tableView reloadData];
}

-(void) loadMoreHeadlines
{
    
}

-(void)LoadAds
{
    
    if (reach.isReachable)
    {
        [NetworkOperations operationWithParamerters:[self constructQuery]  requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"news"])
                {
                    TopicModel* tmpModel=[[TopicModel alloc]init];
                    tmpModel.AllImgs = [[NSMutableArray alloc]init];
                    [tmpModel.AllImgs addObject:[dic objectForKey:@"img"]!=[NSNull null]?[dic objectForKey:@"img"]:@""];
                    tmpModel.Date=[dic objectForKey:@"date"]!=[NSNull null]?[dic objectForKey:@"date"]:@"";
                    tmpModel.ID=[dic objectForKey:@"id"]!=[NSNull null]?[dic objectForKey:@"id"]:@"";
                    tmpModel.Title=[dic objectForKey:@"headline"]!=[NSNull null]?[dic objectForKey:@"headline"]:@"";
                    
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
    
    [tempHeadlines addObject:ad];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"headLineCell";
    HeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    [cell setCellDataWith:[tempHeadlines objectAtIndex:indexPath.row]];

    // Configure the cell...
    
    return cell;
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
