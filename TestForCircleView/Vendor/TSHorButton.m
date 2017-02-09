//
//  TSHorButton.m
//  UVideo-V3.2
//
//  Created by dvt04 on 14-4-10.
//  Copyright (c) 2014年 maBiao. All rights reserved.
//

#import "TSHorButton.h"

@implementation TSHorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
#if CCBN_MODULE
    newFrame.origin.y = self.imageView.frame.size.height + 20;
#else
    newFrame.origin.y = self.imageView.frame.size.height + 2;
#endif
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)adjustForReorderButton
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint center = self.imageView.center;
        center.x = self.frame.size.width/2;
        center.y = self.imageView.frame.size.height/2 + 3;
        self.imageView.center = center;
        
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.imageView.frame.size.height + 4;
        newFrame.size.width = self.frame.size.width;
        
        self.titleLabel.frame = newFrame;
    });
}

@end
