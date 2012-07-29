//
//  TrimestresViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 20/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

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

- (void) saveFieldsWithTag:(NSInteger)tag {
	
}

- (void)addFieldsForTrimester:(NSInteger)trimester OfSubject:(NSString *)subject {
	
	if (![plistManager databaseAlreadyExistsWithName:fileName]) {
		[plistManager createNewDatabaseWithName:fileName];
		arrayFields = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
	}
	
	
	NSMutableDictionary *fieldsDictionary = [[NSMutableDictionary alloc] init];
	
	// Sets the textFields
	UITextField *labelTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, ([arrayFields count]*40)+15, 182, 30)];
	labelTextField.font = [UIFont fontWithName:@"Noteworthy-Light" size:17];
	labelTextField.borderStyle = UITextBorderStyleNone;
	labelTextField.tag = [arrayFields count];
	
	UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, ([arrayFields count]*40)+15, 55, 30)];
	gradeTextField.text = @"0,00";
	gradeTextField.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17];
	gradeTextField.textAlignment = UITextAlignmentRight;
	gradeTextField.borderStyle = UITextBorderStyleNone;
	gradeTextField.tag = [arrayFields count]+1;
	
	// Adds Them to the ScrollView
	[self.scrollView addSubview:labelTextField];
	[self.scrollView addSubview:gradeTextField];
	[labelTextField becomeFirstResponder];
	
	if ([arrayFields count]%6 == 0) [labelTextField resignFirstResponder];
	
	// Sets the dictionary
	[fieldsDictionary setValue:@"" forKey:@"labelTextField"];
	[fieldsDictionary setValue:@"0,00" forKey:@"gradeTextField"];
	[fieldsDictionary setValue:[NSNumber numberWithInt:labelTextField.tag]forKey:@"evenTag"];
	[fieldsDictionary setValue:[NSNumber numberWithInt:gradeTextField.tag] forKey:@"oddTag"];
	
	// Saves to the array
	[arrayFields addObject:fieldsDictionary];
	
	self.scrollView.contentSize = CGSizeMake(262, labelTextField.frame.origin.y+labelTextField.frame.size.height);
	
	NSLog(@"Content: %f", scrollView.contentSize.height);
	
}

- (void) setData {
	
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
