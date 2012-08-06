//
//  LoginViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 24/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define ViewWidth self.view.bounds.size.width
#define ViewHeight self.view.bounds.size.height
#define Database @"LoginUserDefaults"
#define Unchecked 0
#define Checked 1

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

- (void) keyboardWasShown:(NSNotification *) notification {
	[UIView animateWithDuration:0.4 animations:^{
		formView.transform = CGAffineTransformMakeTranslation(0, -80);
	}];
}

- (void) keyboardWillBeHidden:(NSNotification *) notification {
	[UIView animateWithDuration:0.4 animations:^{
		formView.transform = CGAffineTransformMakeTranslation(0, 0);
	}];
}

- (IBAction)closeSettings:(id)sender {
	
	if ([loginSettingsViewController fieldsAreValid]) {
		[UIView animateWithDuration:0.4 animations:^{
			settingsView.transform = CGAffineTransformMakeTranslation(0, 0);
			loginWebView.frame = CGRectMake(0, 0, 320, 401);
		} completion:^(BOOL finished) {
			[loginSettingsViewController.view removeFromSuperview];
		}];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Preencha todos os campos corretamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
}

- (IBAction)openSettings:(id)sender {
	
	settingsView.frame = CGRectMake(0, -401, 320, 401);
	[self.view addSubview:settingsView];
	[settingsView addSubview:loginSettingsViewController.view];
	
	[UIView animateWithDuration:0.4 animations:^{
		settingsView.transform = CGAffineTransformMakeTranslation(0, 401);
		loginWebView.frame = CGRectMake(0, 401, 320, 0.0001);
	}];
}

- (IBAction)toggleCheckboxState:(id)sender {
	
	if (checkboxImageView.tag == Unchecked) {
		checkboxImageView.image = [UIImage imageNamed:@"CheckedCheckbox.png"];
		checkboxImageView.tag = Checked;
	}
	else if (checkboxImageView.tag == Checked) {
		checkboxImageView.image = [UIImage imageNamed:@"UncheckedCheckbox.png"];
		checkboxImageView.tag = Unchecked;
	}
	
}

- (IBAction)login:(id)sender {
	[loadingView showWithAnimation:GVLoadingViewShowAnimationAppear];
	
	[self callLoadWebView];
	
	if (checkboxImageView.tag == Checked) {
		[[userDefaults objectAtIndex:0] setValue:[NSNumber numberWithBool:YES] forKey:@"AutoLogin"];
		[[userDefaults objectAtIndex:0] setValue:usernameTextField.text	forKey:@"Username"];
		[[userDefaults objectAtIndex:0] setValue:passwordTextField.text	forKey:@"Password"];
		[plistManager overwriteDatabase:Database WithArray:userDefaults];
	}
}

- (IBAction)hideKeyBoard:(id)sender {
	[sender resignFirstResponder];
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
	[usernameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	
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
	
	plistManager = [[GVPlistPersistence alloc] init];
	userDefaults = [[NSMutableArray alloc] init];
	loginSettingsViewController = [[LoginSettingsViewController alloc] initWithNibName:@"LoginSettingsViewController" bundle:nil];
	
	[self addChildViewController:loginSettingsViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:self.view.window];
	
	[self configureLoadingView];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (![plistManager databaseAlreadyExistsWithName:Database]) {
		[plistManager createNewDatabaseWithName:Database];
		NSMutableDictionary *defaults = [[NSMutableDictionary alloc] init];
		[defaults setValue:[NSNumber numberWithBool:NO] forKey:@"AutoLogin"];
		[defaults setValue:@"" forKey:@"Username"];
		[defaults setValue:@"" forKey:@"Password"];
		[userDefaults addObject:defaults];
		[plistManager overwriteDatabase:Database WithArray:userDefaults];
	}
	
	userDefaults = [NSMutableArray arrayWithArray:[plistManager databaseWithName:Database]];
	
	if ([[[userDefaults objectAtIndex:0] objectForKey:@"AutoLogin"] boolValue]) {
		usernameTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"Username"];
		passwordTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"Password"];
		checkboxImageView.image = [UIImage imageNamed:@"CheckedCheckbox.png"];
		[loadingView showWithAnimation:GVLoadingViewShowAnimationFade];
		[self callLoadWebView];
	}
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
// Nina
// Username: nina.29.5@gmail.com
// Password: 133364

// Iunes
// Username:
// Password:

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if (!hasAlreadyTriedToLogIn) {
		NSString *js = [NSString stringWithFormat:@"$('.login').val('%@');", usernameTextField.text];
		[loginWebView stringByEvaluatingJavaScriptFromString:js];
		js = [NSString stringWithFormat:@"$('.senha').val('%@');", passwordTextField.text];
		[loginWebView stringByEvaluatingJavaScriptFromString:js];
		[loginWebView stringByEvaluatingJavaScriptFromString:@"$('.btn-submit').click();"];
		hasAlreadyTriedToLogIn = YES;
		shoulfRemoveLoadingFromSuperView = YES;
	}
	else {
		[loadingView dismissWithAnimation:GVLoadingViewDismissAnimationFade];
		
		loginWebView.userInteractionEnabled = YES;
		
		NSString *verificationString = [webView stringByEvaluatingJavaScriptFromString:@"$('.clearfix > h1').html();"];
		if ([verificationString isEqualToString:@"Página não encontrada"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Falha no login" message:@"Verifique seu nome usuário e senha" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
		else {
			[UIView animateWithDuration:0.4 animations:^{
				loginView.transform = CGAffineTransformMakeTranslation(0, 411);
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.4 animations:^{
					loginView.alpha = 0.0;
				}];
			}];
		}
	}
	
}

@end
