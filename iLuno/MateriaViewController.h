//
//  MateriaViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 17/05/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVImageDownloader.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface MateriaViewController : UIViewController {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIImageView *bookImage;
	IBOutlet UILabel *labelProfessor;
	IBOutlet UILabel *staticLabelProfessor;
	IBOutlet UILabel *staticLabelDias;
	IBOutlet UILabel *labelDias;
	IBOutlet UILabel *labelLivroNome;
	IBOutlet UILabel *labelLivro;
	IBOutlet UILabel *staticLabelLivro;
	IBOutlet UIButton *downloadButton;
	IBOutlet UIImageView *underlineImageView;
	
	GVImageDownloader *imageDownloader;
	NSOperationQueue *queue;
	UIActivityIndicatorView *activityIndicator;
	UIImageView *postItImageView;
	
	Reachability* internetReachable;
	Reachability* hostReachable;
	BOOL connected;
}

@property NSString *unidade;
@property NSString *serie;
@property NSString *turma;
@property NSString *materia;
@property BOOL hasABook;
@property NSString *bookName;
@property NSString *bookFile;
@property NSString *professor;
@property NSString *dias;

- (IBAction)downloadCover:(id)sender;

@end
