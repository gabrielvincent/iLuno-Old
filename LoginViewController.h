//
//  LoginViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 24/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVLoadingView.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *loginWebView;
	
	BOOL hasAlreadyTriedToLogIn;
	BOOL shoulfRemoveLoadingFromSuperView;
	GVLoadingView *loadingView;
}

@end
