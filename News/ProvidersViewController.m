//
//  ProvidersViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 12/21/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "ProvidersViewController.h"

@interface ProvidersViewController ()
{
    NSMutableArray* newsProviders;
}
@end

@implementation ProvidersViewController

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
    
    newsProviders = [[NSMutableArray alloc]init];
    
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
 //   [self LoadData];
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:NO forKey:@"firstlaunch"];
    [userdefaults synchronize];

}


#pragma mark - Loading data functions
//
//- (void) AddToProviders:(ProviderModel*) newProvider
//{
//    ProviderModel* provider = [[ProviderModel alloc]init];
//    provider.ID = newProvider.ID;
//    provider.Image = newProvider.Image;
//    provider.URL = newProvider.URL;
//    provider.Title = newProvider.Title;
//    
//    [newsProviders addObject:provider];
//}
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[[ProvidersManager getProvidersManager] providers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProviderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:provider.Title];
    
    if(provider.IsSelected)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProviderModel* provider = (ProviderModel*)[[[ProvidersManager getProvidersManager] providers] objectAtIndex:indexPath.row];


    // Navigation logic may go here. Create and push another view controller.
    UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [[ProvidersManager getProvidersManager] setIsSelected:provider.ID withValue:NO];
        //selectedRows[indexPath.row] =NO;
    }
    else if(  selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[ProvidersManager getProvidersManager] setIsSelected:provider.ID withValue:YES];
        //selectedRows[indexPath.row] =YES;
    }
    // repeatDays = [NSMutableArray a]
    
}

@end
