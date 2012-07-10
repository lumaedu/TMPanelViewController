//
//  EMGithubProfileViewController.m
//  Panels
//
//  Created by Emerson Malca on 7/9/12.
//  Copyright (c) 2012 Emerson Malca. All rights reserved.
//

#import "EMGithubProfileViewController.h"

@interface EMGithubProfileViewController ()

@end

@implementation EMGithubProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.contentSizeForViewInPopover = self.view.bounds.size;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark Custom methods

- (void)viewTapped:(UITapGestureRecognizer *)tap {
    if ([tap state] == UIGestureRecognizerStateRecognized) {
        //The subtitle text should be the link
        NSURL *webURL = [NSURL URLWithString:@"https://github.com/emersonmalca"];
        [[UIApplication sharedApplication] openURL: webURL];
    }
}

@end
