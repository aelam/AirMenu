//
//  UIView+AnchorPoint.m
//  RAirViewControllerDemo
//
//  Created by Ryan Wang on 14-5-3.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "UIView+AnchorPoint.h"

@implementation UIView (AnchorPoint)

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    UIView *view = self;
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;

}

@end
