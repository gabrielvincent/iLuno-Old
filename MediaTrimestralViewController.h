//
//  MediaTrimestralViewController.h
//  _A_Z
//
//  Created by Gabriel Gino Vincent on 11/23/10.
//  Copyright 2010 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MediaTrimestralViewController : UIViewController {
	IBOutlet UITextField *TM1TextField;
	IBOutlet UITextField *TM2TextField;
	IBOutlet UITextField *ATTextField;	
	IBOutlet UIScrollView *scrollView;
	IBOutlet UILabel *nota;
	IBOutlet UILabel *mediaTrimestralLabel;
	IBOutlet UIButton *ATHighlight;
}

- (IBAction)esconderOTeclado:(id)sender;
- (IBAction)calcularMediaTrimestral:(id)sender;
- (IBAction)TM1_TM2Next:(id)sender;
- (IBAction)TM2_ATNext:(id)sender;
- (IBAction)infoButton:(id)sender;
- (IBAction)validateString:(id)sender;

@end
