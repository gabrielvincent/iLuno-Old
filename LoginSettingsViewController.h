//
//  LoginSettingsViewController.h
//  iLuno
//
//  Created by Gabriel Gino Vincent on 05/08/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVPlistPersistence.h"

@interface LoginSettingsViewController : UIViewController {
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UIImageView *checkboxImageView;
	IBOutlet UIView *formView;
	
	GVPlistPersistence *plistManager;
	NSMutableArray *userDefaults;
}

- (IBAction)hideKeyboard:(id)sender;
- (BOOL) fieldsAreValid;
- (IBAction)toggleCheckboxState:(id)sender;

@end
