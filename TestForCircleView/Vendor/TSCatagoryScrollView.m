//
//  TSCatagoryScrollView.m
//  UVideo-V5-iPhone
//
//  Created by suma_i_Interactive on 15/4/22.
//  Copyright (c) 2015年 sumavision. All rights reserved.
//

#import "TSCatagoryScrollView.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import <objc/runtime.h>
#import "UIFont+TSUIFont.h"

static CGFloat DefaultSelectedLineHeight = 2.f;

@interface TSCatagoryScrollView ()<UIScrollViewDelegate>
{
    NSInteger _x;
    CGFloat _initX_viewDownScroll;
    CGFloat _gap;
    
    CGFloat _screenWidth;
    CGFloat scrollUpHeight;
    CGFloat btnLeftRightMargin;
}
@end

@implementation TSCatagoryScrollView

-(instancetype)initWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names
{
    self =[super initWithFrame:frame];
    if (self) {
        self.ts_views               =   views;
        self.ts_buttonNames         =   names;
        
        [self initData];
        [self addScrollUp];
        [self addScrollDown];
        
#ifdef SWITCH_LOCATION_MASTER_50
        self.backgroundColor = [UIColor colorWithHexString:@"ECEBF2"];
#else
        self.backgroundColor = [UIColor whiteColor];
#endif
        self.ts_selectButton = 1;

    }
    return self;
}
+(instancetype)scrollWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names
{
    return [[self alloc]initWithFrame:frame withViews:views withButtonNames:names];
}

- (void)enableReorderButtonWithAction:(TSReorderButtonAction)action
{
    CGFloat buttonBackViewWidth = 40;
    CGRect frame = self.scrollUpView.frame;
    frame.size.width = frame.size.width - buttonBackViewWidth;
    self.scrollUpView.frame = frame;
    
    CGFloat currentMaxX = CGRectGetMaxX(self.scrollUpView.frame);
    
    UIView *reorderBackView = [[UIView alloc] initWithFrame:CGRectMake(currentMaxX, 0, self.frame.size.width - currentMaxX, frame.size.height)];
    
    [reorderBackView setBackgroundColor:_scrollUpView.backgroundColor];
    [self addSubview:reorderBackView];
    
    UIView *reorderBackViewLine = [[UIView alloc] initWithFrame:CGRectMake(-frame.size.width,  CGRectGetHeight(reorderBackView.frame) - 0.5, self.frame.size.width, 0.5)];
    [reorderBackViewLine setBackgroundColor:_line.backgroundColor];
    
    [reorderBackView addSubview:reorderBackViewLine];
    
    [reorderBackView addSubview:self.reorderButton];
    self.reorderButton.frame = reorderBackView.bounds;
    
    self.reorderButtonAction = action;
    
    CGFloat insetY = 6;
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, insetY, 0.5, reorderBackView.frame.size.height - 2 * insetY)];
    [verticalLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [reorderBackView addSubview:verticalLine];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, insetY + 0, 1, reorderBackView.frame.size.height - (insetY + 0) * 2)];
    reorderBackView.layer.masksToBounds = NO;
    reorderBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    reorderBackView.layer.shadowOffset = CGSizeMake(-2.0f, 0);
    reorderBackView.layer.shadowOpacity = 1.0f;
    reorderBackView.layer.shadowPath = shadowPath.CGPath;
}

- (void)scrollToButtonWithIndex:(NSInteger)index
{
    if (self.buttons.count > index) {
        UIButton *button = [self.buttons objectAtIndex:index];
        CGRect frame = CGRectMake(button.frame.origin.x - 120, 0, self.scrollUpView.frame.size.width, self.scrollUpView.frame.size.height);
        [self.scrollUpView scrollRectToVisible:frame animated:YES];
    }
}

