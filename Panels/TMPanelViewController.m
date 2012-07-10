//
//  TMPanelViewController.m
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import "TMPanelViewController.h"
#import "UIView+ShowAnimations.h"
#import "UIView+Positioning.h"
#import "UIView+Utilities.h"
#import <objc/runtime.h>

#define TEXT_FIELD_KEYBOARD_PADDING 80.0

@interface TMPanelViewController ()

@end

@interface UIViewController (TMPanelViewControllerItem_Internal) 

// internal setter for the panelController property on UIViewController
- (void)setPanelController:(TMPanelViewController *)panelController;

@end

@implementation TMPanelViewController {
    BOOL _isPanelVisible;
    BOOL _keyboardShowing;
    CGFloat _yCoordShiftOnKeyboardAppear;
}

@synthesize contentViewController=_contentViewController;
@synthesize backgroundView=_backgroundView;
@synthesize panelView=_panelView;
@synthesize presentationMode=_presentationMode;
@synthesize panelContentSize=_panelContentSize;
@synthesize panelContentInsets=_panelContentInsets;
@synthesize shouldShowCloseButton=_shouldShowCloseButton;
@synthesize shouldDismissFirstResponderOnTapOnBackground=_shouldDismissFirstResponderOnTapOnBackground;
@synthesize delegate=_delegate;

- (id)initWithContentViewController:(UIViewController *)viewController {
    if ((self = [self init])) {
		self.contentViewController = viewController;
        _presentationMode = kTMPanelViewPresentationModeCenter;
        
        _panelContentSize = CGSizeZero;
        _panelContentInsets = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
        
        _shouldDismissFirstResponderOnTapOnBackground = YES;
	}
	return self;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController == contentViewController) {
        return;
    }
    
    _contentViewController.panelController = nil;
    _contentViewController = contentViewController;
    _contentViewController.panelController = self;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (TMPanelView *)panelView {
    if (_panelView == nil) {
        _panelView = [[TMPanelView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    }
    return _panelView;
}


#pragma mark -
#pragma mark Presentation methods

- (void)presentPanel {
    
    UIView *presenterView = self.keyView;
    UIView *contentView = [_contentViewController view];
    CGRect fullViewFrame = presenterView.bounds;
    fullViewFrame.origin = CGPointZero;
    self.view.frame = fullViewFrame;
    
    if (CGSizeEqualToSize(_panelContentSize, CGSizeZero)) {
		_panelContentSize = _contentViewController.contentSizeForViewInPopover;
	}
    
    //Setup the background view
    _backgroundView = [[TMTouchableView alloc] initWithFrame:fullViewFrame];
	_backgroundView.contentMode = UIViewContentModeScaleToFill;
	_backgroundView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin |
									   UIViewAutoresizingFlexibleWidth |
									   UIViewAutoresizingFlexibleRightMargin |
									   UIViewAutoresizingFlexibleTopMargin |
									   UIViewAutoresizingFlexibleHeight |
									   UIViewAutoresizingFlexibleBottomMargin);
	_backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75]; //Semi-transparent black
    _backgroundView.alpha = 0.0;
	_backgroundView.delegate = self;
    [self.view addSubview:_backgroundView];
    
    //Setup the panel view
    //The size of the panel will be the same of the content size + the insets
    CGRect panelFrame = CGRectMake(0.0, 
                                   0.0,
                                   _panelContentSize.width + _panelContentInsets.left + _panelContentInsets.right,
                                   _panelContentSize.height + _panelContentInsets.top + _panelContentInsets.bottom);
    self.panelView.frame = panelFrame;
    [_panelView setShouldShowCloseButton:_shouldShowCloseButton];
    
    CGRect finalPanelFrame; //Only used for sliding animations
    float extraLeftInset = 0.0; //Only used for sliding animation from left
    
    if (_presentationMode == kTMPanelViewPresentationModeCenter) {
        
        panelFrame = [_panelView frameForCenterPositionInView:self.view];
        
        //Since we are going to present it, we want change its autoresizing view to stay centered
        contentView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        
    } else if (_presentationMode == kTMPanelViewPresentationModeRight) {
        
        finalPanelFrame = [_panelView frameForCenterRightPositionInView:self.view];
        //In this mode we want the panel to go all the way to the right side of the screen
        //so we need to make it so that it goes beyond the screen by increasing its width
        finalPanelFrame.size.width += 40.0;
        //But we want to start off the screen
        panelFrame = CGRectOffset(finalPanelFrame, finalPanelFrame.size.width, 0.0);
        
        //We also want it to be draggable
        [_panelView setDraggable:YES];
        [_panelView setVisibleFrame:finalPanelFrame];
        
        //Since we are going to present it, we want change its autoresizing view to stay on the left
        contentView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin);
        
    } else if (_presentationMode == kTMPanelViewPresentationModeLeft) {
        
        finalPanelFrame = [_panelView frameForCenterLeftPositionInView:self.view];
        //In this mode we want the panel to go all the way to the left side of the screen
        //so we need to make it so that it goes beyond the screen by increasing its width
        //and adjusting its origin
        finalPanelFrame.size.width += 40.0;
        finalPanelFrame.origin.x -=40.0;
        extraLeftInset = 40.0;
        //But we want to start off the screen
        panelFrame = CGRectOffset(finalPanelFrame, -finalPanelFrame.size.width, 0.0);
        
        //Since we are going to present it, we want change its autoresizing view to stay on the right
        contentView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin);
        
    }
    
    _panelView.frame = panelFrame;
    _panelView.delegate = self;
    _panelView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleBottomMargin);
    [self.view addSubview:_panelView];
    
    //Now we place the content view on the panel view
    CGRect contentViewFrame = CGRectMake(_panelContentInsets.left+extraLeftInset,
                                         _panelContentInsets.top,
                                         _panelContentSize.width,
                                         _panelContentSize.height);
    contentView.frame = contentViewFrame;
    
    //Containment stuff
    [self addChildViewController:_contentViewController];
    [_panelView addSubview:contentView];
    [_contentViewController didMoveToParentViewController:self];
    
    //Bring the close button to the front (in case the content view is over it)
    [_panelView bringSubviewToFront:(UIView*)_panelView.btnClose];
    
    _isPanelVisible = YES;
    
    //Setup our view
    [presenterView addSubview:self.view];
    [presenterView bringSubviewToFront:self.view];
    
    __weak TMPanelViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         TMPanelViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             
                             strongSelf->_backgroundView.alpha = 1.0;
                             if (strongSelf->_presentationMode == kTMPanelViewPresentationModeCenter) {
                                 [strongSelf->_panelView popFromInitialScale:0.9 fadeInFromInitialAlpha:0.0 duration:0.2];
                             } else if (strongSelf->_presentationMode == kTMPanelViewPresentationModeRight) {
                                 //Because we are going from left to right, we use a negative "x"
                                 [strongSelf->_panelView slideToFinalFrame:finalPanelFrame maxBounceOffset:CGPointMake(-20.0, 0.0) duration:0.3];
                             } else if (strongSelf->_presentationMode == kTMPanelViewPresentationModeLeft) {
                                 //Because we are going from right to left, we use a positive "x"
                                 [strongSelf->_panelView slideToFinalFrame:finalPanelFrame maxBounceOffset:CGPointMake(20.0, 0.0) duration:0.3];
                             }
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self registerForKeyboardNotifications];
}

