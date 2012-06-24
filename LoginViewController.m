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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	loading = [[LoadingView alloc] initWithLabel:@"Fazendo Login..."];
	
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark WebView delegate methods

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if (!hasAlreadyTriedToLogIn) {
		loginWebView.userInteractionEnabled = NO;
		
		loading.frame = CGRectMake(0, ViewHeight, ViewWidth, 40);
		loading.alpha = 0,0;
		[self.view addSubview:loading];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		loading.frame = CGRectMake(0, ViewHeight-40, ViewWidth, 40);
		loading.alpha = 1.0;
		[UIView commitAnimations];
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
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		loading.frame = CGRectMake(0, ViewHeight, ViewWidth, 0);
		loading.alpha = 0.0;
		[UIView commitAnimations];
		
		[loading performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
		
		loginWebView.userInteractionEnabled = YES;
	}
/*	
	[UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
	}
	completion:^(BOOL finished) {
	}];
*/
	
}

@end
