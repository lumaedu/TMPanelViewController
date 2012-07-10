//
//  UIView+ShowAnimations.m
//  TutorMe
//
//  Created by Emerson Malca on 3/18/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import "UIView+ShowAnimations.h"
#import <QuartzCore/QuartzCore.h>

#define kTMPopAnimationDefaultDuration  0.3

@implementation UIView (ShowAnimations)

- (void)popFromInitialScale:(CGFloat)scale {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:1.0 duration:kTMPopAnimationDefaultDuration completion:NULL];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:alpha duration:kTMPopAnimationDefaultDuration completion:NULL];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:alpha duration:duration completion:NULL];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion {
    
    //Min
    if (scale < 0.01) {
        scale = 0.01;
    }
    
    //Make the view super tiny
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    //Make the view transparent
    self.alpha = alpha;
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Grow the view a little bit larger than original size
                             strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                             strongSelf.alpha = 1.0;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction)
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  //Shrink the view a little bit smaller than original size
                                                  strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                                              }
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:duration/2
                                                               animations:^{
                                                                   
                                                                   UIView *strongSelf = weakSelf;
                                                                   if (strongSelf) {
                                                                       //Bring the view back to its original size
                                                                       strongSelf.transform = CGAffineTransformIdentity;
                                                                   }
                                                                   
                                                               }
                                                               completion:^(BOOL finished){
                                                                   if (completion != NULL) {
                                                                       completion(finished);
                                                                   }
                                                               }];
                                              
                                          }];
                         
                     }];
    
}

- (void)popDismissWithDuration:(CGFloat)duration completion:(void (^)(BOOL finished))completion {
    [self popDismissWithDuration:duration delay:0.0 completion:completion];
}

- (void)popDismissWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:duration/2
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Grow the view a little bit larger than original size
                             strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction)
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  //Shrink the view completely
                                                  strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
                                                  strongSelf.alpha = 0.0;
                                              }
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  //Bring the view back to its original size
                                                  strongSelf.transform = CGAffineTransformIdentity;
                                              }
                                              
                                              if (completion != NULL) {
                                                  completion(finished);
                                              }
                                              
                                          }];
                         
                     }];
    
}

- (void)slideToFinalFrame:(CGRect)finalFrame maxBounceOffset:(CGPoint)offset duration:(CGFloat)duration {
    //First we want to go as further as we can
    CGRect firstBounceFrame = CGRectOffset(finalFrame, offset.x, offset.y);
    //Second we want to bounce back and go half way more the other way
    CGRect secondBounceFrame = CGRectOffset(finalFrame, -offset.x/2, -offset.y/2);
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionOverrideInheritedDuration)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                            self.frame = firstBounceFrame; 
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionOverrideInheritedDuration)
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  self.frame = secondBounceFrame;
                                              }
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:duration/2
                                                                    delay:0.0
                                                                  options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionOverrideInheritedDuration)
                                                               animations:^{
                                                                   
                                                                   UIView *strongSelf = weakSelf;
                                                                   if (strongSelf) {
                                                                       self.frame = finalFrame;
                                                                   }
                                                                   
                                                               } 
                                                               completion:NULL];
                                              
                                          }];
                         
                     }];
}

- (void)fall {
    
    //Make the view larger
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
    //Make the view transparent
    self.alpha = 0.0;
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionOverrideInheritedDuration)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Bring the view back to its original size
                             strongSelf.transform = CGAffineTransformIdentity;
                             strongSelf.alpha = 1.0;
                         }
                         
                     }
                     completion:NULL];
}

- (void)spinClockwise:(BOOL)clockwise duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CGFloat direction = (clockwise)?-1.0:1.0;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * direction];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
