//
//  NetworkManager.h
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 30/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (void)discoverMovieWithYear:(NSString*)aYear page:(NSString*)aPage onCompletion:(void (^)(BOOL success, id JSON))completion;

@end

NS_ASSUME_NONNULL_END