- (TSHorButton *)reorderButton
{
    if (_reorderButton == nil) {
        _reorderButton = [[TSHorButton alloc] init];
        [_reorderButton adjustForReorderButton];
        [_reorderButton setTitle:@"菜单" forState:UIControlStateNormal];
//        [_reorderButton setImage:[UIImage TSimageNamed:@"common_menu_column_button"] forState:UIControlStateNormal];
//        [_reorderButton setTitleColor:[UIColor generalLightTextColor] forState:UIControlStateNormal];
//        _reorderButton.titleLabel.font = [UIFont generalTinyFont];
        
        [_reorderButton addTarget:self action:@selector(onHitReorderButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reorderButton;
}


- (void)onHitReorderButton:(UIButton *)sender
{
    if (self.reorderButtonAction) {
        self.reorderButtonAction(self);
    }
}

- (void)initData {
    if ([[UIScreen mainScreen] currentMode].size.width > 640) {
        _gap = 25;
    }else{
        _gap = 16;
    }
    //test
    _gap = 0;
#if 1
    scrollUpHeight = 44;
#else
    scrollUpHeight = 35;
#endif
#ifdef UVIDEO_MAIN_VERSION  //主线版本有全部分类
    btnLeftRightMargin = [[UIScreen mainScreen] bounds].size.width/26;
#else
    btnLeftRightMargin = 32;
#endif
    _screenWidth = self.frame.size.width;
    self.buttons = [[NSMutableArray alloc]initWithCapacity:0];
}

-(void)setTs_selectButton:(NSInteger)ts_selectButton{
    
    if (_ts_selectButton != ts_selectButton) {
        _ts_selectButton = ts_selectButton;
        UIButton *btn;
        for (UIButton *temp in self.buttons) {
            temp.selected = NO;
            if (temp.tag == _ts_selectButton) {
                btn = temp;
                temp.selected = YES;
            }
        }
        CGRect frame = self.viewDownScroll.frame;
        frame.size.width = btn.frame.size.width;
        self.viewDownScroll.frame = frame;
        self.viewDownScroll.transform = CGAffineTransformMakeTranslation(btn.frame.origin.x - _initX_viewDownScroll, 0);
        
        self.scrollDownView.delegate = nil;
        self.scrollDownView.contentOffset = CGPointMake(btn.tag*_screenWidth, 0);
        
        self.scrollDownView.delegate = self;
        
        NSInteger xAfter = self.scrollDownView.contentOffset.x/_screenWidth;
        UIButton *button = self.buttons[xAfter];
        
        if (xAfter < self.ts_buttonNames.count && _x != xAfter) {
            if (_x < xAfter) {
                //scrollview页面往左滑动
                if (CGRectGetMaxX(button.frame) > self.scrollUpView.frame.size.width) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.scrollUpView.contentOffset = CGPointMake(CGRectGetMaxX(button.frame) + _gap - self.scrollUpView.frame.size.width, 0);
                    }];
                }
            }else if (_x>xAfter) {
                //scrollView页面往右滑动
                if (CGRectGetMaxX(button.frame) > self.scrollUpView.frame.size.width) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.scrollUpView.contentOffset = CGPointMake(CGRectGetMaxX(button.frame) + _gap - self.scrollUpView.frame.size.width, 0);
                    }];
                }else{
                    self.scrollUpView.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    }
}
- (void)setTs_sliderHeight:(CGFloat)ts_sliderHeight{
    if (_ts_sliderHeight != ts_sliderHeight) {
        _ts_sliderHeight = ts_sliderHeight;
        CGRect frame = self.viewDownScroll.frame;
        frame.size.height = _ts_sliderHeight;
        [self.viewDownScroll setFrame:frame];
    }
}

- (void)setTs_buttonColorSelected:(UIColor *)ts_buttonColorSelected{
    if (_ts_buttonColorSelected != ts_buttonColorSelected) {
        for (UIButton *temp in self.buttons) {
            [temp setTitleColor:ts_buttonColorSelected forState:UIControlStateSelected];
        }
    }
}

- (void)setTs_buttonColorNormal:(UIColor *)ts_buttonColorNormal{
    if (_ts_buttonColorNormal != ts_buttonColorNormal) {
        for (UIButton *temp in self.buttons) {
            [temp setTitleColor:ts_buttonColorNormal forState:UIControlStateNormal];
        }
    }
}

