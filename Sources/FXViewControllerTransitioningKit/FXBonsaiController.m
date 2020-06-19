//
//  FXBonsaiController.m
//  FXViewControllerTransitioningKit
//
//  Created by 8-PC on 2020/6/19.
//  Copyright © 2020 wu. All rights reserved.
//

#import "FXBonsaiController.h"
#import "FXBubbleTransition.h"
#import "FXSlideInTransition.h"

@interface FXBonsaiController ()<FXBonsaiControllerDelegate>

@property (nonatomic, strong) UIView *originView;
@property (nonatomic) FXBonsaiControllerDirection fromDirection;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic) UIBlurEffectStyle blurEffectStyle;
@property (nonatomic, copy) UIColor *backgroundColor;

@end

@implementation FXBonsaiController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [self initWithFromDirection:FXBonsaiControllerDirectionBottom backgroundColor:UIColor.whiteColor presentedViewController:presentedViewController delegate:nil]) {

    }
    return self;
}

- (instancetype)initWithFromDirection:(FXBonsaiControllerDirection)direction blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:nil]) {
        [self fx_commonIntit];
        self.fromDirection = direction;
        self.sizeDelegate = delegate;
        self.blurEffectStyle = blurEffectStyle;
        [self fx_setupWithPresentedViewController:presentedViewController];
    }
    return self;
}

- (instancetype)initWithFromDirection:(FXBonsaiControllerDirection)direction backgroundColor:(UIColor *)backgroundColor presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:nil]) {
        [self fx_commonIntit];
        self.fromDirection = direction;
        self.sizeDelegate = delegate;
        self.backgroundColor = backgroundColor;
        [self fx_setupWithPresentedViewController:presentedViewController];
    }
    return self;
}

- (instancetype)initWithFromView:(UIView *)view blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:nil]) {
        [self fx_commonIntit];
        self.originView = view;
        self.sizeDelegate = delegate;
        self.blurEffectStyle = blurEffectStyle;
        [self fx_setupWithPresentedViewController:presentedViewController];
    }
    return self;
}

- (instancetype)initWithFromView:(UIView *)view backgroundColor:(UIColor *)backgroundColor presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:nil]) {
        [self fx_commonIntit];
        self.originView = view;
        self.sizeDelegate = delegate;
        self.backgroundColor = backgroundColor;
        [self fx_setupWithPresentedViewController:presentedViewController];
    }
    return self;
}

- (void)fx_commonIntit {
    self.duration = 0.4;
    self.springWithDamping = 0.8;
    self.isDisabledDismissAnimation = NO;
    self.isDisabledTapOutside = NO;
}

- (void)dismiss {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)fx_setupWithPresentedViewController:(UIViewController *)presentedViewController {
    UIBlurEffect *blurEffect;
    if (self.blurEffectStyle) {
        blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    } else {
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        self.blurEffectView.backgroundColor = self.backgroundColor;
    }
    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurEffectView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fx_handleTap)];
    [self.blurEffectView addGestureRecognizer:tapGestureRecognizer];

    self.presentedView.layer.masksToBounds = YES;
    self.presentedView.layer.cornerRadius = 10;

    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    presentedViewController.transitioningDelegate = self;
}

- (void)fx_handleTap {
    if (!self.isDisabledTapOutside) {
        [self dismiss];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    if (self.sizeDelegate) {
        return [self.sizeDelegate frameOfPresentedViewInContainerViewFrame:self.containerView.frame];
    } else {
        return [self frameOfPresentedViewInContainerViewFrame:self.containerView.frame];
    }
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.blurEffectView.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.blurEffectView removeFromSuperview];
        if (self.sizeDelegate && [self.sizeDelegate respondsToSelector:@selector(didDismiss)]) {
            [self.sizeDelegate didDismiss];
        }
    }];
}

- (void)presentationTransitionWillBegin {
    self.blurEffectView.alpha = 0;
    self.blurEffectView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.blurEffectView];

    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.blurEffectView.alpha = 1;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.presentedView.frame = self.frameOfPresentedViewInContainerView;
        [self.presentedView layoutIfNeeded];
    } completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)fx_setupTransitioningProperties:(id<FXBonsaiTransitionProperties>)transitioning {
    transitioning.duration = self.duration;
    transitioning.springWithDamping = self.springWithDamping;
    transitioning.isDisabledDismissAnimation = self.isDisabledDismissAnimation;
    return (id<UIViewControllerAnimatedTransitioning>)transitioning;
}

#pragma mark FXBonsaiControllerDelegate
- (CGRect)frameOfPresentedViewInContainerViewFrame:(CGRect)containerViewFrame {
    return CGRectMake(0, containerViewFrame.size.height / 2, containerViewFrame.size.width, containerViewFrame.size.height / 2);
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (self.sizeDelegate && [self.sizeDelegate respondsToSelector:@selector(animationControllerForPresentedController:presentingController:sourceController:)]) {
        return [self.sizeDelegate animationControllerForPresentedController:presented presentingController:presenting sourceController:source];
    }
    id<FXBonsaiTransitionProperties> transitioning;
    if (self.originView) {
        transitioning = [[FXBubbleTransition alloc] initWithOriginView:self.originView reverse:NO];
    } else {
        transitioning = [[FXSlideInTransition alloc] initWithFromDirection:self.fromDirection reverse:NO];
    }
    return [self fx_setupTransitioningProperties:transitioning];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.sizeDelegate && [self.sizeDelegate respondsToSelector:@selector(animationControllerForDismissedController:)]) {
        return [self.sizeDelegate animationControllerForDismissedController:dismissed];
    }

    id<FXBonsaiTransitionProperties> transitioning;

    if (self.originView) {
        transitioning = [[FXBubbleTransition alloc] initWithOriginView:self.originView reverse:YES];
    } else {
        transitioning = [[FXSlideInTransition alloc] initWithFromDirection:self.fromDirection reverse:YES];
    }
    return  [self fx_setupTransitioningProperties:transitioning];
}

@end
