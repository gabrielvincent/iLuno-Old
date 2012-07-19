//
//  CalendariosDetailViewController.h
//  _A_Z
//
//  Created by Gabriel Gino Vincent on 20/07/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class Reachability;

@interface CalendariosDetailViewController : UITableViewController {	
	UILabel *eventoLabel;
	UILabel *diaDaSemanaLabel;
	UILabel *diaDoMesLabel;
	UIView *fillView;
	
	IBOutlet UIButton *atualizarButton;
	UITableViewCell *customCell;
	
    NSMutableArray *arrayLoaded;
	NSMutableArray *arrayEventos;
	NSArray *segments;
	NSOperationQueue *queue;
	UIActivityIndicatorView *spinner;
	GVPlistPersistence *plistManager;
	UIBarButtonItem *atualizar;
	UIBarButtonItem *atualizando;
	UILabel *updateLabel;
	UILabel *lastUpdateLabel;
	BOOL shouldUpdate;
	UIImageView *updateImageView;
	NSString *title;
	NSArray *userDefaults;
	UIActivityIndicatorView *activityIndicator;
	BOOL isUpdating;
	BOOL isDragging;
	
	int totalIndexPath;
	
	int FEV; NSMutableArray *arrayFEV;
	int MAR; NSMutableArray *arrayMAR;
	int ABR; NSMutableArray *arrayABR;
	int MAI; NSMutableArray *arrayMAI;
	int JUN; NSMutableArray *arrayJUN;
	int JUL; NSMutableArray *arrayJUL;
	int AGO; NSMutableArray *arrayAGO;
	int SET; NSMutableArray *arraySET;
	int OUT; NSMutableArray *arrayOUT;
	int NOV; NSMutableArray *arrayNOV;
	int DEZ; NSMutableArray *arrayDEZ;
	
	int backToBlack;
	
	NSMutableArray *arrayUpdate;
	NSMutableArray *currentArray;
	UIColor *bgColor;
	
	NSString *urlString;
	NSString *fileName;
	
	Reachability* internetReachable;
	Reachability* hostReachable;
	BOOL connected;
}
@property (nonatomic, strong) NSString *table;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *title;

- (void) checkNetworkStatus:(NSNotification *)notice;
- (void) viewWillArtificiallyAppear;

@end
