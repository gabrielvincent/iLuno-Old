//
//  TrimestresViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 20/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define BadGradeColor UIColorFromRGB(0xFC452B)
#define GoodGradeColor UIColorFromRGB(0x3B44FF)
#define DynamicContentSizeHeight (([arrayFields count]+(7-([arrayFields count]%7)))*40)+15
#define DynamicContentSizeHeightWhenKeyboardIsActive (([arrayFields count]+(4-([arrayFields count]%4)))*40)+15
#define ScrollViewContentSizeHeight self.scrollView.contentSize.height
#define ScrollViewWidth self.scrollView.frame.size.width
#define ScrollViewHeight self.scrollView.frame.size.height
#define ScrollViewOriginX self.scrollView.frame.origin.x
#define ScrollViewOriginY self.scrollView.frame.origin.y
#define ViewWidth self.view.frame.size.width
#define ViewHeight self.view.frame.size.height
#define ViewOriginX self.view.frame.origin.x
#define ViewOriginY self.view.frame.origin.y
#define ThisTextField [(UITextField *)self.scrollView viewWithTag:tag]
#define ThisLabelTextField [(UITextField *)self.scrollView viewWithTag:evenTag]
#define ThisGradeTextField [(UITextField *)self.scrollView viewWithTag:oddTag]

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

#pragma mark Window methods

- (void) keyboardWasShown:(NSNotification *) notification {
	[UIView animateWithDuration:0.2 animations:^{
		self.view.frame = CGRectMake(ViewOriginX, ViewOriginY-4, ViewWidth, ViewHeight);
	}];
	
	self.scrollView.frame = CGRectMake(ScrollViewOriginX, ScrollViewOriginY, ScrollViewWidth, 160);
//	if ([arrayFields count] > 4) self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeightWhenKeyboardIsActive);
	if ([arrayFields count] > 4) self.scrollView.contentSize = CGSizeMake(0, ScrollViewContentSizeHeight+216);
}

- (void) keyboardWillBeHidden:(NSNotification *) notification {
	[UIView animateWithDuration:0.2 animations:^{
		self.view.frame = CGRectMake(ViewOriginX, ViewOriginY+4, ViewWidth, ViewHeight);
	}];
	
	self.scrollView.frame = CGRectMake(ScrollViewOriginX, ScrollViewOriginY, ScrollViewWidth, 280);
	if ([arrayFields count] > 7) self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeight);
}

#pragma mark UITextField delegate methods

- (void) textFieldDidChange:(UITextField *)textField {
	NSLog(@"Text: %@", textField.text);
	
	int grade = [textField.text floatValue];
	
	if (grade >= 6.0) textField.textColor = GoodGradeColor;
	else textField.textColor = BadGradeColor;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	
	int index;
	if (textField.tag%2 == 0) index = textField.tag/2;
	else index = (textField.tag-1)/2;
	NSMutableDictionary *fields = [arrayFields objectAtIndex:index];
	NSString *key;
	
	if (textField.tag%2 == 0) key = @"labelTextField";
	else {
		key = @"gradeTextField";
		int grade = [textField.text floatValue];
		
		// Colorizes the text, depending on the grade
		if (grade >= 6.0) textField.textColor = GoodGradeColor;
		else textField.textColor = BadGradeColor;
	}
	
	[arrayFields replaceObjectAtIndex:index withObject:fields];
	[plistManager setValue:textField.text ForKey:key ForEntryAtIndex:index InDatabase:fileName];
}

#pragma mark ViewController methods

- (void) didExitEditMode {
	
	[self.scrollView endEditing:YES];
	
	// Makes the user interaction disabled for all TextFields
	for (UIView *view in self.scrollView.subviews) {
		if ([view respondsToSelector:@selector(setTextColor:)]) {
			view.userInteractionEnabled = NO;
		}
	}
	
	int tag = deleteButton.tag;
	
	[UIView animateWithDuration:0.2 animations:^{
		deleteButtonsView.alpha = 0.0;
		deleteButtonsView.frame = CGRectMake(-25, 0, 46, 280);
		
		if (deleteButtonIsReadyToDelete) {
			deleteButton.frame = CGRectMake(308, deleteButton.frame.origin.y, 0, 36);
			deleteButton.alpha = 0.0;
			[(UIButton *)deleteButtonsView viewWithTag:deleteButton.tag-1].transform = CGAffineTransformMakeRotation(0);
			deleteButtonIsReadyToDelete = NO;
			ThisTextField.frame = CGRectMake(246, ThisTextField.frame.origin.y, 55, ThisTextField.frame.size.height);
			ThisTextField.alpha = 1.0;
		}
		
	} completion:^(BOOL finished){
		if (deleteButtonIsReadyToDelete) [deleteButton removeFromSuperview];
	}];
}

