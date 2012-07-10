//
//  UIView+Positioning.h
//  TutorMe
//
//  Created by Emerson Malca on 3/22/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//



@interface UIView (Positioning)

- (CGRect)frameForTopCenterPositionInView:(UIView *)view;
- (CGRect)frameForTopRightPositionInView:(UIView *)view;
- (CGRect)frameForTopLeftPositionInView:(UIView *)view;
- (CGRect)frameForCenterRightPositionInView:(UIView *)view;
- (CGRect)frameForCenterPositionInView:(UIView *)view;
- (CGRect)frameForCenterLeftPositionInView:(UIView *)view;
- (CGRect)frameForBottomLeftPositionInView:(UIView *)view;
- (CGRect)frameForBottomCenterPositionInView:(UIView *)view;
- (CGRect)frameForBottomRightPositionInView:(UIView *)view;
@end
