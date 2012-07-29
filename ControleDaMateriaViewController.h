//
//  ControleDaMateriaViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 19/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControleDaMateriaViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
	IBOutlet UIButton *addButton;
	
	UILabel *titleLabel;
	NSArray *arrayTrimestres;
	BOOL isEditing;
	NSInteger currentTrimester;
}

@property (nonatomic, strong) NSString *materia;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *modelArray;

- (IBAction)addFields:(id)sender;

@end
