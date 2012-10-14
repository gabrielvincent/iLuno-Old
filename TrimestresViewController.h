//
//  TrimestresViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 20/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVPlistPersistence.h"

@interface TrimestresViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UIView *deleteButtonsView;
	
	GVPlistPersistence *plistManager;
	NSMutableArray *arrayFields;
	NSString *fileName;
	BOOL deleteButtonIsReadyToDelete;
	UIButton *deleteButton;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *trimestreLabel;
@property (strong, nonatomic) NSString *trimestreString;
@property (strong, nonatomic) NSString *materiaString;

- (void)addFieldsForTrimester:(NSInteger)trimester OfSubject:(NSString *)subject;
- (void) didExitEditMode;
- (void) didEnterEditMode;

@end