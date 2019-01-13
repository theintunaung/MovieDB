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
#import "MovieTableViewCell.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (assign, nonatomic) NSInteger downloadedPageFor2017;
@property (assign, nonatomic) NSInteger totalPageFor2017;
@property (assign, nonatomic) NSInteger downloadedPageFor2018;
@property (assign, nonatomic) NSInteger totalPageFor2018;
@property (strong, nonatomic) NSArray *data;
@property (nonatomic,retain) NSString *filepath;
@property (nonatomic,retain) NSString *docpath;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"downladed_data"] == NULL) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"downladed_data"];
    }
    self.data = [NSArray array];
    //_filepath =  [[NSString alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.docpath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.filepath = [self.docpath stringByAppendingPathComponent:@"Data.txt"];
    
    _downloadedPageFor2017 = 775;//1;
    _totalPageFor2017 = 1;
    _downloadedPageFor2018 = 600;//1;
    _totalPageFor2018 = 1;
    
    [self.activity  stopAnimating];

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"downladed_data"]) {
        [self sortMovies];
    }else {
        [[NSFileManager defaultManager] removeItemAtPath:self.filepath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Output.txt",self.docpath] error:nil];
        [self loadDataForYear2017];
    }
}

- (void) loadDataForYear2017 {
   
    NSString *year2017 = @"2017";
    NSLog(@"To Download 2017 %ld",_downloadedPageFor2017);
      [self.activity startAnimating ];
      [self.activity setHidden:NO];
    [NetworkManager discoverMovieWithYear:year2017 page:[NSString stringWithFormat:@"%ld",_downloadedPageFor2017] onCompletion:^(BOOL success, id JSON) {
     
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
                }
            }];
        }
        if ( self.totalPageFor2017 > self.downloadedPageFor2017) {
            self.downloadedPageFor2017 +=1 ;
            [self loadDataForYear2017];
        }else if ( self.totalPageFor2017 >= self.downloadedPageFor2017){
            
//            Sort *
[self loadDataForYear2018];
              //sortDates(*arr);
              //sortMovies((__bridge struct Movie *)(self.data), [self.data count]);
           
        }
    }];
}

- (void) loadDataForYear2018 {
    
    
    NSString *year2018 = @"2018";
    NSLog(@"To Download 2017 %ld",_downloadedPageFor2018);
    [NetworkManager discoverMovieWithYear:year2018 page:[NSString stringWithFormat:@"%ld",_downloadedPageFor2018] onCompletion:^(BOOL success, id JSON) {
        NSLog(@"message %@",JSON);
        NSNumber *total_pages = [JSON objectForKey:@"total_pages"];
        if (total_pages) {
            self.totalPageFor2018 = [total_pages integerValue];
        }
        if (success){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSNumber *page = [JSON objectForKey:@"page"];
                    self.downloadedPageFor2018 = [page integerValue];
                NSArray *titles = [JSON objectForKey:@"results"];
                for (int g=0; g<[titles count]; g++) {
                    NSDictionary *aResult = [titles objectAtIndex:g];
                    NSString *title = [aResult objectForKey:@"title"];
                    NSString *vote =[aResult objectForKey:@"vote_average"];
                    [self writeTitle:title withVote:vote];
                }
            }];
        }
        if ( self.totalPageFor2018 > self.downloadedPageFor2018) {
            self.downloadedPageFor2018 +=1 ;
            [self loadDataForYear2018];
        }else if ( self.totalPageFor2018 >= self.downloadedPageFor2018){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self sortMovies];
            }];
        }
    }];
}

-(void)writeTitle:(NSString *)title withVote:(NSString *)vote
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.filepath])
    {
        [[NSFileManager defaultManager] createFileAtPath:self.filepath contents:nil attributes:nil];
    }
    
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filepath];
    NSString *content;
    content = [NSString stringWithContentsOfFile:self.filepath encoding:NSUTF8StringEncoding error:nil];
    NSString *mergedContent;
    
    mergedContent = [NSString stringWithFormat:@"%@,%@\n %@",title,vote,content];
    [file writeData:[mergedContent dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
    
}

-(void)sortMovies {
    [self.activity setHidden:YES];
    [self.activity  stopAnimating];
    NSLog(@"%@",self.filepath );
    int result = readData((const char * __restrict)[self.docpath UTF8String]);
    NSLog(@"result %d", result);
    if (result == 0) {
        [self loadData];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"downladed_data"];
    
}

-(void)loadData {
    NSString *filepath = [NSString stringWithFormat:@"%@/Output.txt",self.docpath];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    self.data = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"items = %lu", (unsigned long)[self.data count]);
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.data.count >10) {
        return  10;
    }else {
        return  self.data.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* aTitle = self.data[indexPath.row];
    MovieTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCellId"];
    cell.label1.text = aTitle;
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83.5;
}
@end

