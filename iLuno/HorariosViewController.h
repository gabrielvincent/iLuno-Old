//
//  HorariosViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 06/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorariosViewController : UITableViewController {
	NSArray *dataBF1;
	NSArray *dataBF2;
	NSArray *dataBA;
	NSString *title;
	
	GVPlistPersistence *plistManager;
	NSArray *userDefaults;
}

@end
