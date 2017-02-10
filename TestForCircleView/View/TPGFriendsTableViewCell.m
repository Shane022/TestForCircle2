//
//  TPGFriendsTableViewCell.m
//  TestForMyCircle
//
//  Created by dvt04 on 17/2/5.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "TPGFriendsTableViewCell.h"

@implementation TPGFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnFollow.layer.masksToBounds = YES;
    self.btnFollow.layer.cornerRadius = 4;
}

- (void)reloadContactInfo:(TPGContactInfo *)contactInfo
{
    [self layoutIfNeeded];
    self.portraitImageView.image = [UIImage imageNamed:contactInfo.potraitUrl];
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.layer.cornerRadius = self.portraitImageView.frame.size.width/2;

    self.nickNameLabel.text = @"测试昵称";
    self.contactNameLabel.text = [NSString stringWithFormat:@"手机好友:%@ %@", contactInfo.contactGivenName, contactInfo.contactFamilyName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
