//
//  TrimestresViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 17/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrimestresViewController : UITableViewController {
	UILabel *titleLabel;
	NSArray *arrayTrimestres;
}

@property (nonatomic, strong) NSString *materia;

@end