- (void) didEnterEditMode {
	// Makes the user interaction enabled for all TextFields
	for (UIView *view in self.scrollView.subviews) {
		if ([view respondsToSelector:@selector(setTextColor:)]) {
			view.userInteractionEnabled = YES;
		}
	}
	
	[UIView animateWithDuration:0.2 animations:^{
		deleteButtonsView.alpha = 1.0;
		deleteButtonsView.frame = CGRectMake(0, 0, 46, 280);
	}];
}

- (void) deleteFields {
	int evenTag = deleteButton.tag-1;
	int oddTag = deleteButton.tag;
	
	// Sets a differente Tag so it won't interfer with the other objects with that tag
	UIButton *deleteCircle  = (UIButton *)[deleteButtonsView viewWithTag:evenTag];
	deleteCircle.tag = -2;
	
	// Slides to the right
	[UIView animateWithDuration:0.2 animations:^{
		
		ThisLabelTextField.frame = CGRectMake(ThisLabelTextField.frame.origin.x+8, ThisLabelTextField.frame.origin.y, ThisLabelTextField.frame.size.width, ThisLabelTextField.frame.size.height);
		ThisGradeTextField.frame = CGRectMake(ThisGradeTextField.frame.origin.x+8, ThisGradeTextField.frame.origin.y, ThisGradeTextField.frame.size.width, ThisGradeTextField.frame.size.height);
		deleteButton.frame = CGRectMake(deleteButton.frame.origin.x+8, deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
		deleteCircle.frame = CGRectMake(deleteCircle.frame.origin.x+8, deleteCircle.frame.origin.y, deleteCircle.frame.size.width, deleteCircle.frame.size.height);
		
	}
	// Slides to the left and fades out
	completion:^(BOOL finished){
		
		[UIView animateWithDuration:0.2 animations:^{
			ThisLabelTextField.frame = CGRectMake(ThisLabelTextField.frame.origin.x-200, ThisLabelTextField.frame.origin.y, ThisLabelTextField.frame.size.width, ThisLabelTextField.frame.size.height);
			ThisGradeTextField.frame = CGRectMake(ThisGradeTextField.frame.origin.x-200, ThisGradeTextField.frame.origin.y, ThisGradeTextField.frame.size.width, ThisGradeTextField.frame.size.height);
			deleteButton.frame = CGRectMake(deleteButton.frame.origin.x-200, deleteButton.frame.origin.y, deleteButton.frame.size.width, deleteButton.frame.size.height);
			deleteCircle.frame = CGRectMake(deleteCircle.frame.origin.x-200, deleteCircle.frame.origin.y, deleteCircle.frame.size.width, deleteCircle.frame.size.height);
			
			ThisLabelTextField.alpha = 0.0;
			ThisGradeTextField.alpha = 0.0;
			deleteButton.alpha = 0.0;
			deleteCircle.alpha = 0.0;
			
		}
		 // Animate the remaining views 40px up
		completion:^(BOOL finished){
			
			[UIView animateWithDuration:0.2 animations:^{
				
				for (UIView *view in self.scrollView.subviews) {
					if (![view isEqual:deleteButtonsView] && view.tag > evenTag) {
						view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-40, view.frame.size.width, view.frame.size.height);
					}
				}
				
				for (UIView *view in deleteButtonsView.subviews) {
					if (![view isEqual:deleteButtonsView] && view.tag > evenTag) {
						view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-40, view.frame.size.width, view.frame.size.height);
					}
				}
				
			}
			 // Really remove the data
			completion:^(BOOL finished){
				
				[ThisLabelTextField removeFromSuperview];
				[ThisGradeTextField removeFromSuperview];
				
				[arrayFields removeObjectAtIndex:evenTag/2];
				[plistManager removeEntryAtIndex:evenTag/2 FromDatabase:fileName];
				
				// Cleans the deleteButtonsView
				for (UIView *view in deleteButtonsView.subviews) {
					[view removeFromSuperview];
				}
				
				// Cleans the scrollView
				for (UIView *view in self.scrollView.subviews) {
					if (![view isEqual:deleteButtonsView]) [view removeFromSuperview];
				}
				
				deleteButtonIsReadyToDelete = NO;
				
				[self reloadData];
				
			}];
		}];
	}];
}

