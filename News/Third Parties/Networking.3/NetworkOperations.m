    //
    //  NetworkOperations.m
    //  NetworkOperations
    //
    //  Created by Ahmad al-Moraly on 4/10/12.
    //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
    //

#import "AFNetworking.h"

#import "XMLDictionary.h"

#import "NetworkOperations.h"


/**
 * The baseURl to be used in constructing all the requests.
 *
 * change this to be the name of the Base URL of your server.
 */
NSString * const kNetworkBaseURLString = @"http://www.mstaml.com/mobileajax.php";


@interface NetworkOperations ()

+(NSMutableURLRequest *)requestWithMethod:(HTTPRequestMethod)requestMethod
                            andParameters:(NSDictionary *)parameters;
+(NSMutableURLRequest *)requestWithPath:(NSString *)path method:(HTTPRequestMethod)requestMethod
                          andParameters:(NSDictionary *)parameters;


+(AFHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request
                                       progress:(void (^)(NSInteger, NSInteger, NSInteger))progress
                                        success:(void (^)(id))success
                                        failure:(void (^)(NSError *))failure;

+(NSMutableURLRequest *)imageUploadRequestWithImage:(UIImage *)image
                                           withName:(NSString *)name
                                               path:(NSString *)url
                                         parameters:(NSDictionary *)parameters;

+(NSMutableURLRequest *)imagesUploadRequestWithImages:(NSArray *)images withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters;

+(NetworkOperations *)sharedClient;

@end

@implementation NetworkOperations


+(void)startReachabilityNotificationWithObserver:(id)observer andSelector:(SEL)selector {
    [self sharedClient];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:AFNetworkingOperationDidStartNotification object:nil];
}


+(void)stopReachabilityNotificationWithObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:AFNetworkingOperationDidStartNotification object:nil];//AFNetworkingReachabilityDidChangeNotification
}

#pragma mark -
#pragma mark - Public API
+(AFHTTPRequestOperation *)operationWithParamerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod andSuccessBlock:(void (^)(id))success {
    
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod andParameters:parameters];
    
    return [self operationWithRequest:request progress:nil success:success failure:nil];
}

+(AFHTTPRequestOperation *)operationWithParamerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod andParameters:parameters];
    return [self operationWithRequest:request progress:nil success:success failure:failure];
}

+(AFHTTPRequestOperation *)operationWithParamerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod progressBlock:(void (^)(NSInteger, NSInteger, NSInteger))progress successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod andParameters:parameters];
    return [self operationWithRequest:request progress:progress success:success failure:failure];
    
}

+(AFHTTPRequestOperation *)operationWithFullURL:(NSString *)url parameters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    switch (requestMethod) {
        case HTTPRequestMethodGET:
            [request setHTTPMethod:@"GET"];
            break;
        case HTTPRequestMethodPOST:
            [request setHTTPMethod:@"POST"];
        default:
            break;
    }
    
    return [self operationWithRequest:request progress:nil success:success failure:failure];
}

+(AFHTTPRequestOperation *)operationWithPath:(NSString *)url parameters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure
{
    NSMutableURLRequest *request = [self requestWithPath:url method:requestMethod andParameters:parameters];
    return [self operationWithRequest:request progress:nil success:success failure:failure];
    
}


+(AFHTTPRequestOperation *)uploadImage:(UIImage *)image withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success andFailure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self imageUploadRequestWithImage:image withName:name path:url parameters:parameters];
    
    return [self operationWithRequest:request progress:progress success:success failure:failure];
}

+(AFHTTPRequestOperation *)uploadImages:(NSArray *)images withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success andFailure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self imagesUploadRequestWithImages:images withName:name path:url parameters:parameters];
    
    return [self operationWithRequest:request progress:progress success:success failure:failure];
}

#pragma mark -
#pragma mark - Private API

+(NSMutableURLRequest *)requestWithMethod:(HTTPRequestMethod)requestMethod andParameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request;
    switch (requestMethod) {
        case HTTPRequestMethodGET:
            request = [[self sharedClient] requestWithMethod:@"GET" path:@"" parameters:parameters];
            break;
            
        case HTTPRequestMethodPOST:
            request = [[self sharedClient] requestWithMethod:@"POST" path:@"" parameters:parameters];
            break;
        default:
            request = nil;
            break;
    }
    
    return request;
}

+(NSMutableURLRequest *)requestWithPath:(NSString *)path method:(HTTPRequestMethod)requestMethod andParameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request;
    switch (requestMethod) {
        case HTTPRequestMethodGET:
            request = [[self sharedClient] requestWithMethod:@"GET" path:path parameters:parameters];
            break;
            
        case HTTPRequestMethodPOST:
            request = [[self sharedClient] requestWithMethod:@"POST" path:path parameters:parameters];
            break;
        default:
            request = nil;
            break;
    }
    
    return request;
}

