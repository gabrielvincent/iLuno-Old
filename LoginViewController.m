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

- (void) reloadWebView {
	
	[loadingView performSelectorOnMainThread:@selector(exitReloadModeWithMessage:) withObject:@"Fazendo login..." waitUntilDone:NO];
	
	if ([self internetIsConnected]) {
		loginWebView.delegate = self;
		[loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://deaaz.com.br"]]];
	}
	else {
		[loadingView enterReloadModeWithMessage:@"Recarregar"];
	}
}

- (void) callReloadWebView {
	queue = [NSOperationQueue new];
	NSInvocationOperation *reloadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(reloadWebView)  object:nil];
	[queue addOperation:reloadOperation];
}

- (void) loadWebView {
	if ([self internetIsConnected]) {
		loginWebView.delegate = self;
		[loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://deaaz.com.br"]]];
	}
	else {
		[loadingView enterReloadModeWithMessage:@"Recarregar"];
	}
}

- (void) callLoadWebView {
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadWebView)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) configureLoadingView {
	loadingView = [[GVLoadingView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
	loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
	loadingView.animationTime = 0.4;
	loadingView.delegate = (id)self;
	loadingView.messageLabel.text = @"Fazendo login...";
	loadingView.messageLabel.font = [UIFont boldSystemFontOfSize:14];
	loadingView.messageLabel.textColor = [UIColor whiteColor];
	loadingView.messageLabel.shadowOffset = CGSizeMake(0, -1);
	loadingView.messageLabel.ShadowColor = [UIColor blackColor];
	loadingView.reloadImage = [UIImage imageNamed:@"ReloadIcon.png"];
	loadingView.reloadMethod = @selector(callLoadWebView);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	hasAlreadyTriedToLogIn = NO;
	shoulfRemoveLoadingFromSuperView = NO;
	
	[self callLoadWebView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self configureLoadingView];
	[loadingView showWithAnimation:GVLoadingViewShowAnimationAppear];
}

- (BOOL) internetIsConnected {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gabrielvincent.com/CheckInternetConnection"]];  
    
	NSLog(@"Verifying...");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:8.0];      
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Verified!");
    
    return (output.length > 0) ? YES : NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark WebView delegate methods

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if (!hasAlreadyTriedToLogIn) {
		
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
		[loadingView dismissWithAnimation:GVLoadingViewDismissAnimationFade];
		
		loginWebView.userInteractionEnabled = YES;
	}
	
}

@end
