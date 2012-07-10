//
//  EMAppDelegate.h
//  Panels
//
//  Created by Emerson Malca on 7/9/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMViewController;

@interface EMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EMViewController *viewController;

@end
