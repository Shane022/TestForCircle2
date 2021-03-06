//
//  TPGCircleViewController.m
//  TestForCircleView
//
//  Created by dvt04 on 17/2/7.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGCircleViewController.h"
#import "TPGTrendViewController.h"
#import "TPGFollowsViewController.h"
#import "TPGFansViewController.h"
#import "BaseTableViewController.h"
#import "TPGPortraitHeaderView.h"
#import "TPGTreandInfo.h"
#import "TPGContactInfo.h"
#import "TSCatagoryScrollView.h"

#define HEADER_VIEW_HEIGHT 181
#define CATEGORY_HEIGHT 44
#define USERINFO_HEIGHT 137
#define USE_TSCATEGORY_VIEW   // 选择栏使用TSCategoryView

@interface TPGCircleViewController ()<TableViewScrollingProtocol, TSCategoryScrollViewDelegate>

//@property (nonatomic, strong) TPGPortraitHeaderView *headerView;
@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, strong) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量

@property (nonatomic, strong) UIView *baseView; // 顶部视图
@property (nonatomic, strong) TSCatagoryScrollView *categoryView;

@end

@implementation TPGCircleViewController
{
    NSMutableArray *_arrContentViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _titleList = @[@"动态", @"关注", @"粉丝"];
    
    [self addChildViewController];
    [self addHeaderView];
}

- (void)addChildViewController
{
    // use test Data
    // 动态
    NSMutableArray *arrTrendInfo = [NSMutableArray arrayWithCapacity:0];
    NSArray *arrTime = @[@"02-05 15:00",
                         @"02-01 20:15",
                         @"02-01 17:30",
                         @"01-25 16:00",
                         @"01-24 17:30",
                         @"01-01 00:00",
                         @"12-25 20:00",
                         @"12-21 20:00"];
    NSArray *arrContent = @[@"为你介绍各大球队，关于他们的辉煌历史。并深入到每一个球迷，他们是如何以自己的方式去支持球队。观看比赛时，他们又有着怎样的心路历程。感受属于足球的独特魅力。",
                            @"赞了该视频。虽然是外传电影但它如此优秀，可以和《帝国反击战》相提并论",
                            @"我们的语言和我们的文化一样混乱",
                            @"踩了该视频",
                            @"节目很精彩",
                            @"影片非常不错",
                            @"节目很差",
                            @"影片非常糟糕"];
    NSArray *arrProgramTitle = @[@"久保与二弦琴",
                                 @"魔兽",
                                 @"美食总动员",
                                 @"超能陆战队",
                                 @"刺客信条",
                                 @"Singing",
                                 @"猩球崛起",
                                 @"加勒比海盗"];
    for (int i = 0; i < 8; i ++) {
        TPGTreandInfo *trendInfo = [[TPGTreandInfo alloc] init];
        trendInfo.userName = @"Omni Media Cloud";
        trendInfo.programDescription = @"波普先生是一个极富工作热情的高效率商人，在公司里备受重用，但却常常因此牺牲了与家人共处的时光。这个冬天，当他正在全力以赴地争取一位伤脑筋的合伙人时，前期阿曼达也准备开始自己的下一段恋情。然而这一切随着一个快递箱子的到来而发生了意想不到的逆转-波普先生从已故的父亲那里继承到了最不寻常的财产；一只活企鹅，就在他束手无策的时候，竟然又收到了另外五只活企鹅";
        trendInfo.programTitle = [arrProgramTitle objectAtIndex:i];
        trendInfo.time = [arrTime objectAtIndex:i];
        trendInfo.content = [arrContent objectAtIndex:i];
        [arrTrendInfo addObject:trendInfo];
    }
    // 关注
    NSMutableArray *arrFollow = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        TPGContactInfo *contactInfo = [[TPGContactInfo alloc] init];
        contactInfo.contactGivenName = [NSString stringWithFormat:@"关注%d",i];
        contactInfo.contactFamilyName = [NSString stringWithFormat:@"关注%d",i];
        contactInfo.potraitUrl = @"1";
        [arrFollow addObject:contactInfo];
    }
    // 粉丝
    NSMutableArray *arrFans = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 20; i++) {
        TPGContactInfo *contactInfo = [[TPGContactInfo alloc] init];
        contactInfo.contactGivenName = [NSString stringWithFormat:@"粉丝%d",i];
        contactInfo.contactFamilyName = [NSString stringWithFormat:@"粉丝%d",i];
        contactInfo.potraitUrl = @"3";
        [arrFans addObject:contactInfo];
    }
    ///
    
    TPGTrendViewController *trendViewController = [[TPGTrendViewController alloc]
                                                   initWithDataSource:arrTrendInfo];
    trendViewController.delegate = self;
    TPGFollowsViewController *followsViewController = [[TPGFollowsViewController alloc]
                                                       initWithDataSource:arrFollow];
    followsViewController.delegate = self;
    TPGFansViewController *fansViewController = [[TPGFansViewController alloc]
                                                 initWithDataSource:arrFans];
    fansViewController.delegate = self;
    
    [self addChildViewController:trendViewController];
    [self addChildViewController:followsViewController];
    [self addChildViewController:fansViewController];
    
    _arrContentViews = [NSMutableArray arrayWithCapacity:0];
    [_arrContentViews addObject:trendViewController.view];
    [_arrContentViews addObject:followsViewController.view];
    [_arrContentViews addObject:fansViewController.view];
}