-(void)addScrollUp{
    
    UIView *firstSubView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:firstSubView];
    
    self.scrollUpView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, scrollUpHeight)];
    self.scrollUpView.backgroundColor = [UIColor clearColor];
    self.scrollUpView.showsHorizontalScrollIndicator = NO;
    self.scrollUpView.showsVerticalScrollIndicator = NO;
    self.scrollUpView.scrollEnabled = YES;
    self.scrollUpView.delegate = self;
    self.scrollUpView.bounces = YES;
    self.scrollUpView.opaque = NO;
    self.scrollUpView.scrollsToTop = NO;

    [firstSubView addSubview:self.scrollUpView];

    CGFloat _x_offset = 12;
#if 1
    CGFloat btnWidth = 60;
    _x_offset = (self.frame.size.width - btnWidth*3)/2;
#endif
    for (int i = 0; i < self.ts_buttonNames.count; i++) {
        NSString *string = self.ts_buttonNames[i];
        UIFont *font = [UIFont systemFontOfSize:15.f];
        CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        
        if (self.ts_buttonNames.count < 5) {
            btnLeftRightMargin = [[UIScreen mainScreen] bounds].size.width/13;
        }
        CGFloat width = ceilf(size.width+btnLeftRightMargin);
        UIButton *temp = [[UIButton alloc]initWithFrame:CGRectMake(_x_offset, 0, width, scrollUpHeight)];
        _x_offset += width + _gap;
        temp.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [temp setTitle:self.ts_buttonNames[i] forState:UIControlStateNormal];
        [temp setTitle:self.ts_buttonNames[i] forState:UIControlStateSelected];
        [temp setTitleColor:self.ts_buttonColorNormal?self.ts_buttonColorNormal:[UIColor blackColor] forState:UIControlStateNormal];
        [temp setTitleColor:self.ts_buttonColorSelected?self.ts_buttonColorSelected:[UIColor orangeColor] forState:UIControlStateSelected];
        [temp addTarget:self action:@selector(changed:) forControlEvents:UIControlEventTouchUpInside];
        temp.tag = i;
        if (i == (self.ts_selectButton?self.ts_selectButton:1)) {
            temp.selected = YES;
        }
        [self.scrollUpView addSubview:temp];
        [self.buttons addObject:temp];
    }
    
    self.scrollUpView.contentSize = CGSizeMake(_x_offset, 0);
    self.scrollUpView.contentOffset = CGPointZero;
    
#ifdef SWITCH_LOCATION_MASTER_50
    
#else
    CGFloat lineWidth = self.scrollUpView.contentSize.width > self.scrollUpView.frame.size.width ? self.scrollUpView.contentSize.width : self.scrollUpView.frame.size.width;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.scrollUpView.frame)-.5f, lineWidth, .5f)];
    [_line setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollUpView addSubview:_line];

#endif
    
    if (self.buttons.count) {
        UIButton *button = self.buttons[0];

        if ([self.buttons count] > (self.ts_selectButton?self.ts_selectButton:1)) {
            button = self.buttons[self.ts_selectButton?self.ts_selectButton:1];
        }
        
        _initX_viewDownScroll = button.frame.origin.x;
        
        self.viewDownScroll = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x,CGRectGetMaxY(button.frame)-(self.ts_sliderHeight?self.ts_sliderHeight:DefaultSelectedLineHeight), button.frame.size.width, self.ts_sliderHeight?self.ts_sliderHeight:DefaultSelectedLineHeight)];
        self.viewDownScroll.backgroundColor = [UIColor orangeColor];
        [self.scrollUpView addSubview:self.viewDownScroll];
    }
}

