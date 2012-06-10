//
//  TweetViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 09/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController {
	IBOutlet UITextView *tweetTextView;
}

@property (nonatomic, retain) NSString *tweet;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *date;

@end
