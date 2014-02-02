//
//  DetailViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 11/16/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "DetailViewController.h"

#define TOPIC1_CONTENT @"أعلن الجهاز الطبي للمنتخب الألماني عن إصابة نجم منتخبه ونادي ريال مدريد الاسباني سامي خضيرة بقطع في الرباط الصليبي للركبة مما يعني غيابه عن الملاعب لستة أشهر على الأقل وذلك بحسب التقرير الرسمي ."

#define TOPIC2_CONTENT @"قال المهاجم الكولومبي راداميل فالكاو إنه سعيد للغاية بوجوده في فريقه الحالي موناكو، مبرزا أنه ينأى بنفسه عن الشائعات التي تدور حول رغبة تشيلسي وريال مدريد في ضمه."

#define HEADLINE1 @"خضيرة يصاب بقطع في الرباط الصليبي ويغيب ستة أشهر"
#define HEADLINE2 @"فالكاو سعيد في موناكو"


#define HEADLINE_URL @"http://young-journey-4873.herokuapp.com/"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize scrollView;
@synthesize topicDataModel;
@synthesize topicID;
@synthesize topicTitle,topicContent,topicImg;
@synthesize mytableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //hide the navigation bar
    //[self.navigationController setNavigationBarHidden:YES];
    
    //configure carousel
    _carousel.type = iCarouselTypeCoverFlow2;
    

    [self getCurrentTopicData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateLayout
{
    float scrollHeight=0;
    
    [self.topicContent setText:self.topicDataModel.Content];
    CGRect frame = self.topicContent.frame;
    frame.size.height = self.topicContent.contentSize.height+100;
    self.topicContent.frame = frame;
    //if([self.topicDataModel.AllImgs count]>0)
    [self.topicImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.topicDataModel.AllImgs objectAtIndex:0] ]] placeholderImage:[UIImage imageNamed:@"no-image-400x400.jpg"]];
   // else
     //   [self.topicImg removeFromSuperview];
    
    [self.topicTitle setText:self.topicDataModel.Title];
    
    scrollHeight+=frame.size.height+self.topicImg.frame.size.height+self.topicTitle.frame.size.height+150;
    scrollView.contentSize = CGSizeMake(320,scrollHeight);
    
}
#pragma mark Data Loading functions
-(void)getCurrentTopicData{
 
    [self LoadTopicData];

}


#pragma mark- Loading Data
-(NSDictionary*) constructquery
{
    NSMutableDictionary* Query = [[NSMutableDictionary alloc]init];
    /*
    [Query setObject:@"ad" forKey:@"operation"];
    
    [Query setObject:[NSNumber numberWithInt:currentAd] forKey:@"i"];
    */
   
    return Query;
}