- (void) toggleDeletionState:(UIView *) deleteCircle {
	
	int tag = deleteCircle.tag+1;
	
	// Second touch
	if (deleteButtonIsReadyToDelete) {
		
		for (UIView *view in deleteButtonsView.subviews) view.userInteractionEnabled = YES;
		
		[UIView animateWithDuration:0.2 animations:^{
			deleteCircle.transform = CGAffineTransformMakeRotation(0);
			deleteButton.frame = CGRectMake(308, deleteButton.frame.origin.y, 0, 36);
			ThisTextField.frame = CGRectMake(ThisTextField.frame.origin.x, ThisTextField.frame.origin.y, 55, ThisTextField.frame.size.height);
			ThisTextField.alpha = 1.0;
		}];
		deleteButtonIsReadyToDelete = NO;
	}
	// First touch
	else {
		deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[deleteButton setImage:[UIImage imageNamed:@"DeleteButton.png"] forState:UIControlStateNormal];
		deleteButton.frame = CGRectMake(308, 12, 0, 36);
		deleteButton.center = deleteCircle.center;
		deleteButton.frame = CGRectMake(308, deleteButton.frame.origin.y, 0, 36);
		deleteButton.tag = tag;
		[deleteButton addTarget:self action:@selector(deleteFields) forControlEvents:UIControlEventTouchUpInside];
		[self.scrollView addSubview:deleteButton];
		
		for (UIView *view in deleteButtonsView.subviews) {
			if (view.tag != deleteCircle.tag && [view isKindOfClass:[UIButton class]]) view.userInteractionEnabled = NO;
		}
		
		[UIView animateWithDuration:0.2 animations:^{
			deleteCircle.transform = CGAffineTransformMakeRotation(-M_PI/2);
			deleteButton.frame = CGRectMake(246, deleteButton.frame.origin.y, 62, 36);
			ThisTextField.frame = CGRectMake(ThisTextField.frame.origin.x, ThisTextField.frame.origin.y, 0, ThisTextField.frame.size.height);
			ThisTextField.alpha = 0.0;
		}];
		deleteButtonIsReadyToDelete = YES;
	}
}

- (void)addFieldsForTrimester:(NSInteger)trimester OfSubject:(NSString *)subject {
	
	if (![plistManager databaseAlreadyExistsWithName:fileName]) {
		[plistManager createNewDatabaseWithName:fileName];
		arrayFields = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
	}
	
	NSMutableDictionary *fieldsDictionary = [[NSMutableDictionary alloc] init];
	
	// Cancels any started deletion
	if (deleteButtonIsReadyToDelete) {
		[UIView animateWithDuration:0.2 animations:^{
			int tag = deleteButton.tag;
			deleteButton.frame = CGRectMake(308, deleteButton.frame.origin.y, 0, 36);
			deleteButton.alpha = 0.0;
			[(UIButton *)deleteButtonsView viewWithTag:deleteButton.tag-1].transform = CGAffineTransformMakeRotation(0);
			deleteButtonIsReadyToDelete = NO;
			ThisTextField.frame = CGRectMake(246, ThisTextField.frame.origin.y, 55, ThisTextField.frame.size.height);
			ThisTextField.alpha = 1.0;
		}];
	}
	
	// Sets the textFields
	UITextField *labelTextField = [[UITextField alloc] initWithFrame:CGRectMake(56, ([arrayFields count]*40)+15, 182, 30)];
	labelTextField.font = [UIFont fontWithName:@"Noteworthy-Light" size:17];
	labelTextField.placeholder = @"avaliação";
	labelTextField.borderStyle = UITextBorderStyleNone;
	labelTextField.textColor = UIColorFromRGB(0x222222);
	labelTextField.tag = [arrayFields count]*2;
	labelTextField.delegate = self;
	
	UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(246, ([arrayFields count]*40)+15, 55, 30)];
	gradeTextField.placeholder = @"nota";
	gradeTextField.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17];
	gradeTextField.textAlignment = UITextAlignmentRight;
	gradeTextField.borderStyle = UITextBorderStyleNone;
	gradeTextField.tag = ([arrayFields count]*2)+1;
	gradeTextField.delegate = self;
	[gradeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	// Adds Them to the ScrollView
	[self.scrollView addSubview:labelTextField];
	[self.scrollView addSubview:gradeTextField];
	[labelTextField becomeFirstResponder];
	
	// Adds the delete buttons
	UIButton *deleteCircle = [UIButton buttonWithType:UIButtonTypeCustom];
	[deleteCircle setImage:[UIImage imageNamed:@"DeleteCircle.png"] forState:UIControlStateNormal];
	deleteCircle.frame = CGRectMake(0, 0, 46, 36);
	deleteCircle.center = labelTextField.center;
	deleteCircle.frame = CGRectMake(0, deleteCircle.frame.origin.y, 46, 36);
	deleteCircle.tag = labelTextField.tag;
	deleteCircle.imageView.tag = -2; // Sets an unused tag so it won't interer with the views that really need this tag set
	[deleteCircle addTarget:self action:@selector(toggleDeletionState:) forControlEvents:UIControlEventTouchUpInside];
	deleteCircle.userInteractionEnabled = YES;
	
	[deleteButtonsView addSubview:deleteCircle];
	
	// Sets the dictionary
	[fieldsDictionary setValue:@"" forKey:@"labelTextField"];
	[fieldsDictionary setValue:@"" forKey:@"gradeTextField"];
	
	[plistManager addNewEntry:fieldsDictionary ToDatabase:fileName];
	
	// Saves to the array
	[arrayFields addObject:fieldsDictionary];
	
	// Sets the new contentSize
	self.scrollView.contentSize = CGSizeMake(308, DynamicContentSizeHeightWhenKeyboardIsActive);
	if ((labelTextField.tag/2)%4 == 0) [self.scrollView setContentOffset:CGPointMake(0, ScrollViewContentSizeHeight-216) animated:YES];
	
}

