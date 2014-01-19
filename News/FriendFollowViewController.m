//
//  FriendFollowViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 1/18/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import "FriendFollowViewController.h"

FriendFollowViewController* sharedFriendController =nil;
@interface FriendFollowViewController ()
{
    NSMutableArray* friends;
    NSMutableArray* localBook;
}
@end

@implementation FriendFollowViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    sharedFriendController = self;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    friends = [[NSMutableArray alloc]init];
    localBook = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    [self getPersonOutOfAddressBook];
    
    [self LoadData];
}

#pragma mark - Getting Contacts
- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil)
    {
        NSLog(@"Succesful.");
        
        //2
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //3
        NSUInteger i = 0; for (i = 0; i < [allContacts count]; i++)
        {
            UserDataModel *person = [[UserDataModel alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            //4
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,
                                                                                  kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(contactPerson,
                                                             kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phoneNumbers) > 0)
            {
                person.MobileNo = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
                person.MobileNo = [person.MobileNo stringByReplacingOccurrencesOfString:@")" withString:@""];
                person.MobileNo = [person.MobileNo stringByReplacingOccurrencesOfString:@"(" withString:@""];
                person.MobileNo = [person.MobileNo stringByReplacingOccurrencesOfString:@" " withString:@""];
                person.MobileNo = [person.MobileNo stringByReplacingOccurrencesOfString:@"+" withString:@""];
                person.MobileNo = [person.MobileNo stringByReplacingOccurrencesOfString:@"-" withString:@""];

            }
            else
                continue;
            person.firstName = firstName;
            person.lastName = lastName;
            
            [self AddToBook:person];
        }
        
        //8
        CFRelease(addressBook);
    } else { 
        //9
        NSLog(@"Error reading Address Book");
    } 
}

-(IBAction)followUser:(id)sender
{
    
    UIButton* btnSender = (UIButton*) sender;
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];

   // FriendFollowCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnSender.tag  inSection:1]];
    UserDataModel* person = (UserDataModel*) [friends objectAtIndex:btnSender.tag];
    [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/follow/%@?iam=%@",person.ID,[userdefaults objectForKey:@"user_id"]] parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
        if (response.count >0)
        {
            
        }
        //else
        //   [SVProgressHUD dismiss];
    }  andFailureBlock:^(NSError *error) {
        // [SVProgressHUD dismiss];
    }] ;
    
    [friends removeObjectAtIndex:btnSender.tag];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btnSender.tag  inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - Loading data functions

-(void) LoadData
{
    if (reach.isReachable)
    {
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        
        [NetworkOperations operationWithFullURL:[NSString stringWithFormat:@"http://young-journey-4873.herokuapp.com/listUsersFollowedByMe/%@",[userdefaults objectForKey:@"user_id"]] parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"users"])
                {
                    UserDataModel* tmpModel=[[UserDataModel alloc]init];
                    
                    tmpModel.ID=[dic objectForKey:@"user_id"]!=[NSNull null]?[dic objectForKey:@"user_id"]:@"";
                    tmpModel.FirstName=[dic objectForKey:@"first_name"]!=[NSNull null]?[dic objectForKey:@"first_name"]:@"";
                    tmpModel.LastName=[dic objectForKey:@"last_name"]!=[NSNull null]?[dic objectForKey:@"last_name"]:@"";
                    tmpModel.MobileNo=[dic objectForKey:@"mobile_no"]!=[NSNull null]?[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile_no"]]:@"";
                    
                    [self refineBook:tmpModel];
                }
                //[self.tableView reloadData];
                [self LoadUsers];
                
            }
            //else
            //   [SVProgressHUD dismiss];
        }  andFailureBlock:^(NSError *error) {
            // [SVProgressHUD dismiss];
        }] ;
    }

}

-(void)LoadUsers
{
    
    if (reach.isReachable)
    {
        [NetworkOperations operationWithFullURL:@"http://young-journey-4873.herokuapp.com/listUsers" parameters:nil requestMethod:HTTPRequestMethodGET successBlock:^(NSDictionary * response){
            if (response.count >0)
            {
                //1- get the favorite topics
                //NSDictionary * favs= [[NSUserDefaults standardUserDefaults] objectForKey:@"favTopics"];
                //2- set up the topics array
                for (NSDictionary* dic in [response objectForKey:@"users"])
                {
                    UserDataModel* tmpModel=[[UserDataModel alloc]init];
                    
                    tmpModel.ID=[dic objectForKey:@"user_id"]!=[NSNull null]?[dic objectForKey:@"user_id"]:@"";
                    tmpModel.FirstName=[dic objectForKey:@"first_name"]!=[NSNull null]?[dic objectForKey:@"first_name"]:@"";
                    tmpModel.LastName=[dic objectForKey:@"last_name"]!=[NSNull null]?[dic objectForKey:@"last_name"]:@"";
                    tmpModel.MobileNo=[dic objectForKey:@"mobile_no"]!=[NSNull null]?[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile_no"]]:@"";

                    [self AddToUsers:tmpModel];
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

-(void) refineBook:(UserDataModel*) newAd
{
    for(int i=0;i<[localBook count];i++)
    {
        UserDataModel* person = (UserDataModel*) [localBook objectAtIndex:i];
        if([person.MobileNo isEqualToString:newAd.MobileNo])
        {
            [localBook removeObjectAtIndex:i];
            break;
        }
    }

}

- (void) AddToUsers:(UserDataModel*) newAd
{
    for(int i=0;i<[localBook count];i++)
    {
        UserDataModel* person = (UserDataModel*) [localBook objectAtIndex:i];
        if([person.MobileNo isEqualToString:newAd.MobileNo])
        {
            UserDataModel* ad = [[UserDataModel alloc]init];
            ad.ID = newAd.ID;//[values objectAtIndex:6];
            ad.FirstName = newAd.FirstName;//[values objectAtIndex:22];
            ad.LastName = newAd.LastName;
            ad.MobileNo = newAd.MobileNo;
            
            [friends addObject:ad];
            
            break;
        }
        
    }
    
}

- (void) AddToBook:(UserDataModel*) newAd
{
    UserDataModel* ad = [[UserDataModel alloc]init];
    ad.ID = newAd.ID;//[values objectAtIndex:6];
    ad.FirstName = newAd.FirstName;//[values objectAtIndex:22];
    ad.LastName = newAd.LastName;
    ad.MobileNo = newAd.MobileNo;
    
    [localBook addObject:ad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FollowFriendCell";
    FriendFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UserDataModel* person = (UserDataModel*) [friends objectAtIndex:indexPath.row];
    [cell.lblName setText:[NSString stringWithFormat:@"%@ %@", person.FirstName, person.LastName]];
    [cell.lblNumber setText:person.MobileNo];
    cell.tag = [person.ID intValue];
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

@end
