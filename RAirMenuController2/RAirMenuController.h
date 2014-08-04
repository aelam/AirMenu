//
//  RAirMenuController2.h
//  RAirMenuController2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAirMenuView.h"

@interface RAirMenuController : UIViewController

@property (nonatomic, strong)IBOutlet RAirMenuView *menuView;

@property(nonatomic,copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

@property(nonatomic,assign) UIViewController *selectedViewController;
@property(nonatomic,assign) NSUInteger selectedIndex;

@property (nonatomic,strong) IBOutlet UIView *topView;
@property (nonatomic,strong) IBOutlet UIImageView *backgroundView;
@property (nonatomic, assign) CGFloat menuRowHeight;

- (IBAction)openMenu:(BOOL)animation;
- (IBAction)closeMenu:(BOOL)animation;

@end
