//
//  RDemoViewController.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RDemoViewController.h"
#import "UIViewController+AirMenu.h"

@interface RDemoViewController ()

@end

@implementation RDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 300, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.title;
    [self.view addSubview:label];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self.title);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self.title);
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
