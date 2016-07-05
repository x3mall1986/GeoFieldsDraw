//
//  GFDAPIClient.m
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import "GFDAPIClient.h"

static NSString *const kBaseURLString = @"http://fs181.www.ex.ua";
static NSString *const kFileURLString = @"get/502973133522/212b5b0dccf1467f8874c2aee12cac8f/256389018/fields.json";

@implementation GFDAPIClient

+ (GFDAPIClient *)sharedClient
{
    static GFDAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    return self;
}

- (void)fieldsJsonWithSuccess:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self sendGetRequestForUrlPath:kFileURLString withParameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = nil;
        NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if (success) {
            success(task, serializedDictionary);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

#pragma mark - API Request
- (void)sendGetRequestForUrlPath:(NSString *)urlPath withParameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self GET:urlPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
