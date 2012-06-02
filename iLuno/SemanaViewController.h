//
//  SemanaViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 06/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SemanaViewController : UITableViewController {
	NSArray *dias;
	NSDateFormatter *weekday;
	NSString *diaDaSemana;
}
@property NSString *serie;
@property NSString *unidade;
@property NSString *turma;
@property NSString *shouldPass;

@end
