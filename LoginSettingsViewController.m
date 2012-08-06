//
//  LoginSettingsViewController.m
//  iLuno
//
//  Created by Gabriel Gino Vincent on 05/08/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define Database @"LoginUserDefaults"
#define Unchecked 0
#define Checked 1

#import "LoginSettingsViewController.h"

@interface LoginSettingsViewController ()

@end

@implementation LoginSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) fieldsAreValid {
	
	if (checkboxImageView.tag == Checked) {
		if (usernameTextField.text.length == 0 || passwordTextField.text.length == 0) return NO;
	}
	else {
		usernameTextField.text = @"";
		passwordTextField.text = @"";
	}
	
	[[userDefaults objectAtIndex:0] setValue:usernameTextField.text forKey:@"Username"];
	[[userDefaults objectAtIndex:0] setValue:passwordTextField.text forKey:@"Password"];
	[[userDefaults objectAtIndex:0] setValue:[NSNumber numberWithBool:checkboxImageView.tag] forKey:@"AutoLogin"];
	
	[plistManager overwriteDatabase:Database WithArray:userDefaults];
	
	return YES;
}

- (IBAction)hideKeyboard:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)toggleCheckboxState:(id)sender {
	
	NSLog(@"Tag: %d", checkboxImageView.tag);
	
	if (checkboxImageView.tag == Unchecked) {
		checkboxImageView.image = [UIImage imageNamed:@"CheckedCheckbox.png"];
		checkboxImageView.tag = Checked;
	}
	else if (checkboxImageView.tag == Checked) {
		checkboxImageView.image = [UIImage imageNamed:@"UncheckedCheckbox.png"];
		checkboxImageView.tag = Unchecked;
		usernameTextField.text = @"";
		passwordTextField.text = @"";
	}
	
}

- (void) setData {
	if ([[[userDefaults objectAtIndex:0] objectForKey:@"Username"] length] > 0) {
		usernameTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"Username"];
		passwordTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"Password"];
		
		if ([[[userDefaults objectAtIndex:0] objectForKey:@"AutoLogin"] boolValue]) checkboxImageView.image = [UIImage imageNamed:@"CheckedCheckbox.png"];
		else checkboxImageView.image = [UIImage imageNamed:@"UncheckedCheckbox"];
	}
	
	checkboxImageView.tag = [[[userDefaults objectAtIndex:0] objectForKey:@"AutoLogin"] boolValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.frame = CGRectMake(0, 44, 320, 357);
	
	plistManager = [[GVPlistPersistence alloc] init];
	userDefaults = [[NSMutableArray alloc] init];
	
	userDefaults = [NSMutableArray arrayWithArray:[plistManager databaseWithName:Database]];
	
	[self setData];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	
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
