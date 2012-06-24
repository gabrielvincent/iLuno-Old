//
//  LoginViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 24/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *loginWebView;
	
	BOOL hasAlreadyTriedToLogIn;
	BOOL shoulfRemoveLoadingFromSuperView;
	LoadingView *loading;
}

@end
