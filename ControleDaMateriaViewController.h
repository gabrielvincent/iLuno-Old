//
//  ControleDaMateriaViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 19/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControleDaMateriaViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	
	UILabel *titleLabel;
	NSArray *arrayTrimestres;
	int currentPage;
}

@property (nonatomic, strong) NSString *materia;

@end
