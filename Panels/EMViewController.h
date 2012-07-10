//
//  EMViewController.h
//  Panels
//
//  Created by Emerson Malca on 7/9/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMPanelViewController.h"

@interface EMViewController : UIViewController <TMPanelViewControllerDelegate>

@property (strong, nonatomic) TMPanelViewController *currentPanelController;

- (IBAction)showCenter:(id)sender;
- (IBAction)showLeft:(id)sender;
- (IBAction)showRight:(id)sender;

@end
