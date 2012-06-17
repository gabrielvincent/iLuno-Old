//
//  ControleDeNotasViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 16/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControleDeNotasViewController : UITableViewController {
	IBOutlet UIView *adicionarMateriaView;
	IBOutlet UITextField *materiaTextField;
	
	UIView *darkView;
	UITapGestureRecognizer *cancelGesture;
}

@end
