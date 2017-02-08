//
//  TPGTrendViewController.m
//  TestForCircleView
//
//  Created by dvt04 on 17/2/7.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGTrendViewController.h"
#import "TPGTrendTableViewCell.h"

#define ROW_HEIGHT 164

@interface TPGTrendViewController ()

@end

@implementation TPGTrendViewController
{
    NSArray *_arrDataSource;
}

- (instancetype)initWithDataSource:(NSArray *)arrDataSource
{
    self = [super init];
    if (self) {
        _arrDataSource = arrDataSource;
        [self.tableView registerNib:[UINib nibWithNibName:@"TPGTrendTableViewCell" bundle:nil] forCellReuseIdentifier:@"trendTableViewCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPGTrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trendTableViewCell"];
    if (cell == nil) {
        cell = [[TPGTrendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"trendTableViewCell"
                ];
    }
    [cell reloadTrendInfo:[_arrDataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TPGTrendViewController didSelectRow:%ld",(long)indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
