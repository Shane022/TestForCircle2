//
//  TPGFansViewController.m
//  TestForCircleView
//
//  Created by dvt04 on 17/2/7.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGFansViewController.h"
#import "TPGFriendsTableViewCell.h"

@interface TPGFansViewController ()

@end

@implementation TPGFansViewController
{
    NSArray *_arrDataSource;
}

- (instancetype)initWithDataSource:(NSArray *)arrDataSource
{
    self = [super init];
    if (self) {
        _arrDataSource = arrDataSource;
        [self.tableView registerNib:[UINib nibWithNibName:@"TPGFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
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
    TPGFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    if (cell == nil) {
        cell = [[TPGFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendsCell"];
    }
    [cell reloadContactInfo:[_arrDataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
