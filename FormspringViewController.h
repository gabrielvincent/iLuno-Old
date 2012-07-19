//
//  FormspringViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 08/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "GVLoadingView.h"

@interface FormspringViewController : UIViewController <NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate> {
	
	NSMutableArray *questionsArray;
	NSString *idToKeepListing;
	NSOperationQueue *queue;
	UIColor *bgColor;
	BOOL isLoadingMore;
	BOOL shouldLoadMoreOnInternetRecover;
	BOOL isReloading;
	GVLoadingView *loadingView;
	
	BOOL connected;
	Reachability* internetReachable;
	Reachability* hostReachable;
}

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void) checkNetworkStatus:(NSNotification *)notice;

@end
