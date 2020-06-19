//
//  FXBubbleTransition.h
//  FXViewControllerTransitioningKit
//
//  Created by 8-PC on 2020/6/19.
//  Copyright © 2020 wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXBonsaiControllerHeader.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXBubbleTransition : NSObject<FXBonsaiTransitionProperties>

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat springWithDamping;
@property (nonatomic, assign) BOOL isDisabledDismissAnimation;

- (instancetype)initWithOriginView:(UIView *)originView reverse:(BOOL)reverse;

@end

NS_ASSUME_NONNULL_END
