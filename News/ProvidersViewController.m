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
- (IBAction)editButton:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"ReOrder"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section==0)
        return [[[ProvidersManager getProvidersManager] providers] count];
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return @"Providers";
    
    return @"Update Rate";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProviderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if(indexPath.section==0)
    {
        ProviderModel* provider = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:provider.Title];
        
        if(provider.IsSelected)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        
        if(indexPath.row == 0)
           [cell.textLabel setText:@"Every 15 Mins."];
        if(indexPath.row == 1)
            [cell.textLabel setText:@"Every 30 Mins."];
        
        if([userdefaults integerForKey:@"rate"] == indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;

        
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    ProviderModel* tmpModel = [[ProviderModel alloc] init];
    
    ProviderModel* model = (ProviderModel*) [[[ProvidersManager getProvidersManager] providers] objectAtIndex:fromIndexPath.row];
    
    tmpModel.ID = model.ID;
    tmpModel.Title = [model.Title copy];
    tmpModel.Image = [model.Image copy];
    tmpModel.URL = [model.URL copy];
    tmpModel.IsSelected = model.IsSelected;
    
    [[ProvidersManager getProvidersManager] removeProviderByID:model.ID];
    [[ProvidersManager getProvidersManager] insertProvider:tmpModel atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if(indexPath.section==0)
        return YES;
    else
        return NO;
}


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
    if(indexPath.section==0)
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
    else
    {
        UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];

        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setInteger:indexPath.row forKey:@"rate"];
        
//        if(indexPath.row == 0)
//            [cell.textLabel setText:@"Every 15 Mins."];
//        if(indexPath.row == 1)
//            [cell.textLabel setText:@"Every 30 Mins."];
        
        //if([userdefaults integerForKey:@"rate"] == indexPath.row)
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView reloadData];        //else
          //  selectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
