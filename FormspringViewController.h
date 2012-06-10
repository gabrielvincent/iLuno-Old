//
//  FormspringViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 08/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormspringViewController : UITableViewController <NSXMLParserDelegate> {
	
	NSMutableArray *questionsArray;
	NSString *idToKeepListing;
	NSOperationQueue *queue;
	UIColor *bgColor;
	BOOL isLoadingMore;
	UIView *messageView;
	UILabel *messageLabel;
	UIActivityIndicatorView *spinner;
}

@end
