//
//  TSCatagoryScrollView.h
//  UVideo-V5-iPhone
//
//  Created by suma_i_Interactive on 15/4/22.
//  Copyright (c) 2015年 sumavision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+MJRefresh.h"
#import "TSHorButton.h"

@class TSCatagoryScrollView;

typedef void(^TSReorderButtonAction)(TSCatagoryScrollView *categoryView);

@class TSCatagoryScrollView;
@protocol TSCategoryScrollViewDelegate <NSObject>

- (void)reloadHeaderDataWithIndex:(NSInteger)scrollViewIndex;
- (void)reloadFooterDataWithIndex:(NSInteger)scrollViewIndex;
- (void)reloadNewViewDataWithIndex:(NSInteger)scrollViewIndex;

@end

@interface TSCatagoryScrollView : UIScrollView

+(instancetype)scrollWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names;//类方法

- (void)enableReorderButtonWithAction:(TSReorderButtonAction)action;

- (void)scrollToButtonWithIndex:(NSInteger)index;

@property (nonatomic, strong) TSReorderButtonAction reorderButtonAction;

/**
 *     代理
 */
@property(nonatomic, weak)id<TSCategoryScrollViewDelegate>delegateCategoryView;

/**
 *     分类名称滑动
 */
@property(nonatomic,strong)UIScrollView *scrollUpView;
/**
 *     分类视图滑动
 */
@property(nonatomic,strong)UIScrollView *scrollDownView;
/**
 *     分类名称底下的滑动块
 */
@property(nonatomic,strong)UIView *viewDownScroll;

/**
 *     分类名称button，最多支持20个
 */
@property(nonatomic ,strong)NSMutableArray *buttons;

/**
 *     要展示在scollView中的view，一页一视图，可在new出来后直接放入数组
 */
@property (nonatomic ,strong) NSArray *ts_views;
/**
 *     头部控制条按钮的名称,存放在此数组中,NSString直接赋值
 */
@property (nonatomic ,copy) NSArray *ts_buttonNames;

/**
 *  顶部分类下面屏幕宽度的横线
 */
@property (nonatomic, strong) UIImageView *line;

#pragma mark - 各种可供自定义的属性
/**
 *     初始化后默认选中的按钮的位置,默认为1
 */
@property (nonatomic ,assign) NSInteger ts_selectButton;
/**
 *     头部控制条按钮在UIControlStateNormal状态下的文字颜色,默认为黑色
 */
@property (nonatomic ,strong) UIColor *ts_buttonColorNormal;
/**
 *     头部控制条按钮在UIControlStateSelected状态下的文字颜色,默认为黑色
 */
@property (nonatomic ,strong) UIColor *ts_buttonColorSelected;
/**
 *     头部控制条里的滑块的高度，默认为3
 */
@property (nonatomic ,assign) CGFloat ts_sliderHeight;

@property (nonatomic, strong) TSHorButton *reorderButton;

@end
