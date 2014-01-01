//
//  RegsistraionViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 12/22/13.
//  Copyright (c) 2013 Artgine. All rights reserved.
//

#import "RegsistraionViewController.h"

@interface RegsistraionViewController ()

@end

@implementation RegsistraionViewController

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
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary*) constructquery
{
    NSMutableDictionary* Query = [[NSMutableDictionary alloc]init];
    /*
     [Query setObject:@"ad" forKey:@"operation"];
     
     [Query setObject:[NSNumber numberWithInt:currentAd] forKey:@"i"];
     */
    
    return Query;
}

-(IBAction) regsister:(id) sender
{
    if (reach.isReachable)
    {
        NSURL* url = [NSURL URLWithString:@"http://young-journey-4873.herokuapp.com/register"];
        NSString* strURL = [NSString stringWithFormat:@"{\"utf8\":\"✓\",\"user\":{\"first_name\":\"man\", \"last_name\":\"human\", \"password\":\"123456\", \"mobile_no\":\"121\", \"email\":\"human3@earth.com\"}, \"commit\":\"Register\"}"];
        
        NSData* requestData = [strURL dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        //Set HTTP method
        [request setHTTPMethod:@"POST"];
        
        //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       // [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:requestData];
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
//
//        [NetworkOperations operationWithFullURL:strURL parameters:[self constructquery] requestMethod:HTTPRequestMethodPOST successBlock:^(id response){
//            if ([response count]>0) {
//                NSLog(@"Sections data response : %@",response);
//           //     [self parseResponse:response];
//                
//                //  [self.tableView reloadData];
//                // [self setupPageControlPropertiesWithNumberOfPages:[self.adDataModel.AllImgs count]];
//                
//             //   [self updateLayout];
//               // [mytableView reloadData];
//            }
//            
//            
//        }  andFailureBlock:^(NSError *error) {
        
//        }] ;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    recievedData = [data mutableCopy];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* response = [[NSString alloc] initWithData:recievedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    
}
@end
