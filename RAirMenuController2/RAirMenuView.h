//
//  RAirMenuView.h
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAirMenuView;
@class RMenuCell;
@class RMenuItem;

@protocol RAirMenuViewDelegate <NSObject>

- (void)menuView:(RAirMenuView *)menu didSelectItemAtIndex:(NSInteger)index;

@end

@interface RAirMenuView : UIView

@property(nonatomic,assign) id<RAirMenuViewDelegate> delegate;     // weak reference. default is nil
@property(nonatomic,retain) NSArray          *items;
@property(nonatomic,assign) RMenuItem        *selectedItem; // will show feedback based on mode. default is nil
@property(nonatomic,assign) CGSize menuItemSize;
@property(nonatomic,assign) CGFloat menuItemGap;
@property(nonatomic,strong) UIColor *menuTextColor;
@property(nonatomic,strong) UIColor *selectedMenuTextColor;

- (void)setTranslationX:(CGFloat)x animation:(BOOL)animation;


@end

