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
}

- (void)viewDidLoad {
    CGFloat _topHeight = 60;
    
    self.menuView = [[RAirMenuView alloc] initWithFrame:self.view.bounds];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
    _rightCloseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_rightCloseButton setTitle:@"Close" forState:UIControlStateNormal];
    _rightCloseButton.frame = CGRectMake(self.view.bounds.size.width - 70, 0, 70, self.view.bounds.size.height);
    _rightCloseButton.layer.borderColor = [UIColor yellowColor].CGColor;
    _rightCloseButton.layer.borderWidth = 3;
    [self.view addSubview:_rightCloseButton];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    self.contentView.layer.borderWidth = 2;
    self.contentView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.contentView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -_topHeight, CGRectGetWidth(self.view.bounds), _topHeight)];
    self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.topView.backgroundColor = [UIColor darkGrayColor];
    self.topView.layer.borderWidth = 2;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.topView];
    
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRevealGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	_visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	_visible = NO;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    if(_viewControllers != viewControllers) {
        _selectedIndex = 0;
        
        for(UIViewController *c in _viewControllers) {
            [c removeFromParentViewController];
        }
        
        _viewControllers = viewControllers;
        
        for(UIViewController *c in _viewControllers) {
            [self addChildViewController:c];
        }
        
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
    
    if (selectedIndex >= [_viewControllers count]) {
        return;
    }

    _selectedIndex = selectedIndex;
    [self.menuView setSelectedItem:[self.menuView.items objectAtIndex:_selectedIndex]];
    
    UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
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
        if (!self.childViewControllers && _visible) {
			[oldVC viewWillDisappear:NO];
			[_selectedViewController viewWillAppear:NO];
		}

        for(UIView *v in self.contentView.subviews) {
            [v removeFromSuperview];
        }
        [self.contentView addSubview:vc.view];

        if (!self.childViewControllers && _visible) {
			[oldVC viewDidDisappear:NO];
			[_selectedViewController viewDidAppear:NO];
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
    float percentage = distance / _menuWidth;
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
    CGFloat distanceThreshold = 320.f;
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
    transform = CATransform3DTranslate(transform, tranlationX * 280.0 / 320.0 , 0, 0);
    transform = CATransform3DScale(transform, scale, scale, 1.0);
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
    
    return transform;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    
    _draggingHorizonal = fabs(translation.y) < fabs(translation.x);
    //    return fabs(translation.y) > fabs(translation.x);
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
        CGPoint point = [recognizer locationInView:self.view];
        if (CGRectContainsPoint(self.contentView.frame, point)) {
            NSLog(@"point: %@", NSStringFromCGPoint(point));
            NSLog(@"rect : %@", NSStringFromCGRect(self.contentView.frame));
        } else {
//            [self.menuView handleRevealGesture:recognizer];
        }
        //         [self.menuView.frame ]
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



- (void)closeMenu:(BOOL)animation {
    _menuOpened = NO;
    _translationX = 0;
    [self transformForContentView:0 animation:animation];
    [self transformForMenuView:0 animation:animation];
    [self transformForTopView:0 animation:animation];
    
}

- (void)openMenu:(BOOL)animation {
    _translationX = 280;
    _menuOpened = YES;
    [self transformForContentView:_translationX animation:animation];
    [self transformForMenuView:_translationX animation:animation];
    [self transformForTopView:_translationX animation:animation];
}

- (void)menuView:(RAirMenuView *)menu didSelectItemAtIndex:(NSInteger)index {
    [self setSelectedIndex:index];

}


@end