- (void)addScrollDown{
    
    if (!self.ts_views) {
        return;
    }
    
    self.scrollDownView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollUpHeight, _screenWidth, self.frame.size.height - scrollUpHeight)];
    self.scrollDownView.contentSize = CGSizeMake(_screenWidth*self.ts_buttonNames.count, 0);
    self.scrollDownView.showsHorizontalScrollIndicator = NO;
    self.scrollDownView.showsVerticalScrollIndicator = NO;
    self.scrollDownView.delegate = self;
    self.scrollDownView.pagingEnabled = YES;
    self.scrollDownView.bounces = YES;
    self.scrollDownView.scrollsToTop = NO;
    
    for (int i = 0; i < self.ts_buttonNames.count; i++) {
        if (i+1 > self.ts_views.count) {
            break;
        }
        
        if ([self.ts_views[i] isKindOfClass:[UIScrollView class]]) {
            UIScrollView *temp = (UIScrollView *)self.ts_views[i];
//            [self addHeader:temp];
            [self addFooter:temp];
            CGRect rect = CGRectMake(_screenWidth*i, 0, self.scrollDownView.frame.size.width, self.scrollDownView.frame.size.height);
            temp.frame = rect;
            [self.scrollDownView addSubview:temp];
        }else{
            UIView *temp = self.ts_views[i];
            CGRect rect = CGRectMake(_screenWidth*i, 0, self.scrollDownView.frame.size.width, self.scrollDownView.frame.size.height);
            temp.frame = rect;
            [self.scrollDownView addSubview:temp];
        }
    }
    self.scrollDownView.delegate = nil;
    self.scrollDownView.contentOffset = CGPointMake(_screenWidth*(self.ts_selectButton?self.ts_selectButton:1), 0);
    self.scrollDownView.delegate = self;
    [self addSubview:self.scrollDownView];
}
-(void)changed:(UIButton *)button{
    
    if (button.selected) {
        return;
    }
    
    for (UIButton *temp in self.buttons) {
        if (temp.selected && temp !=button) {
            temp.selected = NO;
        }
    }
    
    button.selected = YES;
    _ts_selectButton = button.tag;
    
    self.scrollDownView.delegate = nil;
    self.scrollDownView.contentOffset = CGPointMake(button.tag*_screenWidth, 0);
    
    CGRect frame = self.viewDownScroll.frame;
    frame.size.width = button.frame.size.width;
    self.viewDownScroll.frame = frame;
    
    self.viewDownScroll.transform = CGAffineTransformMakeTranslation(button.frame.origin.x - _initX_viewDownScroll, 0);
    
    self.scrollDownView.delegate = self;
    
    if ([self.delegateCategoryView respondsToSelector:@selector(reloadNewViewDataWithIndex:)]) {
        [self.delegateCategoryView reloadNewViewDataWithIndex:button.tag];
    }
}

