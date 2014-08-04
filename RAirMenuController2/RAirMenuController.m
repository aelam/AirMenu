//
//  RAirMenuController2.m
//  RAirMenuController2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RAirMenuController.h"
#import "UIView+AnchorPoint.h"
#import "UIViewAdditions.h"
#import "RMenuItem.h"
#import "UIViewController+AirMenu.h"

@interface RAirMenuController() <UIGestureRecognizerDelegate, RAirMenuViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readwrite) BOOL visible;

@end

@implementation RAirMenuController {
    CGFloat                     _menuWidth;
    UIButton                    *_rightCloseButton;
    BOOL                        _draggingHorizonal;
    BOOL                        _menuOpened;
    CGFloat                     _translationX;
    
    UIViewController            *_oldViewController;
    
    CGFloat                     _activeWidth;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initialize];
    }
    return self;
}


- (void)_initialize {
    _menuWidth = 320;
    _menuRowHeight = 50;
    _activeWidth = 280;
}

- (void)viewDidLoad {
    CGFloat _topHeight = 44;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        _topHeight = 64;
    }
    
    self.menuView = [[RAirMenuView alloc] initWithFrame:self.view.bounds];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
    _rightCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightCloseButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightCloseButton.frame = CGRectMake(self.view.bounds.size.width - 70, 0, 70, self.view.bounds.size.height);
    [self.view addSubview:_rightCloseButton];
    

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.allowsEdgeAntialiasing = YES;
    [self.view addSubview:self.contentView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -_topHeight, CGRectGetWidth(self.view.bounds), _topHeight)];
//    self.topView.backgroundColor = [UIColor red1];
    self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.topView];

    
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRevealGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
//    [self.selectedViewController viewDidAppear:animated];
	_visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
//    [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
//    [self.selectedViewController viewDidDisappear:animated];
	_visible = NO;
}

- (void)setBackgroundView:(UIImageView *)backgroundView {
    if(_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self.view addSubview:_backgroundView];
        [self.view insertSubview:_backgroundView atIndex:0];
        [self enableEffect:NO];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    if(_viewControllers != viewControllers) {
        _selectedIndex = 0;
        
        for(UIViewController *c in _viewControllers) {
            [c removeFromParentViewController];
        }
        
        _viewControllers = viewControllers;
        
//        for(UIViewController *c in _viewControllers) {
//            [self addChildViewController:c];
//        }
        
        [self loadMenuView];
        // default page
        [self setSelectedIndex:_selectedIndex];
    }
}

- (void)loadMenuView {
    NSMutableArray *items = [NSMutableArray array];
    for(UIViewController *viewController in _viewControllers) {
        RMenuItem *item = [[RMenuItem alloc] initWithFrame:CGRectMake(0, 0, _menuWidth, _menuRowHeight)];
        if ([viewController respondsToSelector:@selector(menuTitle)]) {
            item.titleLabel.text = viewController.menuTitle;
        }
        if ([viewController respondsToSelector:@selector(menuImage)]) {
            item.imageView.image = viewController.menuImage;
        }
        if ([viewController respondsToSelector:@selector(selectedMenuImage)]) {
            item.imageView.highlightedImage = viewController.selectedMenuImage;
        }
        [items addObject:item];
    }
    [self.menuView setItems:items];

}


- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animation:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animation:(BOOL)animation {
    if (selectedIndex >= [_viewControllers count]) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    [self.menuView setSelectedItem:[self.menuView.items objectAtIndex:_selectedIndex]];
    
    UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:animation];
		}
	} else {
		self.selectedViewController = vc;
	}
    
    [self closeMenu:YES];
    
}


- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = _selectedViewController;
	if (_selectedViewController != vc) {
		_selectedViewController = vc;
        
        if (/*!self.childViewControllers && */_visible) {
//			[oldVC viewWillDisappear:NO];
			[vc viewWillAppear:NO];
            [oldVC removeFromParentViewController];
		}

        for(UIView *v in self.contentView.subviews) {
            [v removeFromSuperview];
        }
        vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
       
        [self.contentView addSubview:vc.view];
        vc.view.frame = self.contentView.bounds;
        
        if (/*!self.childViewControllers &&*/ _visible) {
//			[oldVC viewDidDisappear:NO];
//			[_selectedViewController viewDidAppear:NO];
		}

		[self.menuView setSelectedItem:[self.menuView.items objectAtIndex:_selectedIndex]];
        
        
        
	}
}



#pragma mark -
#pragma mark - Drag and animations
- (void)transformForMenuView:(CGFloat)distance animation:(BOOL)animation {
    [self.menuView setTranslationX:distance animation:animation];
}

- (void)transformForTopView:(CGFloat)distance animation:(BOOL)animation {
    float percentage = distance / _activeWidth;
    percentage = MAX(percentage, 0);
    percentage = MIN(percentage, 1);
    if(animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.topView.bottom =  percentage * self.topView.height;
        }];
    } else {
        self.topView.bottom =  percentage * self.topView.height;
    }
}




