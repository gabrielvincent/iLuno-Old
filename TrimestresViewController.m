//
//  TrimestresViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 20/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "TrimestresViewController.h"

@interface TrimestresViewController ()

@end

@implementation TrimestresViewController
@synthesize trimestreLabel, trimestreString;

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
    self.trimestreLabel.text = self.trimestreString;
}

- (void)viewDidUnload
{
    [self setTrimestreLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
