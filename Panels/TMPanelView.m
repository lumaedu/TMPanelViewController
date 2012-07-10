//
//  TMPanelView.m
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import "TMPanelView.h"
#import "TMCloseButton.h"
#import "UIView+Positioning.h"
#import <QuartzCore/QuartzCore.h>

#define kTMPanelBackgroundColor RGBCOLOR(248, 246, 242)

typedef enum {
    kTMPanDirectionUp = 0,
    kTMPanDirectionDown = 1,
    kTMPanDirectionLeft = 2,
    kTMPanDirectionRight = 3
} TMPanDirection;

@interface TMPanelView ()

@end

@implementation TMPanelView {
    CGFloat _maxHidingDistance;
    CGFloat _visibleX;
    CGFloat _hiddenX;
    CGRect _initialFrameAtPanning;
    TMPanDirection _panDirection;
}

@synthesize shouldShowCloseButton=_shouldShowCloseButton;
@synthesize btnClose=_btnClose;
@synthesize visibleFrame=_visibleFrame;
@synthesize draggable=_draggable;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
        [self.layer setShadowRadius:kTMDefaultShadowRadius];
        [self.layer setShadowOpacity:0.7];
        [self.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:20.0].CGPath];
        [self.layer setBackgroundColor:kTMPanelBackgroundColor.CGColor];
        [self.layer setCornerRadius:kTMDefaultShadowRadius];
        [self setUserInteractionEnabled:YES];
        
        //Close button
        _btnClose = [[TMCloseButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 34.0, 34.0)];
        _btnClose.color = [UIColor grayColor];
        _btnClose.frame = [_btnClose frameForTopRightPositionInView:self];
        _btnClose.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        _btnClose.frame = CGRectOffset(_btnClose.frame, -5.0, 5.0);
        [_btnClose addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClose];
        [self setOpaque:NO];
        
        //Track panning
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGRect prevFrame = self.frame;
    [super setFrame:frame];
     
    if (prevFrame.size.width != frame.size.width || prevFrame.size.height != frame.size.height) {
        //Recalculate the shadow
        [self.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:20.0].CGPath];
    }
}

- (void)setShouldShowCloseButton:(BOOL)shouldShowCloseButton {
    _shouldShowCloseButton = shouldShowCloseButton;
    _btnClose.hidden = !_shouldShowCloseButton;
}

- (void)didMoveToSuperview {
    //Set the initial visible frame, if it hasn't been set
    if (CGRectEqualToRect(_visibleFrame, CGRectZero)) {
        [self setVisibleFrame:self.frame];
    }
}

- (void)setVisibleFrame:(CGRect)visibleFrame {
    _visibleFrame = visibleFrame;
    
    //The max hiding distance (horizontal) is calculated from the width of the panel
    _maxHidingDistance = CGRectGetWidth(visibleFrame) + kTMDefaultShadowRadius;
    _visibleX = visibleFrame.origin.x;
    _hiddenX = _visibleX + _maxHidingDistance;
}

#pragma mark -
#pragma mark Action methods

- (void)closeButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(panelViewDidPressCloseButton:)]) {
        [self.delegate panelViewDidPressCloseButton:self];
    }
}

#pragma mark -
#pragma mark Hiding and showing methods

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    if (_draggable) {
        if ([pan state] == UIGestureRecognizerStateBegan) {
            _initialFrameAtPanning = self.frame;
        } else if ([pan state] == UIGestureRecognizerStateChanged) {
            [self moveToolbarBasedOnGesture:pan];
        } else if ([pan state] == UIGestureRecognizerStateEnded) {
            [self animateToolbarToLockPosition];
        }
    }
}

- (void)moveToolbarBasedOnGesture:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.superview];
    
    //Update the frame of the toolbar based on the translation
    CGFloat xOffset = translation.x;
    CGRect updatedFrame = CGRectOffset(_initialFrameAtPanning, xOffset, 0.0);
    
    //And update the direction
    CGFloat deltaX = self.frame.origin.x - updatedFrame.origin.x;
    _panDirection = (deltaX < 0.0)? kTMPanDirectionRight:kTMPanDirectionLeft;
    
    //Update the frame if we won't go over the thresholds
    if (updatedFrame.origin.x >= _visibleX && updatedFrame.origin.x <= _hiddenX) {
        self.frame = updatedFrame;
    }
    
}

- (void)animateToolbarToLockPosition {
    CGRect finalFrame;
    BOOL isPanelVisible = NO;
    if (_panDirection == kTMPanDirectionLeft) {
        //Visible
        finalFrame = _visibleFrame;
        isPanelVisible = YES;
    } else {
        finalFrame = CGRectOffset(_visibleFrame,_maxHidingDistance, 0.0);
        isPanelVisible = NO;
    }
    
    __weak TMPanelView *weakSelf = self;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         TMPanelView *strongSelf = weakSelf;
                         if (strongSelf) {
                             [strongSelf setFrame:finalFrame];
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         TMPanelView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //We inform the delegate, if we closed the panel
                             if (!isPanelVisible && strongSelf->_delegate && [strongSelf->_delegate respondsToSelector:@selector(panelViewDidHide:)]) {
                                 [strongSelf->_delegate panelViewDidHide:strongSelf];
                             }
                         }
                         
                     }];
    
}

@end
