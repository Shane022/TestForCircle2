//
//  TPGTrendTableViewCell.h
//  TestForMyCircle
//
//  Created by dvt04 on 17/2/5.
//  Copyright © 2017年 suma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPGTreandInfo.h"

@interface TPGTrendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *potraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *programBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *programTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *programContentLabel;

- (void)reloadTrendInfo:(TPGTreandInfo *)trendInfo;

@end
