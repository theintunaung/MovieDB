//
//  NetworkManager.m
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 30/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#import "NetworkManager.h"
#import "URLConnection.h"
static NSString * const baseAPI = @"https://api.themoviedb.org/3";
static NSString * const discoverPath = @"/discover/movie";
static NSString *apiKey = @"1816d8a8b1da93ab2a80b3bd935a76e3";

//https://api.themoviedb.org/3/discover/movie?api_key=1816d8a8b1da93ab2a80b3bd935a76e3

@interface NetworkManager ()<NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation NetworkManager

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 30;
        configuration.timeoutIntervalForResource = 30;
        //        configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

+ (void)discoverMovieWithYear:(NSString*)aYear page:(NSString*)aPage onCompletion:(void (^)(BOOL success, id JSON))completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (apiKey) [params setObject:apiKey forKey:@"api_key"];
    if (aYear) [params setObject:aYear forKey:@"primary_release_year"];
    if (aPage) [params setObject:aPage forKey:@"page"];
    
    [self callAPI:discoverPath withParameters:params method:@"POST" authentication:YES onCompletion:^(BOOL success, id JSON) {
        if (completion) completion(success, JSON);
    }];
}


+ (URLConnection *)callAPI:(NSString *)api withParameters:(NSDictionary *)params method:(NSString *)method authentication:(BOOL)auth onCompletion:(void (^)(BOOL success, id JSON))completion
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?api_key=%@&primary_release_year=%@&page=%@", baseAPI, api,[params objectForKey:@"api_key"],[params objectForKey:@"primary_release_year"],[params objectForKey:@"page"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:method];

    
    URLConnection *connection = [URLConnection connectionWithRequest:request onCompletion:^(NSData *data, NSURLConnection *connection, NSError *error) {
        //NSLog(@"the connection :\n%@", connection);
        if (!error && data){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"the response :\n%@", json);
           BOOL success = NO;
            NSArray *results = [json objectForKey:@"results"];
            if ([results count]>0) success = YES;
            if (completion) completion(success, json);
        }else {
            NSLog(@"%@", error);
            if (completion) completion(NO, nil);
        }
    }];
    [connection start];
    return connection;
}



@end


