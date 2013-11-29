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

@synthesize topicDataModel;
@synthesize topicID;
@synthesize topicTitle,topicContent,topicImg;

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

    [self getCurrentTopicData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateLayout
{
   // if(self.topicID==1)
  //  {
    
  //  }
    
    [self.topicContent setText:self.topicDataModel.Content];
    [self.topicImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.topicDataModel.AllImgs objectAtIndex:0] ]]];
    [self.topicTitle setText:self.topicDataModel.Title];
    
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
    
   // for ( int i=0; i< [[response  objectForKey:@"img"] count]; i++)
   // {
  //  [self.topicDataModel.AllImgs addObject:[[response objectForKey:@"img"] objectAtIndex:0]];
        
   // }
    
     [self.topicDataModel.AllImgs addObject:[response objectForKey:@"img"]!=[NSNull null]?[response objectForKey:@"img"]:@""];
//    topicDataModel.Date=[[response objectForKey:@"detail"] objectForKey:@"post"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"post"]:@"";
    topicDataModel.ID=[response  objectForKey:@"id"]!=[NSNull null]?[response  objectForKey:@"id"]:@"";
    topicDataModel.Title=[response  objectForKey:@"title"]!=[NSNull null]?[response  objectForKey:@"title"]:@"";
//    topicDataModel.Author=[[response objectForKey:@"detail"] objectForKey:@"author"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"author"]:@"";
//    topicDataModel.NumberOfViews = [[response objectForKey:@"detail"] objectForKey:@"read"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"read"]:@"";
//    topicDataModel.NumberOfReadings = [[response objectForKey:@"detail"] objectForKey:@"readbody"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"readbody"]:@"";
    
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
            
        }
        
        
    }  andFailureBlock:^(NSError *error) {
        
    }] ;
    
}

@end