#pragma mark -
#pragma mark TMTouchableViewDelegate

- (void)touchableViewDidReceiveTouch:(TMTouchableView *)view {
    
    //If we don't have a close button we can tap outside to close
    if (_isPanelVisible && !_shouldShowCloseButton) {
		if (!_delegate || [_delegate panelControllerShouldDismissPanel:self]) {
			[self dismissPanelAnimated:YES userInitiated:YES completion:NULL];
		}
	}
    
    //If one of our subviews is a first responder we dissmiss it
    if (_shouldDismissFirstResponderOnTapOnBackground && _keyboardShowing) {
        UIView *firstResponder = [_panelView findFirstResponder];
        if (firstResponder && [firstResponder canResignFirstResponder]) {
            [firstResponder resignFirstResponder];
        }
    }
}

#pragma mark -
#pragma mark TMPanelView delegate methods

- (void)panelViewDidPressCloseButton:(TMPanelView *)panelView {
    if (_isPanelVisible) {
		if (!_delegate || [_delegate panelControllerShouldDismissPanel:self]) {
			[self dismissPanelAnimated:YES userInitiated:YES completion:NULL];
		}
	}
}

- (void)panelViewDidHide:(TMPanelView *)panelView {
    //Method called when user closed the panel
     [self dismissPanelAnimated:YES userInitiated:YES completion:NULL];
}

#pragma mark -
#pragma mark Custom methods

- (UIView *)keyView {
	UIWindow *w = [[UIApplication sharedApplication] keyWindow];
	if (w.subviews.count > 0) {
		return [w.subviews objectAtIndex:0];
	} else {
		return w;
	}
}

- (void)dismissPanelAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    //This will only be called programatically
    [self dismissPanelAnimated:animated userInitiated:NO completion:completion];
}

