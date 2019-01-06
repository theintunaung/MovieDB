//
//  URLConnection.m
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 30/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#import "URLConnection.h"

@interface URLConnection ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) void (^onCompletion) (NSData *data, NSURLConnection *connection, NSError *error);

@end


@implementation URLConnection 
+ (URLConnection *)connectionWithRequest:(NSURLRequest *)request onCompletion:(void (^)(NSData *, NSURLConnection *, NSError *))completion
{
    URLConnection *aConnection = [[URLConnection alloc] init];
    aConnection.connection = [[NSURLConnection alloc] initWithRequest:request delegate:aConnection];
    aConnection.onCompletion = completion;
    return aConnection;
}

- (void)start
{
    [self.connection start];
}

#pragma mark -  NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.data = data;
}

//If finish, return the data and the error nil
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.onCompletion) self.onCompletion(self.data, connection, nil);
}

//If fail, return nil and an error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.onCompletion) self.onCompletion(nil, connection, error);
}


@end