-(void) parseResponse:(id) response
{
    self.topicDataModel = [[TopicModel alloc]init];
    
    self.topicDataModel.AllImgs = [[NSMutableArray alloc]init];
    
    self.topicDataModel.RelatedTopics = [[NSMutableArray alloc]init];
    

    for ( int i=0; i< [[response  objectForKey:@"Related"] count]; i++)
    {
        TopicModel* tmpModel = [[TopicModel alloc]init];
        tmpModel.AllImgs =[[NSMutableArray alloc]init];

        tmpModel.ID =[[[response objectForKey:@"Related"] objectAtIndex:i] objectForKey:@"id"];
        tmpModel.Title =[[[response objectForKey:@"Related"] objectAtIndex:i] objectForKey:@"title"];
        [tmpModel.AllImgs addObject:[[[response objectForKey:@"Related"] objectAtIndex:i] objectForKey:@"img"]!=[NSNull null]?[[[response objectForKey:@"Related"] objectAtIndex:i] objectForKey:@"img"]:@""];

       // tmpModel.ID =[[[response objectForKey:@"Related"] objectAtIndex:i] objectForKey:@"id"];

        [self.topicDataModel.RelatedTopics addObject:tmpModel];
    }
    
    if([self.topicDataModel.RelatedTopics count]==0)
       [self.mytableView removeFromSuperview];
    {
        [self.topicContent setFrame:CGRectMake(self.topicContent.frame.origin.x, self.topicContent.frame.origin.y, self.topicContent.frame.size.width, self.topicContent.frame.size.height+40)];
    }
    
     [self.topicDataModel.AllImgs addObject:[response objectForKey:@"img"]!=[NSNull null]?[response objectForKey:@"img"]:@""];
//    topicDataModel.Date=[[response objectForKey:@"detail"] objectForKey:@"post"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"post"]:@"";
    topicDataModel.ID=[response  objectForKey:@"id"]!=[NSNull null]?[response  objectForKey:@"id"]:@"";
    topicDataModel.Title=[response  objectForKey:@"title"]!=[NSNull null]?[response  objectForKey:@"title"]:@"";
//    topicDataModel.Author=[[response objectForKey:@"detail"] objectForKey:@"author"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"author"]:@"";
//    topicDataModel.NumberOfViews = [[response objectForKey:@"detail"] objectForKey:@"read"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"read"]:@"";
//    topicDataModel.NumberOfReadings = [[response objectForKey:@"detail"] objectForKey:@"readbody"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"readbody"]:@"";
 //   topicDataModel.RelatedTopics =[response  objectForKey:@"Related"]!=[NSNull null]?[response  objectForKey:@"Related"]:@"";
    topicDataModel.Content = ![[response  objectForKey:@"details"]isKindOfClass:[NSNull class]]?[response  objectForKey:@"details"]:@"";
    
//    topicDataModel.SectionName = ![[response  objectForKey:@"section"]isKindOfClass:[NSNull class]]?[response  objectForKey:@"section"]:@"";
}
-(void) LoadTopicData
{
    NSString* strURL = [NSString stringWithFormat:@"%@details/%i",HEADLINE_URL,topicID];

    [NetworkOperations operationWithFullURL:strURL parameters:[self constructquery] requestMethod:HTTPRequestMethodGET successBlock:^(id response){
        if ([response count]>0) {
            NSLog(@"Sections data response : %@",response);
            [self parseResponse:response];
            
          //  [self.tableView reloadData];
           // [self setupPageControlPropertiesWithNumberOfPages:[self.adDataModel.AllImgs count]];
            
            [self updateLayout];
            [mytableView reloadData];
            [_carousel reloadData];
        }
        
        
    }  andFailureBlock:^(NSError *error) {
        
    }] ;
    
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topicDataModel.RelatedTopics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"headLineCell";
    HeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    // ProviderModel* provider = [[ProvidersManager getProvidersManager] getProviderModel:[providers objectAtIndex:indexPath.section]];
    
    
    
    
    for(int i=0;i<[topicDataModel.RelatedTopics count];i++)
    {
        TopicModel* tmpModel = (TopicModel*) [topicDataModel.RelatedTopics objectAtIndex:i];
        if(!tmpModel.isDisplayed)
        {
            [cell setCellDataWith:tmpModel ];
            cell.tag = [tmpModel.ID intValue];
          //  [[groupedHeadlines objectForKey:[providers objectAtIndex:indexPath.section]] removeObject:tmpModel];
            tmpModel.isDisplayed = YES;
            
            //[self AddToTopics:tmpModel];
            
            break;
        }
    }
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"مواضيع ذات صلة";
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    UITableViewCell* selectedCell =[self.mytableView cellForRowAtIndexPath:indexPath];
    
    topicID = selectedCell.tag;
    
    [self getCurrentTopicData];
    
    // repeatDays = [NSMutableArray a]
    
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    //   / NSArray* providers = [providersSet allObjects];
//    if ([segue.identifier isEqualToString:@"ViewTopicSegueIdentifier"])
//    {
//        // NSArray* headlines = [groupedHeadlines objectForKey:[providers objectAtIndex:[self.tableView indexPathForCell:sender].section]];
//        
//        //  TopicModel * topic= [headlines objectAtIndex:[self.tableView indexPathForCell:sender].row];//[groupedHeadlines objectAtIndex:[self.tableView indexPathForCell:sender].row] ;
//        
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        
//        UITableViewCell* senderCell = (UITableViewCell*) sender;
//        
//        DetailViewController* detailVC = segue.destinationViewController;
//        detailVC.topicID = senderCell.tag ;
//    }
//}
#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [topicDataModel.RelatedTopics count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    TopicModel* tmpModel = (TopicModel*) [topicDataModel.RelatedTopics objectAtIndex:index];

    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        
      //  if([tmpModel.AllImgs count]>0)
        //    [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [tmpModel.AllImgs objectAtIndex:0] ]]];
        
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:20];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    label.text = tmpModel.Title;//[_items[index] stringValue];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

@end
