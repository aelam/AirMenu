//
//  RMenuItem.h
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RMenuItem : UIControl

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,copy) NSString *badgeValue;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIView *contentView;

@end
