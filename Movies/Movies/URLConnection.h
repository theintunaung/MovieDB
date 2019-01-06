//
//  URLConnection.h
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 30/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLConnection : NSObject

+ (URLConnection *)connectionWithRequest:(NSURLRequest *)request onCompletion:(void (^)(NSData *data, NSURLConnection *connection, NSError *error))completion;
- (void)start;

@end

NS_ASSUME_NONNULL_END
