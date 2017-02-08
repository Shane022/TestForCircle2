//
//  TPGFriendsTableViewCell.h
//  TestForMyCircle
//
//  Created by dvt04 on 17/2/5.
//  Copyright © 2017年 suma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPGContactInfo.h"

@interface TPGFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

- (void)reloadContactInfo:(TPGContactInfo *)contactInfo;

@end
