//
//  CalendariosViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 07/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendariosViewController : UITableViewController {
	NSArray *series;
	
	GVPlistPersistence *plistManager;
}

- (void) artificiallyPushViewControllerWithIndexPathRow:(NSInteger)indexPath;

@end
