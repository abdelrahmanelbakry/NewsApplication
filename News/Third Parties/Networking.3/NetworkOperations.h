//
//  NetworkOperations.h
//  NetworkOperations
//
//  Created by Ahmad al-Moraly on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * @file
 * Definition of NetworkOperations
 * An AFNetworking Wrapper that holds all the loading operations.
 *
 * @author Ahmad al-Moraly
 *
 * @copyright 2012 Artgine
 *
 * This class holds all the AFNetworing functions and provides 
 * a simple easy-to use API to deal with.
 * All methods of this class are 'Class Methods' to make sure that there is only
 * one instance of that class to use.
 */

#import "AFNetworking.h"

#define TURN_LOGGER_ON YES


#define ON_FAILURE_ERROR_MSG @"فشل الاتصال"
#define ON_FAILURE_ERROR_TITLE @"عفوا"
#define ON_FAILURE_ERROR_CANCEL_BUTTON_TITLE @"إلغاء"
#define ON_FAILURE_ERROR_TRY_AGAIN_BUTTON_TITLE @"حاول مرة أخرى"



/**
 Enum that holds the HTTP Request Methods
 */
typedef enum  {
    HTTPRequestMethodGET,
    HTTPRequestMethodPOST
} HTTPRequestMethod;

typedef void (^SuccessBlock)(id);
typedef void (^FailureBlock)(NSError *);
typedef void (^ProgressBlock)(NSInteger, NSInteger, NSInteger);

@interface NetworkOperations : AFHTTPClient

@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailureBlock failureBlock;
@property (nonatomic, strong) ProgressBlock progressBlock;

@property (nonatomic, strong) NSURLRequest *operationRequest;


+(void)startReachabilityNotificationWithObserver:(id)observer andSelector:(SEL)selector;
+(void)stopReachabilityNotificationWithObserver:(id)observer;
/**
 Creates and enques a Request operation with the specified parameters and RequestMethod.
 
 @param parameters an NSDictionary that holds all the parametrs for the request.
 @param RequestMethod The request Method used to create the operations.
 @param success: A block object to be executed upon the success of all of the request.
 This block has no return value and takes a single argument: the response object. 
 */

+(AFHTTPRequestOperation *) operationWithParamerters:(NSDictionary *)parameters
                                       requestMethod:(HTTPRequestMethod)requestMethod
                                     andSuccessBlock:(void (^)(id response))success;



/**
 Creates and enques a request operation with the specified parameters and RequestMethod.
 
 @param parameters: an NSDictionary that holds all the parametrs for the request.
 @param RequestMethod: The request Method used to create the operations.
 @param success: A block object to be executed upon the success of the request.
 This block has no return value and takes a single argument: the response object. 
 @param failure: A block object to be executed upon the failure of the request.
 This block has no return value and takes a single argument: the error of the operation.
 */

+(AFHTTPRequestOperation *) operationWithParamerters:(NSDictionary *)parameters
                                       requestMethod:(HTTPRequestMethod)requestMethod
                                        successBlock:(void (^)(id response))success
                                     andFailureBlock:(void (^)(NSError *error))failure;



/**
 Creates and enques a request operation with the specified parameters and RequestMethod.
 
 @param parameters: an NSDictionary that holds all the parametrs for the request.
 @param RequestMethod: The request Method used to create the operations.
 @param success: A block object to be executed upon the success of the request.
 This block has no return value and takes a single argument: the response object.
 @param progress: A block object to be executed while downloading the response of
 that request.
 This block has no return value and takes three arguments: bytesRead now, all the downloaded bytes till now and expected number of bytes to be downloaded.
 @param failure: A block object to be executed upon the failure of the request.
 This block has no return value and takes a single argument: the error of the operation.
 */
+(AFHTTPRequestOperation *) operationWithParamerters:(NSDictionary *)parameters
                                       requestMethod:(HTTPRequestMethod)requestMethod
                                       progressBlock:(void (^)(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead))progress
                                        successBlock:(void (^)(id response))success
                                     andFailureBlock:(void (^)(NSError *error))failure;



/**
 Creates and enques a request operation with the specified full URL with the specified parameters and RequestMethod.
 
 @param url: The full URL to create the request.
 @param parameters: an NSDictionary that holds all the parametrs for the request.
 @param RequestMethod: The request Method used to create the operations.
 @param success: A block object to be executed upon the success of the request.
 This block has no return value and takes a single argument: the response object.
 @param failure: A block object to be executed upon the failure of the request.
 This block has no return value and takes a single argument: the error of the operation.
 
 @discussion use this method to make requests with a diffrent host than the specified baseURL above.
 */
+(AFHTTPRequestOperation *) operationWithFullURL:(NSString *)url
                                      parameters:(NSDictionary *)parameters
                                   requestMethod:(HTTPRequestMethod)requestMethod
                                    successBlock:(void (^)(id response))success
                                 andFailureBlock:(void (^)(NSError *error))failure;

+(AFHTTPRequestOperation *) operationWithPath:(NSString *)url
                                      parameters:(NSDictionary *)parameters
                                   requestMethod:(HTTPRequestMethod)requestMethod
                                    successBlock:(void (^)(id response))success
                                 andFailureBlock:(void (^)(NSError *error))failure;


+(AFHTTPRequestOperation *)uploadImage:(UIImage *)image
                              withName:(NSString *)name
                                  path:(NSString *)url
                            parameters:(NSDictionary *)parameters
                              progress:(void (^)(NSInteger, NSInteger, NSInteger))progress
                               success:(void (^)(id response))success
                            andFailure:(void (^)(NSError *))failure;

+(AFHTTPRequestOperation *)uploadImages:(NSArray *)images
                              withName:(NSString *)name
                                  path:(NSString *)url
                            parameters:(NSDictionary *)parameters
                              progress:(void (^)(NSInteger, NSInteger, NSInteger))progress
                               success:(void (^)(id response))success
                            andFailure:(void (^)(NSError *))failure;


@end
