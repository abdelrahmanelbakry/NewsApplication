//
//  CategoriesViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 11/26/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "CategoriesViewController.h"

@interface CategoriesViewController ()
{
    NSMutableArray* newsCategories;
}
@end

@implementation CategoriesViewController

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
    newsCategories = [[NSMutableArray alloc]init];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    [self LoadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Loading data functions

-(void)LoadData
{
    
    if (reach.isReachable)
    {
        [NetworkOperations operationWithFullURL:@"http://young-journey-4873.herokuapp.com/category" parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"Categories"])
                {
                    TopicModel* tmpModel=[[TopicModel alloc]init];
                    
                    tmpModel.ID=[dic objectForKey:@"id"]!=[NSNull null]?[dic objectForKey:@"id"]:@"";
                    tmpModel.Title=[dic objectForKey:@"title"]!=[NSNull null]?[dic objectForKey:@"title"]:@"";
                    
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
    ad.ID = newAd.ID;//[values objectAtIndex:6];
    ad.Title = newAd.Title;//[values objectAtIndex:22];
    
    [newsCategories addObject:ad];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TopicModel* tmpModel = (TopicModel*) [newsCategories objectAtIndex:indexPath.row];
    // Configure the cell...
    [cell.textLabel setText: tmpModel.Title];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ViewHeadlines"]) {
        TopicModel * cat=[newsCategories objectAtIndex:[self.tableView indexPathForCell:sender].row] ;
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        HeadLineViewController* headlineVC = segue.destinationViewController;
        headlineVC.categroyID = [cat.ID intValue];
    }

}

 

@end