+(NSMutableURLRequest *)imageUploadRequestWithImage:(UIImage *)image withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters {
    
    NSString *mimeType;
    NSData *imageData = UIImagePNGRepresentation(image);
    mimeType = @"image/png";
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
        mimeType = @"image/jpg";
    }
    
    NSMutableURLRequest *request = [[self sharedClient] multipartFormRequestWithMethod:@"POST" path:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:name fileName:@"uploadedImage.png" mimeType:mimeType];
    }];
    
    return request;
}

+(NSMutableURLRequest *)imagesUploadRequestWithImages:(NSArray *)images withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters {
    
    NSMutableURLRequest *request = [[self sharedClient] multipartFormRequestWithMethod:@"POST" path:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        NSMutableArray *array = [NSMutableArray array];
                                        for (UIImage *image in images)
                                        {
                                            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                                            [array addObject:imageData];
                                        }
                                        [formData appendPartWithFiles:array name:name fileName:@"uploadedImage.png" mimeType:@"image/jpg"];
                                        
                                    }];
    return request;
}

+(AFHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    AFHTTPRequestOperation *operation = [[self sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Downloaded Response] %@\n", operation.responseString);
        
        NSError *parsingError;
        NSDictionary *parsedDictionary = [NSDictionary dictionaryWithXMLData:operation.responseData andError:&parsingError];
        
        if (parsedDictionary != nil && parsingError == nil) {
                // no errors.
            if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Parsed Response] %@\n", parsedDictionary);
            if (success) {
                success(parsedDictionary);
            }
        } else {
                // try JSON
            if (operation.responseData) {
                
                
                id val = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&parsingError];
                parsingError = nil;
                if (val && !parsingError) {
                    if (success) {
                        success(val);
                    }
                }
                else{
                    if (failure) {
                        failure(@"can't parse");
                    }
                }
            }
            else {
                if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Parsing ERROR] %@\n", parsingError);
                if (failure) {
                    failure(parsingError);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Downloading ERROR] %@\n", error);
        if (failure) {
            failure(error);
            [self sharedClient].operationRequest = operation.request;
            [self sharedClient].successBlock = Block_copy(success);
            [self sharedClient].progressBlock = Block_copy(progress);
            [self sharedClient].failureBlock = Block_copy(failure);
            [[self sharedClient] showErrorAlert];
        }
        
    }];
    
    [operation setDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (TURN_LOGGER_ON) {
                //   NSLog(@"[NetworkOperations downloaded: %lld of %lld bytes]", totalBytesRead, totalBytesExpectedToRead);
            if (progress) {
                progress(bytesRead, totalBytesRead, totalBytesExpectedToRead);
            }
        }
    }];
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (TURN_LOGGER_ON) {
            NSLog(@"[NetworkOperations Uploaded: %lld of %lld bytes]", totalBytesWritten, totalBytesExpectedToWrite);
            if (progress) {
                progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            }
        }
    }];
    
    [[self sharedClient] enqueueHTTPRequestOperation:operation];
    
    [operation addObserver:[self sharedClient] forKeyPath:@"isExecuting" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    return operation;
    
}

+(NetworkOperations *)sharedClient {
    static NetworkOperations *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNetworkBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
    }
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"text/*"];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isKindOfClass:[NSOperation class]] && [keyPath isEqualToString:@"isExecuting"]) {
        AFURLConnectionOperation *operation = object;
        if (operation.isExecuting) {
            NSString *body = nil;
            if (operation.request.HTTPBody) {
                body = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
            }
            
            NSLog(@"[Network Operations Start Operation With URL: %@ Parameters: %@ Request Method: %@]", operation.request.URL, body, operation.request.HTTPMethod);   
            
            [body release];         
        } else if (operation.isFinished || operation.isCancelled) {
            [operation removeObserver:self forKeyPath:keyPath];
        }
    }
}

#pragma mark -
-(void)showErrorAlert {
    [[[[UIAlertView alloc] initWithTitle:ON_FAILURE_ERROR_TITLE message:ON_FAILURE_ERROR_MSG delegate:self cancelButtonTitle:ON_FAILURE_ERROR_CANCEL_BUTTON_TITLE otherButtonTitles:ON_FAILURE_ERROR_TRY_AGAIN_BUTTON_TITLE, nil] autorelease] show];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
            // try again
        [[self class] operationWithRequest:self.operationRequest progress:self.progressBlock success:self.successBlock failure:self.failureBlock];
            //[self release];
		self = nil;
    }
}


@end

