//
//  TPGPortraitHeaderView.h
//  TestForMyCircle
//
//  Created by dvt04 on 17/2/5.
//  Copyright © 2017年 suma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPGPortraitHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnModify;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneFriends;

- (void)reloadUserInfo:(id)userInfo;

@end
