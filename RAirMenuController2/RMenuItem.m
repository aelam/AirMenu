
//
//  RMenuItem.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RMenuItem.h"
#import "UIViewAdditions.h"

@interface RMenuItem ()

@property(nonatomic,strong) UILabel *badgeValueLabel;
@property(nonatomic,strong) UIView *contentView;
@end

@implementation RMenuItem

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIView alloc] initWithFrame:frame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.contentView.userInteractionEnabled = NO;
        [self addSubview:self.contentView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 0, 100, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.centerY = CGRectGetHeight(self.bounds) * 0.5;

        self.badgeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.contentView addSubview:self.badgeValueLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 24, 24)];
        [self.contentView addSubview:self.imageView];
        self.imageView.centerY = CGRectGetHeight(self.bounds) * 0.5;

//        [self.contentView setBackgroundColor:[UIColor colorWithRed:0.01*(rand()%100) green:0.01*(rand()%100) blue:0.01*(rand()%100) alpha:1]];

    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    self.badgeValueLabel.text = _badgeValue;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.highlighted = selected;
    if (selected) {
        self.titleLabel.textColor = [UIColor redColor];
    } else {
        self.titleLabel.textColor = [UIColor grayColor];
    }
}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    
//}


@end
