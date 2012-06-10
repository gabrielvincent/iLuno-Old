//
//  TwitterViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 08/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UITableViewController {
	NSString *title;
	NSOperationQueue *queue;
	NSMutableArray *tweetsArray;
	NSString *idToKeepListing;
	UIView *messageView;
	UILabel *messageLabel;
	BOOL isLoadingMore;
	UIActivityIndicatorView *spinner;
	UIColor *bgColor;
	UITextView *tweetTextView;
}
@property (nonatomic, retain) NSString *title;

@end
