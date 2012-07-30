//
//  TrimestresViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 20/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define DynamicContentSizeHeight (([arrayFields count]+(7-([arrayFields count]%7)))*40)+15
#define ScrollViewContentSizeHeight self.scrollView.contentSize.height
#define ScrollViewWidth self.scrollView.frame.size.width
#define ScrollViewHeight self.scrollView.frame.size.height
#define ScrollViewOriginX self.scrollView.frame.origin.x
#define ScrollViewOriginY self.scrollView.frame.origin.y

#import "TrimestresViewController.h"

@interface TrimestresViewController ()

@end

@implementation TrimestresViewController
@synthesize trimestreLabel, trimestreString, materiaString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark UITextField delegate methods 

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	self.scrollView.frame = CGRectMake(ScrollViewOriginX, ScrollViewOriginY, ScrollViewWidth, 157);
	if ([arrayFields count] > 7) self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeight);
	
	if (textField.frame.origin.y > 157) {
		
		[self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-67) animated:YES];
		
	}
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	
	int index;
	if (textField.tag%2 == 0) index = textField.tag/2;
	else index = (textField.tag-1)/2;
	NSMutableDictionary *fields = [arrayFields objectAtIndex:index];
	NSString *key;
	
	if (textField.tag%2 == 0) key = @"labelTextField";
	else key = @"gradeTextField";
	
	[arrayFields replaceObjectAtIndex:index withObject:fields];
	[plistManager setValue:textField.text ForKey:key ForEntryAtIndex:index InDatabase:fileName];
}

#pragma mark ViewController methods

- (void) didExitEditMode {
	
	[self.scrollView endEditing:YES];
	
	self.scrollView.frame = CGRectMake(ScrollViewOriginX, ScrollViewOriginY, ScrollViewWidth, 280);
	[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
	if ([arrayFields count] > 7) self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeight);
	
	// Makes the user interaction disabled for all TextFields
	for (NSDictionary *fields in arrayFields) {
		int evenTag = [[fields objectForKey:@"evenTag"] intValue];
		int oddTag = [[fields objectForKey:@"oddTag"] intValue];
		
		[(UITextField *)[self.scrollView viewWithTag:evenTag] setUserInteractionEnabled:NO];
		[(UITextField *)[self.scrollView viewWithTag:oddTag] setUserInteractionEnabled:NO];
	}
}

- (void) didEnterEditMode {
	// Makes the user interaction enabled for all TextFields
	for (NSDictionary *fields in arrayFields) {
		int evenTag = [[fields objectForKey:@"evenTag"] intValue];
		int oddTag = [[fields objectForKey:@"oddTag"] intValue];
		
		[(UITextField *)[self.scrollView viewWithTag:evenTag] setUserInteractionEnabled:YES];
		[(UITextField *)[self.scrollView viewWithTag:oddTag] setUserInteractionEnabled:YES];
	}
}

- (void) saveFieldsWithTag:(NSInteger)tag {
	
}

- (void)addFieldsForTrimester:(NSInteger)trimester OfSubject:(NSString *)subject {
	
	[UIView animateWithDuration:0.4 animations:^{
		self.scrollView.frame = CGRectMake(ScrollViewOriginX, ScrollViewOriginY, ScrollViewWidth, 157);
	}];
	
	if (![plistManager databaseAlreadyExistsWithName:fileName]) {
		[plistManager createNewDatabaseWithName:fileName];
		arrayFields = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
	}	
	
	NSMutableDictionary *fieldsDictionary = [[NSMutableDictionary alloc] init];
	
	// Sets the textFields
	UITextField *labelTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, ([arrayFields count]*40)+15, 182, 30)];
	labelTextField.font = [UIFont fontWithName:@"Noteworthy-Light" size:17];
	labelTextField.borderStyle = UITextBorderStyleNone;
	labelTextField.textColor = UIColorFromRGB(0x222222);
	labelTextField.tag = [arrayFields count]*2;
	labelTextField.delegate = self;
	
	UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, ([arrayFields count]*40)+15, 55, 30)];
	gradeTextField.text = @"0,00";
	gradeTextField.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17];
	gradeTextField.textAlignment = UITextAlignmentRight;
	gradeTextField.borderStyle = UITextBorderStyleNone;
	gradeTextField.tag = ([arrayFields count]*2)+1;
	gradeTextField.delegate = self;
	
	// Adds Them to the ScrollView
	[self.scrollView addSubview:labelTextField];
	[self.scrollView addSubview:gradeTextField];
	[labelTextField becomeFirstResponder];
	
	NSLog(@"Label: %d | Grade %d", labelTextField.tag, gradeTextField.tag);
	
	// Sets the dictionary
	[fieldsDictionary setValue:@"" forKey:@"labelTextField"];
	[fieldsDictionary setValue:@"0,00" forKey:@"gradeTextField"];
	[fieldsDictionary setValue:[NSNumber numberWithInteger:labelTextField.tag] forKey:@"evenTag"];
	[fieldsDictionary setValue:[NSNumber numberWithInteger:gradeTextField.tag] forKey:@"oddTag"];
	
	[plistManager addNewEntry:fieldsDictionary ToDatabase:fileName];
	
	// Saves to the array
	[arrayFields addObject:fieldsDictionary];
	
	NSLog(@"PercentSeven: %d", [arrayFields count]%7);
	if ([arrayFields count] > 7) self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeight);
	
}

- (void) setData {
	
	int i = 0;
	for (NSDictionary *fields in arrayFields) {
		
		// Sets the textFields
		UITextField *labelTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (i*40)+15, 182, 30)];
		labelTextField.font = [UIFont fontWithName:@"Noteworthy-Light" size:17];
		labelTextField.borderStyle = UITextBorderStyleNone;
		labelTextField.textColor = UIColorFromRGB(0x222222);
		labelTextField.tag = [[fields objectForKey:@"evenTag"] intValue];
		labelTextField.delegate = self;
		labelTextField.text = [fields objectForKey:@"labelTextField"];
		labelTextField.userInteractionEnabled = NO;
		
		UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, (i*40)+15, 55, 30)];
		gradeTextField.text = @"0,00";
		gradeTextField.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17];
		gradeTextField.textAlignment = UITextAlignmentRight;
		gradeTextField.borderStyle = UITextBorderStyleNone;
		gradeTextField.tag = [[fields objectForKey:@"oddTag"] intValue];
		gradeTextField.delegate = self;
		gradeTextField.text = [fields objectForKey:@"gradeTextField"];
		gradeTextField.userInteractionEnabled = NO;
		
		// Adds them to the superview
		[self.scrollView addSubview:labelTextField];
		[self.scrollView addSubview:gradeTextField];
		
		i++;
	}
	
	if ([arrayFields count] > 7) self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeight);
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.trimestreLabel.text = self.trimestreString;
	self.scrollView.frame = CGRectMake(51, 38, 262, 280);
	
	plistManager = [[GVPlistPersistence alloc] init];
	arrayFields = [[NSMutableArray alloc] init];
	
	NSString *currentTrimester = [self.trimestreString stringByReplacingOccurrencesOfString:@"º " withString:@""];
	fileName = [NSString stringWithFormat:@"CDN%@%@", currentTrimester, materiaString];
	
	if ([plistManager databaseAlreadyExistsWithName:fileName]) {
		arrayFields = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
		
		[self setData];
	}
}

- (void)viewDidUnload
{
    [self setTrimestreLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
