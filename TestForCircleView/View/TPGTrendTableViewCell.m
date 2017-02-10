//
//  TPGTrendTableViewCell.m
//  TestForMyCircle
//
//  Created by dvt04 on 17/2/5.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGTrendTableViewCell.h"

@implementation TPGTrendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = rect;
}

- (void)reloadTrendInfo:(TPGTreandInfo *)trendInfo
{
    // test
    [self layoutIfNeeded];
    self.potraitImageView.image = [UIImage imageNamed:@"1"];
    self.posterImageView.image = [UIImage imageNamed:@"2"];
    self.potraitImageView.layer.masksToBounds = YES;
    self.potraitImageView.layer.cornerRadius = self.potraitImageView.frame.size.width/2;
    
    self.nameLabel.text = trendInfo.userName;
    self.timeLabel.text = trendInfo.time;
    self.contentLabel.text = trendInfo.content;
    self.programTitleLabel.text = trendInfo.programTitle;
    self.programContentLabel.text = trendInfo.programDescription;
    [self.contentLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