- (void)dismissPanelAnimated:(BOOL)animated userInitiated:(BOOL)userInitiated completion:(void (^)(BOOL finished))completion {
    
    [self unregisterForKeyboardNotifications];
    
    float duration = (animated)?0.3:0.0;
    __weak TMPanelViewController *weakSelf = self;
    [UIView animateWithDuration:duration
                     animations:^{
                         TMPanelViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             if (strongSelf->_presentationMode == kTMPanelViewPresentationModeRight) {
                                 //Slide the panel to the right, off the screen (including shadow)
                                 CGRect frame = strongSelf->_panelView.frame;
                                 CGFloat xCoord = CGRectGetWidth(strongSelf.view.frame);
                                 frame.origin.x = xCoord + kTMDefaultShadowRadius;
                                 strongSelf->_panelView.frame = frame;
                                 //Fade out the background view
                                 strongSelf->_backgroundView.alpha = 0.0;
                             } else {
                                 strongSelf.view.alpha = 0.0;
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         TMPanelViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             [strongSelf.view removeFromSuperview];
                             
                             //If it was initiated by the user, inform the delegate
                             if (userInitiated) {
                                 [strongSelf->_delegate panelControllerDidDismissPanel:strongSelf];
                             }
                         }
                         
                         if (completion != NULL) {
                             completion(finished);
                         }
                         
                     }];
}

#pragma mark -
#pragma mark Keyboard notifications

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification {
    _keyboardShowing = YES;
    _yCoordShiftOnKeyboardAppear = 0.0;
    
    //Check if one of the panel's subviews is the first responder
    UIView *firstResponder = [_panelView findFirstResponder];
    if (firstResponder == nil) {
        return;
    }
    
	CGRect keyboardFrame;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardFrame];
	
	//The frame returned from the notification has a coordinate system with an origin on the top left corner
    //of the iPad as if the device were in portrait with the home button on the bottom
	//we need to rotate it to make its coordinate be in landscape mode
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
        keyboardFrame = CGRectApplyAffineTransform(keyboardFrame, CGAffineTransformMakeRotation(M_PI/2));
    } else {
        keyboardFrame = CGRectApplyAffineTransform(keyboardFrame, CGAffineTransformMakeRotation(-M_PI/2));
    }
    
    //Fix the x and y
    keyboardFrame.origin.x = 0.0;
    keyboardFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(keyboardFrame);
    
	//Get the intersection between the panel and the keyboard
    CGRect keyboardPanelIntersectionFrame = CGRectIntersection(_panelView.frame, keyboardFrame);
    if (CGRectIsNull(keyboardPanelIntersectionFrame)) {
        return;
    }
    //See if it covers the bottom of the text field
    CGFloat lastVisibleYCoordOnPanel = CGRectGetHeight(_panelView.frame) - CGRectGetHeight(keyboardPanelIntersectionFrame);
    CGPoint maxPointFirstResponder = CGPointMake(CGRectGetMaxX(firstResponder.frame), CGRectGetMaxY(firstResponder.frame));
    maxPointFirstResponder = [_panelView convertPoint:maxPointFirstResponder fromView:firstResponder.superview];
    if (lastVisibleYCoordOnPanel >= maxPointFirstResponder.y + TEXT_FIELD_KEYBOARD_PADDING) {
        return;
    }
    
    //Shift the panel up to still show the join text field
    CGFloat yOffset = maxPointFirstResponder.y - lastVisibleYCoordOnPanel + TEXT_FIELD_KEYBOARD_PADDING;
    _yCoordShiftOnKeyboardAppear = yOffset;
	CGRect frame = CGRectOffset(_panelView.frame, 0.0, -yOffset);
    __weak TMPanelViewController *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         TMPanelViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             strongSelf->_panelView.frame = frame;
                         }
                     }];
}

// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)aNotification {
	_keyboardShowing = NO;
    if (_yCoordShiftOnKeyboardAppear == 0.0) {
        return;
    }

    CGRect frame = CGRectOffset(_panelView.frame, 0.0, _yCoordShiftOnKeyboardAppear);
    __weak TMPanelViewController *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         TMPanelViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             strongSelf->_panelView.frame = frame;
                         }
                     }];
}

@end

#pragma mark -

@implementation UIViewController (TMPanelViewControllerItem) 

@dynamic panelController;

static char* panelControllerKey = "PanelController";

- (TMPanelViewController*)panelController {
    id result = objc_getAssociatedObject(self, panelControllerKey);
    if (!result && self.navigationController) 
        return [self.navigationController panelController];
    
    return result;
}

- (void)setPanelController:(TMPanelViewController *)panelController {
    objc_setAssociatedObject(self, panelControllerKey, panelController, OBJC_ASSOCIATION_RETAIN);
}

@end
