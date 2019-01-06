//
//  ViewController.m
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 30/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#include "SortMovies.h"

@interface ViewController ()
{
    //struct Movie arr[];
    //struct Movie **data;
    //struct Movie movies[] ;
    const char *pathChar;
    
}
@property (assign, nonatomic) NSInteger downloadedPageFor2017;
@property (assign, nonatomic) NSInteger totalPageFor2017;
@property (assign, nonatomic) NSInteger downloadedPageFor2018;
@property (assign, nonatomic) NSInteger totalPageFor2018;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic) NSString *filepath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"downladed_data"] == NULL) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"downladed_data"];
    }
    self.data = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _downloadedPageFor2017 = 775;//1;
    _totalPageFor2017 = 1;
    _downloadedPageFor2018 = 600;//1;
    _totalPageFor2018 = 1;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"downladed_data"]) {
        [self sortMovies];
    }else {
        [self loadDataForYear2017];
    }
}

- (void) loadDataForYear2017 {
    NSString *apiKey = @"1816d8a8b1da93ab2a80b3bd935a76e3";
    NSString *year2017 = @"2017";
    NSLog(@"To Download 2017 %ld",_downloadedPageFor2017);
    [NetworkManager discoverMovieWithAPIKey:apiKey year:year2017 page:[NSString stringWithFormat:@"%ld",_downloadedPageFor2017] onCompletion:^(BOOL success, id JSON) {
      
        NSNumber *total_pages = [JSON objectForKey:@"total_pages"];
        if (total_pages) {
            self.totalPageFor2017 = [total_pages integerValue];
        }
        if (success){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSNumber *page = [JSON objectForKey:@"page"];
                    self.downloadedPageFor2017 = [page integerValue];
                    NSArray *titles = [JSON objectForKey:@"results"];
                for (int g=0; g<[titles count]; g++) {
                    NSDictionary *aResult = [titles objectAtIndex:g];
                    NSString *title = [aResult objectForKey:@"title"];
                    NSString *vote =[aResult objectForKey:@"vote_average"];
                    [self writeTitle:title withVote:vote];
                    
//                    //const char *titleChar = [title UTF8String];
//                    aMovie.title =  [title UTF8String];
//                    aMovie.vote = [[aResult objectForKey:@"vote_average"] intValue];
//                    NSValue *value = [NSValue valueWithBytes:&aMovie objCType:@encode(struct Movie)];
//
                    //[self.data addObject:value];
                    //[self.data addObject:aMovie];
                    // self->arr [g] = aMovie;
                
                }
            }];
        }
        if ( self.totalPageFor2017 > self.downloadedPageFor2017) {
            self.downloadedPageFor2017 +=1 ;
            [self loadDataForYear2017];
        }else if ( self.totalPageFor2017 >= self.downloadedPageFor2017){
            
//            Sort *
//            //[self loadDataForYear2018];
              //sortDates(*arr);
              //sortMovies((__bridge struct Movie *)(self.data), [self.data count]);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self sortMovies];
            }];
           
            
        }
    }];
}

- (void) loadDataForYear2018 {
    
    NSString *apiKey = @"1816d8a8b1da93ab2a80b3bd935a76e3";
    NSString *year2018 = @"2018";
    NSLog(@"To Download 2017 %ld",_downloadedPageFor2018);
    [NetworkManager discoverMovieWithAPIKey:apiKey year:year2018 page:[NSString stringWithFormat:@"%ld",_downloadedPageFor2018] onCompletion:^(BOOL success, id JSON) {
        NSLog(@"message %@",JSON);
        NSNumber *total_pages = [JSON objectForKey:@"total_pages"];
        if (total_pages) {
            self.totalPageFor2018 = [total_pages integerValue];
        }
        if (success){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSNumber *page = [JSON objectForKey:@"page"];
                    self.downloadedPageFor2018 = [page integerValue];
            }];
        }
        if ( self.totalPageFor2018 > self.downloadedPageFor2018) {
            self.downloadedPageFor2018 +=1 ;
            [self loadDataForYear2018];
        }
    }];
}


-(void)writeTitle:(NSString *)title withVote:(NSString *)vote
{
    //Get the file path
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"Data.txt"];
    
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    NSString *content;
    content = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSString *mergedContent;
    
    mergedContent = [NSString stringWithFormat:@"%@,%@\n %@",title,vote,content];
    [file writeData:[mergedContent dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
    
}

-(void)sortMovies{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.filepath = [documentsDirectory stringByAppendingPathComponent:@"Data"];
    
    //NSMutableString *filePath = [NSMutableString stringWithFormat:@"%@",fileName];
    pathChar = [self.filepath  cStringUsingEncoding:NSUTF8StringEncoding];//UTF8String

     char const *path_cstr = [[NSFileManager defaultManager] fileSystemRepresentationWithPath:self.filepath];
    int result = readData(path_cstr);
    NSLog(@"result %d", result);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"downladed_data"];
}

@end
