//
//  CalendariosDetailViewController.h
//  _A_Z
//
//  Created by Gabriel Gino Vincent on 20/07/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class Reachability;

@interface CalendariosDetailViewController : UITableViewController {	
	IBOutlet UITableViewCell *customCell;
	IBOutlet UILabel *eventLabel;
	IBOutlet UILabel *weekdayLabel;
	IBOutlet UILabel *monthdayLabel;
	
	NSMutableArray *arrayEvents;
	NSDateFormatter *dateFormatter;
	UIColor *bgColor;
	UILabel *updateLabel;
	UILabel *lastUpdateLabel;
	BOOL shouldUpdate;
	BOOL isUpdating;
	UIImageView *updateImageView;
	NSOperationQueue *queue;
	UIActivityIndicatorView *spinner;
	GVPlistPersistence *plistManager;
	NSString *fileName;
	NSString *filePath;
	NSString *urlString;
	NSArray *userDefaults;
	NSInteger id_serie;
}
@property (nonatomic, strong) NSString *table;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger id_serie;

- (void) checkNetworkStatus:(NSNotification *)notice;
- (void) viewWillArtificiallyAppear;

@end
