//
//  TwitterViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 08/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "GVLoadingView.h"

@interface TwitterViewController : UIViewController <UITableViewDataSource, UITabBarDelegate> {
	IBOutlet UITableViewCell *customCell;
	IBOutlet UITextView *tweetTextView;
	
	NSString *title;
	NSOperationQueue *queue;
	NSMutableArray *tweetsArray;
	NSString *idToKeepListing;
	BOOL isLoadingMore;
	BOOL isReloading;
	UIColor *bgColor;
	BOOL shouldLoadMoreOnInternetRecover;
	GVLoadingView *loadingView;
	
	BOOL connected;
	Reachability* internetReachable;
	Reachability* hostReachable;
}
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void) checkNetworkStatus:(NSNotification *)notice;

@end
