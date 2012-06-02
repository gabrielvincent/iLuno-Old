//
//  RedesSociaisViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 08/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "RedesSociaisViewController.h"
#import "TwitterViewController.h"

@interface RedesSociaisViewController ()

@end

@implementation RedesSociaisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) goToSocialNetwork:(UIPanGestureRecognizer *) sender {
	CGPoint tapPoint = [sender locationInView:self.view];
	float y = tapPoint.y;
	
	[self.view removeGestureRecognizer:pan];
	
	if (y <= 177) {
		TwitterViewController *twitter = [[TwitterViewController alloc] init];
		twitter.title = @"Twitter";
		[self.navigationController pushViewController:twitter animated:YES];
	}
	else {
		TwitterViewController *twitter = [[TwitterViewController alloc] init];
		twitter.title = @"Formspring";
		[self.navigationController pushViewController:twitter animated:YES];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = @"Redes Sociais";
	[titleLabel sizeToFit];
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	self.navigationItem.title = @"Redes Sociais";
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
	
	pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(goToSocialNetwork:)];
	[self.view addGestureRecognizer:pan];
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

@end
