//
//  FXBonsaiController.h
//  FXViewControllerTransitioningKit
//
//  Created by 8-PC on 2020/6/19.
//  Copyright © 2020 wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBonsaiControllerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FXBonsaiControllerDelegate <UIViewControllerTransitioningDelegate>

/// Returns a frame for presented viewController on containerView
///
/// - Parameter: containerViewFrame
- (CGRect)frameOfPresentedViewInContainerViewFrame:(CGRect)containerViewFrame;
@optional
//(presentationControllerForPresentedViewController:presentingViewController:sourceViewController:)
//func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
- (void)didDismiss;

@end

@interface FXBonsaiController : UIPresentationController<FXBonsaiTransitionProperties>

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat springWithDamping;
@property (nonatomic, assign) BOOL isDisabledDismissAnimation;
@property (nonatomic, assign) BOOL isDisabledTapOutside;
@property (nonatomic, weak) id<FXBonsaiControllerDelegate> sizeDelegate;

- (instancetype)initWithFromDirection:(FXBonsaiControllerDirection)direction blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFromDirection:(FXBonsaiControllerDirection)direction backgroundColor:(UIColor *)backgroundColor presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFromView:(UIView *)view blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFromView:(UIView *)view backgroundColor:(UIColor *)backgroundColor presentedViewController:(UIViewController *)presentedViewController delegate:(nullable id<FXBonsaiControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
