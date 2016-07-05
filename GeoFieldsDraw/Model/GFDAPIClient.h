//
//  GFDAPIClient.h
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface GFDAPIClient : AFHTTPSessionManager

+ (GFDAPIClient *)sharedClient;

#pragma mark -
- (void)fieldsJsonWithSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
