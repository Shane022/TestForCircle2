//
//  TPGFollowsViewController.m
//  TestForCircleView
//
//  Created by dvt04 on 17/2/7.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGFollowsViewController.h"
#import "TPGFriendsTableViewCell.h"

@interface TPGFollowsViewController ()

@end

@implementation TPGFollowsViewController
{
    NSArray *_arrDataSource;
}

- (instancetype)initWithDataSource:(NSArray *)arrDataSource
{
    self = [super init];
    if (self) {
        _arrDataSource = arrDataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPGFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
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
    return 75;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
