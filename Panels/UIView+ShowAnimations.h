//
//  UIView+ShowAnimations.h
//  TutorMe
//
//  Created by Emerson Malca on 3/18/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//



@interface UIView (ShowAnimations)

- (void)popFromInitialScale:(CGFloat)scale;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
- (void)popDismissWithDuration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
- (void)popDismissWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)slideToFinalFrame:(CGRect)finalFrame maxBounceOffset:(CGPoint)offset duration:(CGFloat)duration;
- (void)fall;
- (void)spinClockwise:(BOOL)clockwise duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
@end
