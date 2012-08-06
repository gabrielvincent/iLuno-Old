//
//  LoginViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 24/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVLoadingView.h"
#import "GVPlistPersistence.h"
#import "LoginSettingsViewController.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *loginWebView;
	IBOutlet UIView *loginView;
	IBOutlet UIView *formView;
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UIImageView *checkboxImageView;
	IBOutlet UIView *settingsView;
	
	BOOL hasAlreadyTriedToLogIn;
	BOOL shoulfRemoveLoadingFromSuperView;
	GVLoadingView *loadingView;
	NSOperationQueue *queue;
	GVPlistPersistence *plistManager;
	NSMutableArray *userDefaults;
	LoginSettingsViewController *loginSettingsViewController;
}

- (IBAction)hideKeyBoard:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)toggleCheckboxState:(id)sender;
- (IBAction)openSettings:(id)sender;
- (IBAction)closeSettings:(id)sender;

@end
