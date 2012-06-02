//
//  MostraHorariosViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 13/05/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface MostraHorariosViewController : UITableViewController {
	NSMutableArray *dataArray;
	
	NSString *fileName;
	NSString *tableURL;
	UILabel *updateLabel;
	UILabel *lastUpdateLabel;
	UIImageView *updateImageView;
	BOOL shouldUpdate;
	NSOperationQueue *queue;
	GVPlistPersistence *plistManager;
	UIView *darkView;
	UIActivityIndicatorView *activityView;
	BOOL isUpdating;
	UIActivityIndicatorView *spinner;
	
	Reachability* internetReachable;
	Reachability* hostReachable;
	BOOL connected;
	
}
@property NSString *unidade;
@property NSString *serie;
@property NSString *turma;
@property NSString *diaDaSemana;

@end
