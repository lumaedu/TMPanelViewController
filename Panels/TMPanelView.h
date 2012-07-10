//
//  TMPanelView.h
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTMDefaultShadowRadius    12.0

@class TMCloseButton;
@protocol TMPanelViewDelegate;

@interface TMPanelView : UIImageView

@property (nonatomic) BOOL shouldShowCloseButton;
@property (nonatomic) CGRect visibleFrame;
@property (nonatomic, getter = isDraggable) BOOL draggable;
@property (strong, nonatomic) TMCloseButton *btnClose;
@property (weak, nonatomic) id<TMPanelViewDelegate> delegate;

@end

@protocol TMPanelViewDelegate <NSObject>

- (void)panelViewDidPressCloseButton:(TMPanelView *)panelView;
- (void)panelViewDidHide:(TMPanelView *)panelView; //Only called when the user hid it

@end
