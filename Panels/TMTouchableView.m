//
//  TMTouchableView.m
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import "TMTouchableView.h"

@implementation TMTouchableView

@synthesize touchForwardingDisabled=_touchForwardingDisabled;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchableViewDidReceiveTouch:)]) {
            [self.delegate touchableViewDidReceiveTouch:self];
        }
    }
}


@end
