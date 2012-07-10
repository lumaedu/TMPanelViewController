//
//  UIView+Utilities.m
//  TutorMe
//
//  Created by Emerson Malca on 6/10/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import "UIView+Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utilities)

- (UIImage *)screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)copyShadowPropertiesFromView:(UIView *)view {
    [self.layer setShadowColor:view.layer.shadowColor];
    [self.layer setShadowOffset:view.layer.shadowOffset];
    [self.layer setShadowRadius:view.layer.shadowRadius];
    [self.layer setShadowOpacity:view.layer.shadowOpacity];
    [self.layer setShadowPath:view.layer.shadowPath];
}

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {        
        return self;     
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

@end
