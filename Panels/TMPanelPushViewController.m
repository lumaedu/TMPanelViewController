//
//  TMPanelPushViewController.m
//  TutorMe
//
//  Created by Emerson Malca on 6/9/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import "TMPanelPushViewController.h"
#import "UIView+Utilities.h"
#import "UIView+Positioning.h"
#import "UIView+ShowAnimations.h"
#import <objc/runtime.h>

@interface TMPanelPushViewController () {
    NSMutableArray *_viewControllers;
    UIImageView *_transitionView;
}

@end

@interface UIViewController (TMPanelPushViewControllerItem_Internal) 

// internal setter for the panelController property on UIViewController
- (void)setPanelPushController:(TMPanelPushViewController *)panelPushController;

@end

@implementation TMPanelPushViewController

@synthesize viewControllers=_viewControllers;

- (id)initWithContentViewController:(UIViewController *)viewController {
    if ((self = [super initWithContentViewController:viewController])) {
        
        //Create the array of view controllers
        _viewControllers = [NSMutableArray arrayWithCapacity:1];
        [_viewControllers addObject:viewController];
	}
	return self;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    
    if (_contentViewController == contentViewController) {
        return;
    }
    
    _contentViewController.panelPushController = nil;
    [super setContentViewController:contentViewController];
    _contentViewController.panelPushController = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)pushViewController:(UIViewController *)nextViewController {
    //Get the image of the panel view to animate out
    UIImage *image = [self.panelView screenshot];
    if (_transitionView == nil) {
        _transitionView = [[UIImageView alloc] initWithImage:image];
    } else {
        _transitionView.image = image;
    }
    _transitionView.frame = self.panelView.frame;
    [_transitionView copyShadowPropertiesFromView:self.panelView];
    [self.panelView.superview addSubview:_transitionView];
    
    //Animate the transition view out to the left
    CGRect finalTransitionFrame = _transitionView.frame;
    finalTransitionFrame.origin.x = 0.0 - CGRectGetWidth(finalTransitionFrame);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _transitionView.frame = finalTransitionFrame;
                     }
                     completion:^(BOOL finished){
                         [_transitionView removeFromSuperview];
                         _transitionView = nil;
                     }];
     
    //Prepare to remove the current content view controller's view from the panel view
    UIViewController *fromViewController = _contentViewController;
    self.contentViewController = nextViewController;
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:nextViewController];
    
    //Because we might have transparent views, we hide previous view
    fromViewController.view.hidden = YES;
    nextViewController.view.hidden = NO;
    
    //Prepare the panel view to hold the next view controller
    _panelContentSize = _contentViewController.contentSizeForViewInPopover;
    //The size of the panel will be the same of the content size + the insets
    CGRect panelFrame = CGRectMake(0.0, 
                                   0.0,
                                   _panelContentSize.width + _panelContentInsets.left + _panelContentInsets.right,
                                   _panelContentSize.height + _panelContentInsets.top + _panelContentInsets.bottom);
    _panelView.frame = panelFrame;
    //And will be positioned to the right of the screen
    panelFrame = [_panelView frameForCenterRightPositionInView:_panelView.superview];
    panelFrame.origin.x = CGRectGetWidth(_panelView.superview.frame);
    _panelView.frame = panelFrame;
    [_panelView setShouldShowCloseButton:_shouldShowCloseButton];
    
    //Now we place the content view on the panel view
    CGRect contentViewFrame = CGRectMake(_panelContentInsets.left,
                                         _panelContentInsets.top,
                                         _panelContentSize.width,
                                         _panelContentSize.height);
    nextViewController.view.frame = contentViewFrame;
    
    //Final position of panel will the the center of the screen
    CGRect finalPanelFrame = [_panelView frameForCenterPositionInView:_panelView.superview];
    
    __weak TMPanelPushViewController *weakSelf = self;
    [self transitionFromViewController:fromViewController
                      toViewController:nextViewController
                              duration:10.3
                               options:UIViewAnimationOptionCurveEaseOut 
                            animations:^{
                                
                                TMPanelPushViewController *strongSelf = weakSelf;
                                if (strongSelf) {
                                    [strongSelf->_panelView slideToFinalFrame:finalPanelFrame maxBounceOffset:CGPointMake(-60.0, 0.0) duration:0.3];
                                    //Bring the close button to the front (in case the content view is over it)
                                    [strongSelf->_panelView bringSubviewToFront:(UIView*)strongSelf->_panelView.btnClose];
                                }
                            }
                            completion:^(BOOL finished){
                                
                                TMPanelPushViewController *strongSelf = weakSelf;
                                if (strongSelf) {
                                    [nextViewController didMoveToParentViewController:strongSelf];
                                    [fromViewController removeFromParentViewController];
                                }
                                
                            }];
}

@end

#pragma mark -

@implementation UIViewController (TMPanelPushViewControllerItem) 

@dynamic panelPushController;

static char* panelPushControllerKey = "PanelPushController";

- (TMPanelPushViewController*)panelPushController {
    id result = objc_getAssociatedObject(self, panelPushControllerKey);
    if (!result && self.navigationController) 
        return [self.navigationController panelPushController];
    
    return result;
}

- (void)setPanelPushController:(TMPanelPushViewController *)panelPushController {
    objc_setAssociatedObject(self, panelPushControllerKey, panelPushController, OBJC_ASSOCIATION_RETAIN);
}

@end
