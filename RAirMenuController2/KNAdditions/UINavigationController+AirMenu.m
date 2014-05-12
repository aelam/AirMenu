//
//  UINavigationController+AirMenu.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "UINavigationController+AirMenu.h"
#import "UIViewController+AirMenu.h"

@implementation UINavigationController (AirMenu)

- (NSString *)menuTitle {
    NSString *menuTitle = nil;
    if([self.topViewController respondsToSelector:@selector(menuTitle)]) {
        menuTitle = [self.topViewController menuTitle];
    }
    return menuTitle;
}

- (UIImage *)menuImage {
    UIImage *menuImage = nil;
    if([self.topViewController respondsToSelector:@selector(menuImage)]) {
        menuImage = [self.topViewController menuImage];
    }
    return menuImage;
}

- (UIImage *)selectedMenuImage {
    UIImage *selectedMenuImage = nil;
    if([self.topViewController respondsToSelector:@selector(selectedMenuImage)]) {
        selectedMenuImage = [self.topViewController selectedMenuImage];
    }
    return selectedMenuImage;
}

@end
