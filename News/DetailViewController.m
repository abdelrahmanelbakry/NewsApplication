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
    if(self.topicID==1)
    {
        [self.topicContent setText:TOPIC1_CONTENT];
        [self.topicImg setImage:[UIImage imageNamed:@"img1.jpg"]];
        [self.topicTitle setText:HEADLINE1];
    }
    else
    {
        [self.topicContent setText:TOPIC2_CONTENT];
        [self.topicImg setImage:[UIImage imageNamed:@"img2.jpg"]];
        [self.topicTitle setText:HEADLINE2];

    }
}
#pragma mark Data Loading functions
-(void)getCurrentTopicData{
 
  //  [self LoadTopicData];
    [self updateLayout];

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
    
    for ( int i=0; i< [[[response objectForKey:@"detail"] objectForKey:@"imgs"] count]; i++)
    {
        [topicDataModel.AllImgs addObject:[[[response objectForKey:@"detail"] objectForKey:@"imgs"] objectAtIndex:i]];
        
    }
    topicDataModel.Date=[[response objectForKey:@"detail"] objectForKey:@"post"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"post"]:@"";
    topicDataModel.ID=[[response objectForKey:@"detail"] objectForKey:@"id"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"id"]:@"";
    topicDataModel.Title=[[response objectForKey:@"detail"] objectForKey:@"title"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"title"]:@"";
    topicDataModel.Author=[[response objectForKey:@"detail"] objectForKey:@"author"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"author"]:@"";
        topicDataModel.NumberOfViews = [[response objectForKey:@"detail"] objectForKey:@"read"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"read"]:@"";
    topicDataModel.NumberOfReadings = [[response objectForKey:@"detail"] objectForKey:@"readbody"]!=[NSNull null]?[[response objectForKey:@"detail"] objectForKey:@"readbody"]:@"";
    
    topicDataModel.Content = ![[[response objectForKey:@"detail"] objectForKey:@"body"]isKindOfClass:[NSNull class]]?[[response objectForKey:@"detail"] objectForKey:@"body"]:@"";
    topicDataModel.SectionName = ![[[response objectForKey:@"detail"] objectForKey:@"section"]isKindOfClass:[NSNull class]]?[[response objectForKey:@"detail"] objectForKey:@"section"]:@"";
}
-(void) LoadTopicData
{
    
    [NetworkOperations operationWithParamerters:[self constructquery] requestMethod:HTTPRequestMethodGET successBlock:^(id response){
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