- (void) reloadData {
	[self setData];
	
	// Makes the user interaction enabled for all TextFields
	for (UIView *view in self.scrollView.subviews) {
		if ([view respondsToSelector:@selector(setTextColor:)]) {
			view.userInteractionEnabled = YES;
		}
	}
}

- (void) setData {
	
	int i = 0;
	for (NSDictionary *fields in arrayFields) {
		
		// Sets the textFields
		UITextField *labelTextField = [[UITextField alloc] initWithFrame:CGRectMake(56, (i*40)+15, 182, 30)];
		labelTextField.font = [UIFont fontWithName:@"Noteworthy-Light" size:18];
		labelTextField.borderStyle = UITextBorderStyleNone;
		labelTextField.textColor = UIColorFromRGB(0x222222);
		labelTextField.tag = i*2;
		labelTextField.delegate = self;
		labelTextField.text = [fields objectForKey:@"labelTextField"];
		labelTextField.userInteractionEnabled = NO;
		labelTextField.placeholder = @"avaliação";
		
		UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(246, (i*40)+15, 55, 30)];
		gradeTextField.text = @"0,00";
		gradeTextField.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17];
		gradeTextField.textAlignment = UITextAlignmentRight;
		gradeTextField.borderStyle = UITextBorderStyleNone;
		gradeTextField.tag = (i*2)+1;
		gradeTextField.delegate = self;
		gradeTextField.text = [fields objectForKey:@"gradeTextField"];
		gradeTextField.userInteractionEnabled = NO;
		gradeTextField.placeholder = @"nota";
		gradeTextField.keyboardType = UIKeyboardTypeDecimalPad;
		[gradeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
		
		int grade = [gradeTextField.text floatValue];
		
		// Colorizes the text, depending on the grade
		if (grade >= 6.0) gradeTextField.textColor = GoodGradeColor;
		else gradeTextField.textColor = BadGradeColor;
		
		// Adds them to the superview
		[self.scrollView addSubview:labelTextField];
		[self.scrollView addSubview:gradeTextField];
		
		// Adds the delete buttons
		UIButton *deleteCircle = [UIButton buttonWithType:UIButtonTypeCustom];
		[deleteCircle setImage:[UIImage imageNamed:@"DeleteCircle.png"] forState:UIControlStateNormal];
		deleteCircle.frame = CGRectMake(0, 0, 46, 36);
		deleteCircle.center = labelTextField.center;
		deleteCircle.frame = CGRectMake(0, deleteCircle.frame.origin.y, 46, 36);
		deleteCircle.tag = labelTextField.tag;
		deleteCircle.imageView.tag = -2; // Sets an unused tag so it won't interer with the views that really need this tag set
		[deleteCircle addTarget:self action:@selector(toggleDeletionState:) forControlEvents:UIControlEventTouchUpInside];
		
		[deleteButtonsView addSubview:deleteCircle];
		
		// Adds the objects to the arrayTextFields
		NSMutableDictionary *textFieldsDictionary = [[NSMutableDictionary alloc] init];
		
		[textFieldsDictionary setValue:labelTextField forKey:@"labelTextFields"];
		[textFieldsDictionary setValue:gradeTextField forKey:@"gradesTextField"];
		
		i++;
	}
	
	self.scrollView.contentSize = CGSizeMake(0, DynamicContentSizeHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.trimestreLabel.text = self.trimestreString;
	self.scrollView.frame = CGRectMake(0, 38, 308, 280);
	
	plistManager = [[GVPlistPersistence alloc] init];
	arrayFields = [[NSMutableArray alloc] init];
	
	NSString *currentTrimester = [self.trimestreString stringByReplacingOccurrencesOfString:@"º " withString:@""];
	fileName = [NSString stringWithFormat:@"CDN%@%@", currentTrimester, materiaString];
	
	if ([plistManager databaseAlreadyExistsWithName:fileName]) {
		arrayFields = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
		
		[self setData];
	}
	
	deleteButtonIsReadyToDelete = NO;
	
}

- (void) viewWillAppear:(BOOL)animated {
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:self.view.window];
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