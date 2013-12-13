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
    NSArray* providers = [providersSet allObjects];
    if ([segue.identifier isEqualToString:@"ViewTopicSegueIdentifier"])
    {
        NSArray* headlines = [groupedHeadlines objectForKey:[providers objectAtIndex:[self.tableView indexPathForCell:sender].section]];

        TopicModel * topic= [headlines objectAtIndex:[self.tableView indexPathForCell:sender].row];//[groupedHeadlines objectAtIndex:[self.tableView indexPathForCell:sender].row] ;

        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        DetailViewController* detailVC = segue.destinationViewController;
        detailVC.topicID = [topic.ID intValue];
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
            [self shareAtFB];
            break;
        case 1:
            [self shareAtTwitter];
            break;
    }
    
}
-(void) shareAtFB
{
    ///////////////////Facebook Share Code
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=6) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"http://www.mstaml.com/section/item.php?i=%@",selectedTopic]];
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
            
            [AppSharer postOnFacebookURL:[NSString stringWithFormat:@"http://www.mstaml.com/section/item.php?i=%d",selectedTopic] withName:@"" caption:@"" description:@"" andImageURL:nil completionHandler:nil];
        }
    }else{
        [AppSharer postOnFacebookURL:[NSString stringWithFormat:@"http://www.mstaml.com/section/item.php?i=%d",selectedTopic] withName:@"" caption:@"" description:@"" andImageURL:nil completionHandler:^(BOOL success, NSError *error) {}];
    }
}
-(void) shareAtTwitter
{
    NSError *jsonError = nil;
    
    //NSString *jsonRequest=[NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",receiptBase64];
    
    //NSLog(@"Sending this JSON: %@",jsonRequest);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"http://www.mstaml.com/section/item.php?i=%d",selectedTopic],@"longUrl",nil] options:NSJSONWritingPrettyPrinted error:&jsonError];
    
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
    
    NSLog(@"short url : %@",shortURL);
    
    if ([self isSocialAvailable]) {
        
        NSLog(@"ert");
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            
        {
            
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
          //  NSString* tweetStr=[NSString stringWithFormat:@"%@ \n %@ \n   %@  ", selectedAd.Title.length>0? selectedAd.Title:selectedAd.Content,shortURL,@"#mostaml"];//selectedForumName
            
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
