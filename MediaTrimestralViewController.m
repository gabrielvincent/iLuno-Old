//
//  MediaTrimestralViewController.m
//  _A_Z
//
//  Created by Gabriel Gino Vincent on 11/23/10.
//  Copyright 2010 _A_Z. All rights reserved.
//

#define BadGradeColor UIColorFromRGB(0xFC452B)
#define GoodGradeColor UIColorFromRGB(0x3B44FF)

#import "MediaTrimestralViewController.h"


@implementation MediaTrimestralViewController

- (void)colorizeGrade {
	if (nota.text.floatValue >= 6.0) nota.textColor = GoodGradeColor;
	else nota.textColor = BadGradeColor;
}

- (IBAction)validateString:(id)sender {
	
	const char *tempString;
	
	if ([TM1TextField isFirstResponder]) {
		tempString = TM1TextField.text.UTF8String;
		if (tempString[TM1TextField.text.length-1] == ',') TM1TextField.text = [TM1TextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
		if (TM1TextField.text.length > 5) TM1TextField.text = [TM1TextField.text substringToIndex:5];
	}
	else if ([TM2TextField isFirstResponder]) {
		tempString = TM2TextField.text.UTF8String;
		if (tempString[TM2TextField.text.length-1] == ',') TM2TextField.text = [TM2TextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
		if (TM2TextField.text.length > 5) TM2TextField.text = [TM2TextField.text substringToIndex:5];
	}
	else if ([ATTextField isFirstResponder]) {
		tempString = ATTextField.text.UTF8String;
		if (tempString[ATTextField.text.length-1] == ',') ATTextField.text = [ATTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
		if (ATTextField.text.length > 5) ATTextField.text = [ATTextField.text substringToIndex:5];
	}
	
	
}

- (IBAction)infoButton:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"As notas inseridas em \"Teste A\" e \"Teste Z\" são referentes às notas de cada teste em 10. Exemplo:\nTeste A = 6 em 10\nTeste Z = 8 em 10\nMédia de teste = 7 em 10" delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
	[alert show];
}

- (void)viewDidLoad {
	
	TM1TextField.keyboardType = UIKeyboardTypeDecimalPad;
	TM2TextField.keyboardType = UIKeyboardTypeDecimalPad;
	ATTextField.keyboardType = UIKeyboardTypeDecimalPad;
	
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Limpar" style:UIBarButtonItemStyleBordered target:self action:@selector(clearButton:)];
    self.navigationItem.rightBarButtonItem = clearButton;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:253.0/255.0 green:221.0/255.0 blue:91.0/255.0 alpha:1.0];
	
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = @"Média Trimestral";
	[titleLabel sizeToFit];
	
	
	scrollView.frame = CGRectMake(0, 0, 320, 367);
	
	ATHighlight.center = ATTextField.center;
}

- (void) setElementsOpacity {
	mediaTrimestralLabel.alpha = 1.0;
	nota.alpha = 1.0;
	mediaTrimestralLabel.hidden = YES;
	nota.text = @"";
	
	TM1TextField.alpha = 1.0;
	TM2TextField.alpha = 1.0;
	ATTextField.alpha = 1.0;
	TM1TextField.text = @"";
	TM2TextField.text = @"";
    ATTextField.text = @"";
}

- (void)clearButton:(id)sender {
    
	
	[UIView beginAnimations:nil context:nil];
	TM1TextField.alpha = 0.0;
	TM2TextField.alpha = 0.0;
	ATTextField.alpha = 0.0;
	mediaTrimestralLabel.alpha = 0.0;
	nota.alpha = 0.0;
	[UIView setAnimationDuration:0.6f];
	[UIView commitAnimations];
	
	[self performSelector:@selector(setElementsOpacity) withObject:nil afterDelay:0.6];
}


- (IBAction)TM1_TM2Next:(id)sender{
	if ([TM1TextField isFirstResponder])
		[TM2TextField becomeFirstResponder];
}

-(IBAction)TM2_ATNext:(id)sender{
	if ([TM2TextField isFirstResponder])
		[ATTextField becomeFirstResponder];
}

- (IBAction)calcularMediaTrimestral:(id)sender{
	float TM1 = TM1TextField.text.floatValue;
	float TM2 = TM2TextField.text.floatValue;
	float AT = ATTextField.text.floatValue;
	
	float media = (((TM1 + TM2)/2)*4 + (AT*6)) / 10;
	
	NSString *mediaText = [[NSString alloc] initWithFormat:@"%.2f", media];
	
	if (TM1TextField.text.length != 0 && TM2TextField.text.length != 0 && ATTextField.text.length != 0) {
		mediaTrimestralLabel.hidden = NO;
		nota.text = mediaText;
	}
	
	[self colorizeGrade];
	[self esconderOTeclado:sender];
}

- (IBAction)esconderOTeclado:(id)sender {
    [TM1TextField resignFirstResponder];
	[TM2TextField resignFirstResponder];
	[ATTextField resignFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
