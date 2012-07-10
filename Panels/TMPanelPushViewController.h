//
//  TMPanelPushViewController.h
//  TutorMe
//
//  Created by Emerson Malca on 6/9/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import "TMPanelViewController.h"

@interface TMPanelPushViewController : TMPanelViewController

@property(strong, nonatomic) NSArray *viewControllers; // The current view controller stack.

- (void)pushViewController:(UIViewController *)nextViewController;

@end

@interface UIViewController (TMPanelPushViewControllerItem)

@property(nonatomic,readonly,strong) TMPanelPushViewController *panelPushController; // If this view controller has been presented on a panel push controller, return it.

@end
