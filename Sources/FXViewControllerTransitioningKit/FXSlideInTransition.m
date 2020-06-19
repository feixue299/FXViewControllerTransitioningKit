//
//  FXSlideInTransition.m
//  FXViewControllerTransitioningKit
//
//  Created by 8-PC on 2020/6/19.
//  Copyright © 2020 wu. All rights reserved.
//

#import "FXSlideInTransition.h"
#import <UIKit/UIKit.h>

@interface FXSlideInTransition ()<UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL reverse;
@property (nonatomic) FXBonsaiControllerDirection fromDirection;

@end

@implementation FXSlideInTransition

- (instancetype)initWithFromDirection:(FXBonsaiControllerDirection)fromDirection reverse:(BOOL)reverse {
    if (self = [super init]) {
        self.duration = 0.3;
        self.springWithDamping = 0.8;
        self.isDisabledDismissAnimation = NO;
        self.reverse = reverse;
        self.fromDirection = fromDirection;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UITransitionContextViewControllerKey viewControllerKey = self.reverse ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey;
    UIViewController *viewControllerToAnimate = [transitionContext viewControllerForKey:viewControllerKey];

    UIView *viewToAnimate = viewControllerToAnimate.view;
    viewToAnimate.frame = [transitionContext finalFrameForViewController:viewControllerToAnimate];

    CGRect offsetFrame = [self fx_offsetFrameForView:viewToAnimate containerView:transitionContext.containerView];

    if (!self.reverse) {
        [transitionContext.containerView addSubview:viewToAnimate];
        viewToAnimate.frame = offsetFrame;
    }

    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:self.springWithDamping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.reverse && self.isDisabledDismissAnimation) {
            viewToAnimate.alpha = 0;
            return;
        }
        if (self.reverse) {
            viewToAnimate.frame = offsetFrame;
        } else {
            viewToAnimate.frame = [transitionContext finalFrameForViewController:viewControllerToAnimate];
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (CGRect)fx_offsetFrameForView:(UIView *)view containerView:(UIView *)containerView {
    CGRect frame = view.frame;
    switch (self.fromDirection) {
        case FXBonsaiControllerDirectionLeft: {
            frame.origin.x = -frame.size.width;
            break;
        }

        case FXBonsaiControllerDirectionRight: {
            frame.origin.x = containerView.bounds.size.width;
            break;
        }

        case FXBonsaiControllerDirectionTop: {
            frame.origin.y = -frame.size.height;
            break;
        }

        case FXBonsaiControllerDirectionBottom: {
            frame.origin.y = containerView.bounds.size.height;
            break;
        }
        default:
            break;
    }
    return frame;
}

@end
