//
//  FXBubbleTransition.m
//  FXViewControllerTransitioningKit
//
//  Created by 8-PC on 2020/6/19.
//  Copyright © 2020 wu. All rights reserved.
//

#import "FXBubbleTransition.h"
#import <AVFoundation/AVFoundation.h>

@interface FXBubbleTransition ()<UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL reverse;
@property (nonatomic, strong) UIView *originView;
@end

@implementation FXBubbleTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.3;
        self.springWithDamping = 0.8;
        self.isDisabledDismissAnimation = NO;
    }
    return self;
}

- (instancetype)initWithOriginView:(UIView *)originView reverse:(BOOL)reverse {
    if (self = [self init]) {
        self.reverse = reverse;
        self.originView = originView;
    }
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UITransitionContextViewControllerKey viewControllerKey = self.reverse ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey;
    UIViewController *viewControllerToAnimate = [transitionContext viewControllerForKey:viewControllerKey];

    UIView *viewToAnimate = viewControllerToAnimate.view;
    viewToAnimate.frame = [transitionContext finalFrameForViewController:viewControllerToAnimate];

    CGRect initialFrame = CGRectZero;

    if ([self.originView isKindOfClass:UIImageView.class] && self.originView.contentMode == UIViewContentModeScaleAspectFit) {
        CGSize imageSize = ((UIImageView *)self.originView).image.size;
        CGRect imageViewRect = self.originView.frame;
        CGRect frame = AVMakeRectWithAspectRatioInsideRect(imageSize, imageViewRect);
        initialFrame = [(self.originView.superview != nil ? self.originView.superview : self.originView) convertRect:frame toView:nil];
    } else {
        initialFrame = [(self.originView.superview != nil ? self.originView.superview : self.originView) convertRect:self.originView.frame toView:nil];
    }

    CGRect finalFrame = viewToAnimate.frame;

    CGFloat xScaleFactor = initialFrame.size.width / finalFrame.size.width;
    CGFloat yScaleFactor = initialFrame.size.height / finalFrame.size.height;

    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);

    if (!self.reverse) {
        viewToAnimate.transform = scaleTransform;
        viewToAnimate.center = CGPointMake(initialFrame.origin.x + initialFrame.size.width / 2, initialFrame.origin.y + initialFrame.size.height / 2);
        viewToAnimate.clipsToBounds = YES;
        [transitionContext.containerView addSubview:viewToAnimate];
    }

    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:self.reverse ? 1 : self.springWithDamping initialSpringVelocity:0 options:0 animations:^{
        if (self.reverse && self.isDisabledDismissAnimation) {
            viewToAnimate.alpha = 0;
            return;
        }
        viewToAnimate.transform = self.reverse ? scaleTransform : CGAffineTransformIdentity;

        CGRect frame = self.reverse ? initialFrame : finalFrame;
        viewToAnimate.center = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
    } completion:nil];

    [UIView animateWithDuration:self.duration / 2 delay:self.duration / 2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewToAnimate.alpha = self.reverse ? 0 : 1;
    } completion:nil];
}

@end
