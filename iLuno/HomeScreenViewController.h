//
//  HomeScreenViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 06/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorariosViewController.h"
#import "CalendariosViewController.h"
#import "MediasViewController.h"
#import "RedesSociaisViewController.h"
#import "ConfiguracoesViewController.h"
#import "CalendariosDetailViewController.h"
#import "MostraHorariosViewController.h"

@interface HomeScreenViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate, UIWebViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIView *vuashView;
	IBOutlet UIButton *returnToHomeButton;
	IBOutlet UIButton *horariosButton;
	IBOutlet UIImageView *shadowImage;
	IBOutlet UIImageView *menuImage;
	IBOutlet UIImageView *logoImage;
	IBOutlet UIImageView *higlightImage;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *serieTurmaLabel;
	IBOutlet UILabel *dateLabel;
	
	UINavigationController *navigation;
	UINavigationController *navigationHorarios;
	UINavigationController *navigationCalendarios;
	UINavigationController *navigationMedias;
	UINavigationController *navigationRedes;
	
	HorariosViewController *horarios;
	CalendariosViewController *calendarios;
	MediasViewController *medias;
	RedesSociaisViewController *redes;
	UIWebView *videos;
	ConfiguracoesViewController *configuracoes;
	GVPlistPersistence *plistManager;
	CalendariosDetailViewController *calendariosDetail;
	MostraHorariosViewController *mostraHorarios;
	
	NSString *iconId;
	NSString *previousId;
	UITapGestureRecognizer *tapRecognizer;
	UILongPressGestureRecognizer *longPressRecognizer;
	UIPanGestureRecognizer *panRecognizer;
	CGPoint firstPoint;
	NSMutableDictionary *subviewsDict;
	NSArray *userDefaultsArray;
	
	int scrollIndex;
	BOOL isFirstScroll;
	BOOL menuIsHidden;
	CGFloat persistentY;
	CGPoint point;
	CGFloat x;
	CGFloat y;
}

- (IBAction)returnToHomeScreen:(id)sender;
- (IBAction)highlightButton:(id)sender;

@end
