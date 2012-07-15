//
//  LoginViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 24/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define ViewWidth self.view.bounds.size.width
#define ViewHeight self.view.bounds.size.height

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) configureLoadingView {
	loadingView = [[GVLoadingView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
	loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
	loadingView.animationTime = 0.4;
	loadingView.delegate = (id)self;
	loadingView.message = @"Fazendo login...";
	loadingView.messageLabelFont = [UIFont boldSystemFontOfSize:14];
	loadingView.messageLabelColor = [UIColor whiteColor];
	loadingView.messageLabelShadowOffset = CGSizeMake(0, -1);
	loadingView.messageLabelShadowColor = [UIColor blackColor];
	loadingView.reloadImage = [UIImage imageNamed:@"ReloadIcon.png"];
	loadingView.reloadMethod = @selector(loadQuestions);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	hasAlreadyTriedToLogIn = NO;
	shoulfRemoveLoadingFromSuperView = NO;
	
	loginWebView.delegate = self;
	[loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://deaaz.com.br"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark WebView delegate methods

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if (!hasAlreadyTriedToLogIn) {
		[self configureLoadingView];
		[loadingView showWithAnimation:GVLoadingViewShowAnimationAppear];
	}
	
	return YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if (!hasAlreadyTriedToLogIn) {
		NSString *js = @"$('.login').val('nina.29.5@gmail.com');";
		[loginWebView stringByEvaluatingJavaScriptFromString:js];
		js = @"$('.senha').val('133364');";
		[loginWebView stringByEvaluatingJavaScriptFromString:js];
		[loginWebView stringByEvaluatingJavaScriptFromString:@"$('.btn-submit').click();"];
		hasAlreadyTriedToLogIn = YES;
		shoulfRemoveLoadingFromSuperView = YES;
	}
	else {
		[loadingView dismissWithAnimation:GVLoadingViewDismissAnimationDisappear];
		
		loginWebView.userInteractionEnabled = YES;
	}
	
}

@end
