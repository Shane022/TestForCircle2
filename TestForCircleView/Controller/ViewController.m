//
//  ViewController.m
//  TestForCircleView
//
//  Created by dvt04 on 17/2/7.
//  Copyright © 2017年 suma. All rights reserved.
//

#import "ViewController.h"
#import "TPGCircleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)onHitBtnEnterCircleView:(id)sender {
    TPGCircleViewController *circleViewController = [[TPGCircleViewController alloc] init];
    [self.navigationController pushViewController:circleViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
