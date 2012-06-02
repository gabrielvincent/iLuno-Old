//
//  ConfiguracoesViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 23/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfiguracoesViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UITextField *nameTextField;
	IBOutlet UITextField *unidadeTextField;
	IBOutlet UITextField *serieTextField;
	IBOutlet UITextField *turmaTextField;
	IBOutlet UILabel *serieLabel;
	IBOutlet UILabel *turmaLabel;
	IBOutlet UIBarButtonItem *saveButton;
	IBOutlet UILabel *confirmationLabel;
	IBOutlet UIImageView *check;
	IBOutlet UIProgressView *progressView;
	IBOutlet UILabel *currentFileLabel;
	IBOutlet UILabel *percentageLabel;
	IBOutlet UIButton *downloadButton;
	
	NSMutableArray *dataArray;
	GVPlistPersistence *plistManager;
	
	NSArray *unidadeData;
	NSString *whatIsSelecting;
	NSArray *generalDataArray;
	NSMutableArray *turmasArray;
	NSMutableArray *seriesArray;
	NSArray *userDefaults;
	BOOL fieldsAreValid;
	NSOperationQueue *queue;
	BOOL shouldDismissViewController;
	NSMutableArray *alertData;
	UIPickerView *pickerView;
	UIToolbar *pickerViewToolBar;
	UILabel *pickerViewToolBarLabel;
}

- (IBAction)saveData:(id)sender AndShowConfirmation:(BOOL) shouldShowConfirmation;
- (IBAction)showUnidadeSelector:(id)sender;
- (IBAction)showSerieSelector:(id)sender;
- (IBAction)showTurmaSelector:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)callDownloadTheWholeShit:(id)sender;

@end