#pragma mark  scrollDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"%s  &  _x is %i",__func__, (int)_x);
    
    if ([scrollView isEqual:self.scrollDownView]) {
        _x = scrollView.contentOffset.x/_screenWidth;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
#if 0
    if ([scrollView isEqual:self.scrollUpView]) {
        
//        NSLog(@"scrollViewDidScroll");

    }else if ([scrollView isEqual:self.scrollDownView]){
        if (scrollView.contentOffset.x < 0 ||scrollView.contentOffset.x > _screenWidth*(self.ts_buttonNames.count-1)) {
            return;
        }
        
        UIButton *button = self.buttons[_x];
        
        CGPoint point = self.scrollDownView.contentOffset;
        point.y = 0;
        self.scrollDownView.contentOffset = point;
        
        UIButton *buttonNext;
        CGFloat _x_position = _initX_viewDownScroll;
        
        if (_x *_screenWidth < scrollView.contentOffset.x) {
            //滑到右边的button
            if (_x+1 >= self.buttons.count) {
                _x = _x-1;
            }
            buttonNext = self.buttons[_x+1];
            _x_position = button.frame.origin.x + ((double)(scrollView.contentOffset.x -_x*_screenWidth)/_screenWidth)*(button.frame.size.width+_gap);
        }else if (_x*_screenWidth >scrollView.contentOffset.x) {
            if (_x == 0) {
                _x = 1;
            }
            buttonNext = self.buttons[_x-1];
            _x_position = button.frame.origin.x + ((double)(scrollView.contentOffset.x -_x*_screenWidth)/_screenWidth)*(buttonNext.frame.size.width+_gap);
        }else{
            return;
        }
        
        CGRect frame = self.viewDownScroll.frame;
        CGFloat widthBefore = frame.size.width;
        frame.size.width = widthBefore +(buttonNext.frame.size.width - widthBefore)*fabs(((double)(scrollView.contentOffset.x -_x*_screenWidth)/_screenWidth));
        self.viewDownScroll.frame = frame;
        
        self.viewDownScroll.transform = CGAffineTransformMakeTranslation(_x_position - _initX_viewDownScroll, 0);
    }
#endif
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"%s  &  _x is %i",__func__, (int)_x);

    if ([scrollView isEqual:self.scrollUpView]) {
        
//        NSLog(@"scrollViewDidEndDecelerating");
        
    }else if ([scrollView isEqual:self.scrollDownView]){
        if (scrollView.contentOffset.x < 0 ||scrollView.contentOffset.x > _screenWidth*self.ts_buttonNames.count) {
            return;
        }
        
        for (UIButton *temp in self.buttons) {
            
            [UIView animateWithDuration:0.2 animations:^{
                temp.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
            
            if (temp.selected) {
                temp.selected = NO;
            }
            
            NSInteger x1 = temp.tag;
            NSInteger x2 = scrollView.contentOffset.x/_screenWidth;
            
            //找到scrollView对应的button
            if (x1 == x2) {
                temp.selected = YES;
                //[UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = self.viewDownScroll.frame;
                    frame.size.width = temp.frame.size.width;
                    self.viewDownScroll.frame = frame;
                    self.viewDownScroll.transform = CGAffineTransformMakeTranslation(temp.frame.origin.x -_initX_viewDownScroll, 0);
                //}];
            }
        }
        
        NSInteger xAfter = scrollView.contentOffset.x/_screenWidth;
        UIButton *button = self.buttons[xAfter];
        
        //NSLog(@"xAfter is %i",(int)xAfter);
        
        if (xAfter < self.ts_buttonNames.count) {
            if (_x < xAfter) {
                //scrollview页面往左滑动
                if (CGRectGetMaxX(button.frame) > self.scrollUpView.frame.size.width) {
                    //[UIView animateWithDuration:0.2 animations:^{
                        self.scrollUpView.contentOffset = CGPointMake(CGRectGetMaxX(button.frame) + _gap - self.scrollUpView.frame.size.width, 0);
                    //}];
                }
            }else if (_x>=xAfter) {
                //scrollView页面往右滑动
                if (CGRectGetMaxX(button.frame) > self.scrollUpView.frame.size.width) {
                    //[UIView animateWithDuration:0.2 animations:^{
                        self.scrollUpView.contentOffset = CGPointMake(CGRectGetMaxX(button.frame) + _gap - self.scrollUpView.frame.size.width, 0);
                    //}];
                }else{
                    self.scrollUpView.contentOffset = CGPointMake(0, 0);
                }
            }
            
            if ([self.delegateCategoryView respondsToSelector:@selector(reloadNewViewDataWithIndex:)]) {
                [self.delegateCategoryView reloadNewViewDataWithIndex:xAfter];
            }
        }
    }
}
- (void)addHeader:(UIScrollView *)scrollView
{
    // 添加下拉刷新头部控件
    __weak typeof(scrollView) weakScrollView = scrollView;
    [scrollView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        if ([self.delegateCategoryView respondsToSelector:@selector(reloadHeaderDataWithIndex:)]) {
            [self.delegateCategoryView reloadHeaderDataWithIndex:weakScrollView.tag];
        }
    } dateKey:@"collection"];
}
- (void)addFooter:(UIScrollView *)scrollView
{
    // 添加上拉刷新尾部控件
    __weak typeof (scrollView) weakScrollView = scrollView;
    [scrollView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        if ([self.delegateCategoryView respondsToSelector:@selector(reloadFooterDataWithIndex:)]) {
            [self.delegateCategoryView reloadFooterDataWithIndex:weakScrollView.tag];
        }
    }];
}

- (void)dealloc
{
    NSLog(@"TSCatagoryScrollView dealloc");
}
@end
