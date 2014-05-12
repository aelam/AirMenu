//
//  RViewController.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RViewController.h"
#import "RDemoViewController.h"

@interface RViewController ()

@end

@implementation RViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    RDemoViewController *demoController = [[RDemoViewController alloc] init];
    demoController.title = @"首页";
    demoController.menuTitle = @"首页";
    demoController.menuImage = [UIImage imageNamed:@"btn-menu-home-n"];
    demoController.selectedMenuImage = [UIImage imageNamed:@"btn-menu-home-s"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:demoController];
    
    RDemoViewController *demoController2 = [[RDemoViewController alloc] init];
    demoController2.title = @"品牌";
    demoController2.menuTitle = @"品牌";
    demoController2.menuImage = [UIImage imageNamed:@"btn-menu-more-n"];
    demoController2.selectedMenuImage = [UIImage imageNamed:@"btn-menu-more-s"];
    UINavigationController *n2 = [[UINavigationController alloc] initWithRootViewController:demoController2];

    RDemoViewController *demoController3 = [[RDemoViewController alloc] init];
    demoController3.title = @"我的";
    demoController3.menuTitle = @"我的";
    demoController3.menuImage = [UIImage imageNamed:@"btn-menu-profiles-n"];
    demoController3.selectedMenuImage = [UIImage imageNamed:@"btn-menu-profiles-s"];
    
    self.viewControllers = @[n,n2,demoController3];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
