//
//  TMPanelViewController.h
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTouchableView.h"
#import "TMPanelView.h"
#import "TMPanelViewConstants.h"

@protocol TMPanelViewControllerDelegate;

@interface TMPanelViewController : UIViewController <TMTouchableViewDelegate, TMPanelViewDelegate> {
    UIViewController *_contentViewController;
    CGSize _panelContentSize;
    UIEdgeInsets _panelContentInsets;
    BOOL _shouldShowCloseButton;
    TMPanelView *_panelView;
}

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) TMTouchableView *backgroundView;
@property (strong, nonatomic) TMPanelView *panelView;
@property (nonatomic) CGSize panelContentSize;
@property (nonatomic) UIEdgeInsets panelContentInsets;
@property (nonatomic) TMPanelViewPresentationMode presentationMode;
@property (nonatomic) BOOL shouldShowCloseButton;
@property (nonatomic) BOOL shouldDismissFirstResponderOnTapOnBackground;

@property (weak, nonatomic) id<TMPanelViewControllerDelegate> delegate;

- (id)initWithContentViewController:(UIViewController *)viewController;
- (void)presentPanel;
- (void)dismissPanelAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@protocol TMPanelViewControllerDelegate <NSObject>
@optional
- (BOOL)panelControllerShouldDismissPanel:(TMPanelViewController *)panelController;
- (void)panelControllerDidDismissPanel:(TMPanelViewController *)panelController;

@end

@interface UIViewController (TMPanelViewControllerItem)

@property(nonatomic,readonly,strong) TMPanelViewController *panelController; // If this view controller has been presented on a panel controller, return it.

@end
