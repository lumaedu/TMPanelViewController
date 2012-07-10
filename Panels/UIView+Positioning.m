//
//  UIView+Positioning.m
//  TutorMe
//
//  Created by Emerson Malca on 3/22/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import "UIView+Positioning.h"

@implementation UIView (Positioning)

- (CGRect)frameForTopCenterPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake((CGRectGetWidth(view.frame)-size.width)/2,
                              0.0,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForTopRightPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.frame)-size.width,
                              0.0,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForTopLeftPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(0.0,
                              0.0,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForCenterRightPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.frame)-size.width,
                              CGRectGetHeight(view.frame)/2 - size.height/2,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForCenterPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.frame)/2 - size.width/2,
                              CGRectGetHeight(view.frame)/2 - size.height/2,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForCenterLeftPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(0.0,
                              CGRectGetHeight(view.frame)/2 - size.height/2,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForBottomLeftPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(0.0,
                              CGRectGetHeight(view.frame) - size.height,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForBottomCenterPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake((CGRectGetWidth(view.frame) - size.width)/2,
                              CGRectGetHeight(view.frame) - size.height,
                              size.width,
                              size.height);
    return frame;
}

- (CGRect)frameForBottomRightPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.frame) - size.width,
                              CGRectGetHeight(view.frame) - size.height,
                              size.width,
                              size.height);
    return frame;
}

@end
