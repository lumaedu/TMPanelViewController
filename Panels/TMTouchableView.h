//
//  TMTouchableView.h
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMTouchableViewDelegate;

@interface TMTouchableView : UIView

@property (nonatomic) BOOL touchForwardingDisabled;
@property (weak, nonatomic) id <TMTouchableViewDelegate> delegate;

@end

@protocol TMTouchableViewDelegate<NSObject>

- (void)touchableViewDidReceiveTouch:(TMTouchableView *)view;

@end