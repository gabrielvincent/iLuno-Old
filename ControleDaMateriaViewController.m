//
//  ControleDaMateriaViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 19/07/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define First 0
#define Second 1
#define Third 2

#import "ControleDaMateriaViewController.h"
#import "TrimestresViewController.h"

@interface ControleDaMateriaViewController ()

@end

@implementation ControleDaMateriaViewController
@synthesize materia, pageViewController, modelArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setData {
	
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(TrimestresViewController *)viewController trimestreString]];
	NSLog(@"IndexBefore: %d", currentIndex);
    if(currentIndex == 0)
    {
        return nil;
    }
    TrimestresViewController *trimestresViewController = [[TrimestresViewController alloc] init];
    trimestresViewController.trimestreString = [self.modelArray objectAtIndex:currentIndex - 1];
    return trimestresViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(TrimestresViewController *)viewController trimestreString]];
	NSLog(@"IndexAfter: %d", currentIndex);
    if(currentIndex == self.modelArray.count-1)
    {
        return nil;
    }
    TrimestresViewController *trimestresViewController = [[TrimestresViewController alloc] init];
    trimestresViewController.trimestreString = [self.modelArray objectAtIndex:currentIndex + 1];
	
    return trimestresViewController;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        //Set the array with only 1 view controller
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        //Important- Set the doubleSided property to NO.
        self.pageViewController.doubleSided = NO;
        //Return the spine location
        return UIPageViewControllerSpineLocationMin;
    }
    else
    {
        NSArray *viewControllers = nil;
        TrimestresViewController *trimestresViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        
        NSUInteger currentIndex = [self.modelArray indexOfObject:[(TrimestresViewController *)trimestresViewController trimestreString]];
        if(currentIndex == 0 || currentIndex %2 == 0)
        {
            UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:trimestresViewController];
            viewControllers = [NSArray arrayWithObjects:trimestresViewController, nextViewController, nil];
        }
        else
        {
            UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:trimestresViewController];
            viewControllers = [NSArray arrayWithObjects:previousViewController, trimestresViewController, nil];
        }
        //Now, set the viewControllers property of UIPageViewController
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
		
        return UIPageViewControllerSpineLocationMid;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Instantiate the model array
    self.modelArray = [[NSMutableArray alloc] init];
    for (int index = 1; index <= 3 ; index++)
    {
        [self.modelArray addObject:[NSString stringWithFormat:@"%dº Trimestre",index]];
    }
	
	//Step 1
    //Instantiate the UIPageViewController.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl 
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    //Step 2:
    //Assign the delegate and datasource as self.
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    //Step 3:
    //Set the initial view controllers.
    TrimestresViewController *contentViewController = [[TrimestresViewController alloc] initWithNibName:@"TrimestresViewController" bundle:nil];
    contentViewController.trimestreString = [self.modelArray objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [self.pageViewController setViewControllers:viewControllers 
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO 
                                     completion:nil];
	
	//Step 4:
    //ViewController containment steps
    //Add the pageViewController as the childViewController
    [self addChildViewController:self.pageViewController];
    
    //Add the view of the pageViewController to the current view
    [self.view addSubview:self.pageViewController.view];
	
    //Call didMoveToParentViewController: of the childViewController, the UIPageViewController instance in our case.
    [self.pageViewController didMoveToParentViewController:self];    
	
    //Step 5:
    // set the pageViewController's frame as an inset rect.
    self.pageViewController.view.frame = CGRectMake(0, 0, 320, 354);
	self.pageViewController.view.center = self.view.center;
    
    //Step 6:
    //Assign the gestureRecognizers property of our pageViewController to our view's gestureRecognizers property.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;

	
	self.navigationItem.title = materia;
	titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = materia;
	[titleLabel sizeToFit];
	
    scrollView.frame = CGRectMake(0, 0, 320, 367);
	scrollView.contentSize = CGSizeMake(320*3, 367);
	scrollView.delegate = self;
	
	[self setData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
