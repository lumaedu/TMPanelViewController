//
//  UIView+Utilities.h
//  TutorMe
//
//  Created by Emerson Malca on 6/10/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

- (UIImage *)screenshot;
- (void)copyShadowPropertiesFromView:(UIView *)view;
- (UIView *)findFirstResponder;

@end
