//
//  ControleDaMateriaViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 19/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControleDaMateriaViewController : UIViewController <UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
	IBOutlet UIScrollView *scrollView;
	
	UILabel *titleLabel;
	NSArray *arrayTrimestres;
}

@property (nonatomic, strong) NSString *materia;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *modelArray;

@end
