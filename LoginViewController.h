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

@interface LoginViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *loginWebView;
	IBOutlet UIView *loginView;
	IBOutlet UIView *formView;
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UIImageView *checkboxImageView;
	
	BOOL hasAlreadyTriedToLogIn;
	BOOL shoulfRemoveLoadingFromSuperView;
	GVLoadingView *loadingView;
	NSOperationQueue *queue;
	GVPlistPersistence *plistManager;
	NSMutableArray *userDefaults;
}

- (IBAction)hideKeyBoard:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)toggleCheckboxState:(id)sender;

@end
