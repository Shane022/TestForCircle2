//
//  TPGPortraitHeaderView.m
//  TestForMyCircle
//
//  Created by dvt04 on 17/2/5.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGPortraitHeaderView.h"

@implementation TPGPortraitHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor blackColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = rect;
}

- (void)reloadUserInfo:(id)userInfo
{
    UIImage *image = [UIImage imageNamed:@"3"];
    self.portraitImageView.image = image;
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.layer.cornerRadius = 82/2;

    self.btnPhoneFriends.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnPhoneFriends.layer.borderWidth = 1;
    self.btnPhoneFriends.layer.masksToBounds = YES;
    self.btnPhoneFriends.layer.cornerRadius = 4;
}

@end
