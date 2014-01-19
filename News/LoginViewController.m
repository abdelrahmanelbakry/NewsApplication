//
//  LoginViewController.m
//  News
//
//  Created by Abdelrahman Mohamed on 1/4/14.
//  Copyright (c) 2014 Artgine. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txtPassword,txtUser;

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
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
-(IBAction)hidekeyboard:(id)sender
{
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}
-(IBAction)login:(id)sender
{
    if (reach.isReachable)
    {
        if([txtPassword.text length]>0 && [txtUser.text length]>0)
        {
            //Encrypt the password
         //   NSString* encryptedPassword = [self md5:txtPassword.text ];
            NSURL* url = [NSURL URLWithString:@"http://young-journey-4873.herokuapp.com/login"];
            NSString* strURL = [NSString stringWithFormat:@"{\"utf8\":\"✓\", \"session\":{\"email\":\"%@\", \"password\":\"%@\"}, \"commit\":\"Login\"}",txtUser.text,txtPassword.text ];
            //[NSString stringWithFormat:@"{\"utf8\":\"✓\",\"user\":{\"first_name\":\"man2\", \"last_name\":\"human2\", \"password\":\"123456\", \"mobile_no\":\"1212\", \"email\":\"human57@earth.com\"}, \"commit\":\"Register\"}"];
            
            NSData* requestData = [strURL dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[url standardizedURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            //Set HTTP method
            [request setHTTPMethod:@"POST"];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
      

            
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
     //   NSDictionary *headerFields = [(NSHTTPURLResponse*)response allHeaderFields]; //This would give you all the header fields;
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        
        NSArray *allCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[urlResponse allHeaderFields] forURL:[response URL]];
        
        if ([allCookies count]) {
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:allCookies forURL:[response URL] mainDocumentURL:nil];
        }
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
    if([response rangeOfString:@"Success"].location != NSNotFound)
    {
        NSArray* components = [response componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":}"]];
        NSUserDefaults* userdefualts = [NSUserDefaults standardUserDefaults];
        [userdefualts setObject:[components objectAtIndex:[components count]-2] forKey:@"user_id"];
        
        
        CategoriesViewController* categoriesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesView"];
        [self.navigationController pushViewController:categoriesViewController animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}
@end