- (void)transformForContentView:(CGFloat)distance animation:(BOOL)animation{
    CGFloat distanceThreshold = _activeWidth;
    CGFloat coverAngle = -55.0 / 180.0 * M_PI;
    CGFloat perspective = -1.0/1150;  // fixed
    
    CGFloat coverScale = 0.5;       // fixed
    CGFloat percentage = fabsf(distance)/distanceThreshold;
    
    [self.contentView setAnchorPoint:CGPointMake(0, 0.5)];
    NSLog(@"percentage : %f",percentage);
    if (NO) {
        self.contentView.layer.transform = [self
                                            transform3DWithRotation:percentage * coverAngle
                                            scale:(1 - percentage) * (1 - coverScale) + coverScale
                                            translationX:distance
                                            perspective:perspective
                                            ];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.layer.transform = [self
                                                transform3DWithRotation:percentage * coverAngle
                                                scale:(1 - percentage) * (1 - coverScale) + coverScale
                                                translationX:distance
                                                perspective:perspective
                                                ];
        }];
    }
    
}

- (CATransform3D)transform3DWithRotation:(CGFloat)angle
                                   scale:(CGFloat)scale
                            translationX:(CGFloat)tranlationX
                             perspective:(CGFloat)perspective {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, tranlationX , 0, 0);
    transform = CATransform3DScale(transform, scale, scale, 1.0);
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
    
    return transform;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    _draggingHorizonal = fabs(translation.y) < fabs(translation.x);
    if(_menuOpened && velocity.x > 0) {
        return NO;
    }
    
    if ([_selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigator = (UINavigationController *)_selectedViewController;
        if (navigator.topViewController != [navigator.viewControllers firstObject]) {
            return NO;
        }
    }
    
    return YES;
}


- (void)handleRevealGesture:(UIPanGestureRecognizer *)recognizer
{
    if (_draggingHorizonal) {
        switch ( recognizer.state)
        {
            case UIGestureRecognizerStateBegan:
                [self handleRevealGestureStateBeganWithRecognizer:recognizer];
                break;
                
            case UIGestureRecognizerStateChanged:
                [self handleRevealGestureStateChangedWithRecognizer:recognizer];
                break;
                
            case UIGestureRecognizerStateEnded:
                [self handleRevealGestureStateEndedWithRecognizer:recognizer];
                break;
                
            case UIGestureRecognizerStateCancelled:
                [self handleRevealGestureStateCancelledWithRecognizer:recognizer];
                break;
            default:
                break;
        }
    } else {
//        CGPoint point = [recognizer locationInView:self.view];
//        if (CGRectContainsPoint(self.contentView.frame, point)) {
//            NSLog(@"point: %@", NSStringFromCGPoint(point));
//            NSLog(@"rect : %@", NSStringFromCGRect(self.contentView.frame));
//        } else {
//
//        }

    }
}

- (void)handleRevealGestureStateBeganWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
}

- (void)handleRevealGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    if(!_menuOpened && translation.x <= 0 ){
        return;
    }
    [self transformForContentView:translation.x + _translationX animation:NO];
    [self transformForMenuView:translation.x + _translationX animation:NO];
    [self transformForTopView:translation.x + _translationX animation:NO];
}

- (void)handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat threshold = 150;
    NSLog(@"translation.x = %f",translation.x);
    if(translation.x > threshold) {
        // open menu
        [self openMenu:YES];
    } else if (translation.x < 0) {
        // close menu
        [self closeMenu:YES];
    } else {
        [self closeMenu:YES];
    }
}

- (void)handleRevealGestureStateCancelledWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)closeAction:(id)sender {
    [self closeMenu:YES];
}

- (void)closeMenu:(BOOL)animation {
    _menuOpened = NO;
    _translationX = 0;
    [self transformForContentView:0 animation:animation];
    [self transformForMenuView:0 animation:animation];
    [self transformForTopView:0 animation:animation];

    self.contentView.userInteractionEnabled = YES;
}

- (void)openMenu:(BOOL)animation {
    _translationX = _activeWidth;
    _menuOpened = YES;
    [self transformForContentView:_translationX animation:animation];
    [self transformForMenuView:_translationX animation:animation];
    [self transformForTopView:_translationX animation:animation];
    
    self.contentView.userInteractionEnabled = NO;
}

- (void)menuView:(RAirMenuView *)menu didSelectItemAtIndex:(NSInteger)index {
    [self setSelectedIndex:index];

}


- (void)enableEffect:(BOOL)effect {
    if (!effect) {
        return;
    }
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    if([self.backgroundView respondsToSelector:@selector(addMotionEffect:)]) {
        [self.backgroundView addMotionEffect:horizontalMotionEffect];
    }
}


@end
