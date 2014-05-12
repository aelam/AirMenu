//
//  RAirMenuView.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RAirMenuView.h"
#import "RMenuItem.h"
#import "UIViewAdditions.h"
#import "UIView+AnchorPoint.h"

@interface RAirMenuView()

@end

@implementation RAirMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize {
//    self.menuCells = [NSMutableArray array];
    _menuItemSize = CGSizeMake(240, 50);
    _menuItemGap = 10;
    
    _menuTextColor = [UIColor greenColor];
    _selectedMenuTextColor = [UIColor yellowColor];
}

- (void)handleRevealGesture:(UIPanGestureRecognizer *)recognizer
{
}

- (void)setItems:(NSArray *)items {
    if(_items != items) {
        [self clearItems];
        _items = [NSMutableArray arrayWithArray:items];
        [self reloadItems];
    }
}

- (void)clearItems {
    for(RMenuItem *item in _items) {
        [item removeFromSuperview];
    }
}

- (void)setSelectedItem:(RMenuItem *)selectedItem {
    _selectedItem = selectedItem;
    for(int i = 0; i < [_items count]; i++) {
        RMenuItem *item = [_items objectAtIndex:i];
        if (_selectedItem == item) {
            [item setSelected:YES];
        } else {
            [item setSelected:NO];
        }
    }
}

- (void)reloadItems {
    if ([self.items count] == 0) {
        return;
    }
    
    CGFloat menuItemsHeight = _menuItemSize.height * [self.items count] + _menuItemGap * ([self.items count] - 1);
    CGFloat cellTop = 0.5 * (self.bounds.size.height - menuItemsHeight);
    for(RMenuItem *cell in _items) {
        cell.userInteractionEnabled = YES;
        cell.top = cellTop;
        cell.width = _menuItemSize.width;
        cellTop += _menuItemGap + _menuItemSize.height;
        [cell setAnchorPoint:CGPointMake(-0.5, 0.5)];
        [cell addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell];

    }

}

- (void)setTranslationX:(CGFloat)_translationX animation:(BOOL)animation{
    float factor = 1;
    float persentage = 1.0 - fabsf( - _translationX) / 320.f;
    float angle = (persentage) * M_PI * 0.9;
    NSLog(@"persentage = %f angle = %f",persentage, angle);
    if (animation) {
        [UIView beginAnimations:@"CellAnimation" context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    
    CGFloat offsetWidth = 20;
    CGFloat offset = offsetWidth * self.items.count;
    for(RMenuItem *cell in self.items) {
        angle *= factor;
        CATransform3D tranform = CATransform3DIdentity;
        tranform.m34 = 1.f / 1400.f;
        tranform =  CATransform3DRotate(tranform ,angle, 0, 1, 0);
        cell.layer.transform = tranform;
        factor *= 0.8;
        offset -= offsetWidth;
    }
    if (animation) {
        [UIView commitAnimations];
    }
}

- (void)tabSelected:(id)sender {
	[self.delegate menuView:self didSelectItemAtIndex:[self.items indexOfObject:sender]];
}



@end
