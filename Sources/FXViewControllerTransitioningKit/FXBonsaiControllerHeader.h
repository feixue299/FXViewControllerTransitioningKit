//
//  FXBonsaiControllerHeader.h
//  FXViewControllerTransitioningKit
//
//  Created by 8-PC on 2020/6/19.
//  Copyright © 2020 wu. All rights reserved.
//

#ifndef FXBonsaiControllerHeader_h
#define FXBonsaiControllerHeader_h

#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger, FXBonsaiControllerDirection) {
    FXBonsaiControllerDirectionLeft,
    FXBonsaiControllerDirectionRight,
    FXBonsaiControllerDirectionTop,
    FXBonsaiControllerDirectionBottom,
};

@protocol FXBonsaiTransitionProperties <NSObject>

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat springWithDamping;
@property (nonatomic, assign) BOOL isDisabledDismissAnimation;

@end

#endif /* FXBonsaiControllerHeader_h */
