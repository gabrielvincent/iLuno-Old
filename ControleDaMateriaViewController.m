//
//  ControleDaMateriaViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 19/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define First 0
#define Second 1
#define Third 2

#import "ControleDaMateriaViewController.h"

@interface ControleDaMateriaViewController ()

@end

@implementation ControleDaMateriaViewController
@synthesize materia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setData {
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = materia;
	titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = materia;
	[titleLabel sizeToFit];
	
    scrollView.frame = CGRectMake(0, 0, 320, 367);
	scrollView.contentSize = CGSizeMake(320*3, 367);
	scrollView.delegate = self;
	
	[self setData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Scroll view delegate methods

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	currentPage = pageControl.currentPage;
}

- (void) scrollViewDidScroll:(UIScrollView *)ascrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [pageControl setCurrentPage:page];
}

@end