- (void)addHeaderView
{
    
    // headerView
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_VIEW_HEIGHT)];
    _baseView.backgroundColor = [UIColor whiteColor];
#ifdef USE_TSCATEGORY_VIEW
#else
    [self.view addSubview:_baseView];
#endif
    
    TPGPortraitHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"TPGPortraitHeaderView" owner:self options:nil]objectAtIndex:0];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, USERINFO_HEIGHT);
    [headerView reloadUserInfo:nil];
    [_baseView addSubview:headerView];

    // segementControl
    NSArray *arrTitles = @[@"动态", @"关注", @"粉丝"];
    _categoryView = [TSCatagoryScrollView scrollWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), self.view.frame.size.width, self.view.frame.size.height) withViews:_arrContentViews withButtonNames:arrTitles];
    _categoryView.ts_selectButton = 0;
    _categoryView.delegateCategoryView = self;
    _showingVC = self.childViewControllers[0];
    // 重置frame
    CGRect scrollUpRect = _categoryView.scrollUpView.frame;
    scrollUpRect.origin.y = CGRectGetMaxY(headerView.frame);
    _categoryView.scrollUpView.frame = scrollUpRect;
    [_baseView addSubview:_categoryView.scrollUpView];
    
    CGRect scrollDownRect = _categoryView.scrollDownView.frame;
    scrollDownRect.origin.y = 0;
    scrollDownRect.size.height = self.view.frame.size.height - 64;
    _categoryView.scrollDownView.frame = scrollDownRect;
    _categoryView.scrollDownView.scrollEnabled = NO;
    [self.view addSubview:_categoryView.scrollDownView];
    
    [_categoryView.scrollDownView.subviews[0] addSubview:_baseView];

}

- (void)didSelectCategory:(id)sender
{
    [_showingVC.view removeFromSuperview];
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 1000;
    BaseTableViewController *newVC = [self.childViewControllers objectAtIndex:index];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = self.view.bounds;
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    if (offsetY <= headerImgHeight - topBarHeight) {
        [newVC.view addSubview:_baseView];
        CGRect rect = _baseView.frame;
        rect.origin.y = 0;
        self.baseView.frame = rect;
    } else {
        [self.view insertSubview:_baseView belowSubview:self.view];
        CGRect rect = self.baseView.frame;
        rect.origin.y = - headerImgHeight;
        self.baseView.frame = rect;
    }

    _showingVC = newVC;
}

#pragma mark - <TableViewScrollingProtocol>
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY
{
    if (offsetY > headerImgHeight) {
        if (![_baseView.superview isEqual:self.view]) {
            [self.view insertSubview:_baseView belowSubview:self.navigationController.view];
//            [tableView addSubview:_baseView];
        }
        CGRect rect = self.baseView.frame;
        rect.origin.y = - headerImgHeight;
        self.baseView.frame = rect;
    } else {
        if (![_baseView.superview isEqual:tableView]) {
//            for (UIView *view in tableView.subviews) {
//                [tableView addSubview:_baseView];
//            }
            [tableView addSubview:_baseView];

        }
        CGRect rect = self.baseView.frame;
        rect.origin.y = 0;
        self.baseView.frame = rect;
        
    }
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY
{
    _baseView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight) {
                _offsetYDict[key] = @(headerImgHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY
{
    _baseView.userInteractionEnabled = NO;
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY
{
    _baseView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight) {
                _offsetYDict[key] = @(headerImgHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY
{
    _baseView.userInteractionEnabled = NO;
}

#pragma mark - <TSCategoryScrollViewDelegate>
- (void)reloadNewViewDataWithIndex:(NSInteger)scrollViewIndex
{
    BaseTableViewController *newVC = [self.childViewControllers objectAtIndex:scrollViewIndex];
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    if (offsetY <= headerImgHeight) {
        [_categoryView.scrollDownView.subviews[scrollViewIndex] addSubview:_baseView];
        
        CGRect rect = self.baseView.frame;
        rect.origin.y = 0;
        self.baseView.frame = rect;
    }  else {
        [self.view insertSubview:_baseView belowSubview:self.navigationController.view];
        CGRect rect = self.baseView.frame;
        rect.origin.y = - headerImgHeight;
        self.baseView.frame = rect;
    }
    _showingVC = newVC;
}

#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
