//
//  TwitterViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 08/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TwitterViewController : UITableViewController {
	IBOutlet UITableViewCell *customCell;
	IBOutlet UITextView *tweetTextView;
	
	NSString *title;
	NSOperationQueue *queue;
	NSMutableArray *tweetsArray;
	NSString *idToKeepListing;
	UIView *messageView;
	UILabel *messageLabel;
	BOOL isLoadingMore;
	UIActivityIndicatorView *spinner;
	UIColor *bgColor;
	BOOL shouldLoadMoreOnInternetRecover;
	
	BOOL connected;
	Reachability* internetReachable;
	Reachability* hostReachable;
}
@property (nonatomic, retain) NSString *title;

- (void) checkNetworkStatus:(NSNotification *)notice;

@end
