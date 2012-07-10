//
//  EMViewController.m
//  Panels
//
//  Created by Emerson Malca on 7/9/12.
//  Copyright (c) 2012 Luma Education. All rights reserved.
//

#import "EMViewController.h"
#import "EMGithubProfileViewController.h"

@interface EMViewController ()

@end

@implementation EMViewController

@synthesize currentPanelController=_currentPanelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

#pragma mark -
#pragma mark Action methods

- (IBAction)showCenter:(id)sender {
    
    EMGithubProfileViewController *profile = [[EMGithubProfileViewController alloc] initWithNibName:@"EMGithubProfileViewController" bundle:nil];
    _currentPanelController = [[TMPanelViewController alloc] initWithContentViewController:profile];
    [_currentPanelController setPanelContentInsets:UIEdgeInsetsZero];
    [_currentPanelController setDelegate:self];
    [_currentPanelController presentPanel];
}

- (IBAction)showLeft:(id)sender {
    EMGithubProfileViewController *profile = [[EMGithubProfileViewController alloc] initWithNibName:@"EMGithubProfileViewController" bundle:nil];
    _currentPanelController = [[TMPanelViewController alloc] initWithContentViewController:profile];
    [_currentPanelController setPanelContentInsets:UIEdgeInsetsZero];
    [_currentPanelController setDelegate:self];
    [_currentPanelController setShouldShowCloseButton:YES];
    [_currentPanelController setPresentationMode:kTMPanelViewPresentationModeLeft];
    [_currentPanelController presentPanel];
}

- (IBAction)showRight:(id)sender {
    EMGithubProfileViewController *profile = [[EMGithubProfileViewController alloc] initWithNibName:@"EMGithubProfileViewController" bundle:nil];
    _currentPanelController = [[TMPanelViewController alloc] initWithContentViewController:profile];
    [_currentPanelController setPanelContentInsets:UIEdgeInsetsZero];
    [_currentPanelController setDelegate:self];
    [_currentPanelController setPresentationMode:kTMPanelViewPresentationModeRight];
    [_currentPanelController presentPanel];
}

#pragma mark -
#pragma mark TMPanelViewControllerDelegate

- (BOOL)panelControllerShouldDismissPanel:(TMPanelViewController *)panelController {
    return YES;
}

- (void)panelControllerDidDismissPanel:(TMPanelViewController *)panelController {
    _currentPanelController = nil;
}

@end
