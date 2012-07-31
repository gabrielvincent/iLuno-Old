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

- (NSString *) simplifiedString:(NSString *)string {
	
//	string = [string lowercaseString];
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
	string = [string stringByReplacingOccurrencesOfString:@"í" withString:@"i"];
	string = [string stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
	string = [string stringByReplacingOccurrencesOfString:@"ú" withString:@"ú"];
	string = [string stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
	string = [string stringByReplacingOccurrencesOfString:@"ã" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"â" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"ê" withString:@"e"];
	string = [string stringByReplacingOccurrencesOfString:@"ô" withString:@"o"];
	string = [string stringByReplacingOccurrencesOfString:@"à" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"è" withString:@"e"];
	string = [string stringByReplacingOccurrencesOfString:@"ì" withString:@"i"];
	string = [string stringByReplacingOccurrencesOfString:@"ò" withString:@"ò"];
	string = [string stringByReplacingOccurrencesOfString:@"ù" withString:@"u"];
	string = [string stringByReplacingOccurrencesOfString:@"ñ" withString:@"n"];
	
	return string;
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(TrimestresViewController *)viewController trimestreString]];
    if(currentIndex == 0)
    {
        return nil;
    }
    TrimestresViewController *trimestresViewController = [[TrimestresViewController alloc] init];
    trimestresViewController.trimestreString = [self.modelArray objectAtIndex:currentIndex - 1];
	trimestresViewController.materiaString = [self simplifiedString:materia];
    return trimestresViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(TrimestresViewController *)viewController trimestreString]];
    if(currentIndex == self.modelArray.count-1)
    {
        return nil;
    }
    TrimestresViewController *trimestresViewController = [[TrimestresViewController alloc] init];
    trimestresViewController.trimestreString = [self.modelArray objectAtIndex:currentIndex + 1];
	trimestresViewController.materiaString = [self simplifiedString:materia];
	
    return trimestresViewController;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // If the page did not turn
    if (!completed)
    {
        // You do nothing because whatever page you thought
        // the book was on before the gesture started is still the correct page
        return;
    }
	
	currentTrimester = [[[[pvc.viewControllers objectAtIndex:0] trimestreString] stringByReplacingOccurrencesOfString:@"º Trimestre" withString:@""] integerValue];
	
    // This is where you would know the page number changed and handle it appropriately
}

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

#pragma mark ViewController methods

- (void) toggleEditMode {
	
	if (isEditing) {
		isEditing = NO;
		self.navigationItem.rightBarButtonItem.title = @"Editar";
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
		self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
		
		[UIView animateWithDuration:0.2 animations:^{
			addButton.alpha = 0.0;
		}];
		
		[[self.pageViewController.viewControllers objectAtIndex:0] didExitEditMode];
	}
	else {
		isEditing = YES;
		self.navigationItem.rightBarButtonItem.title = @"OK";
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
		self.view.gestureRecognizers = nil;
		
		[self.view bringSubviewToFront:addButton];
		[UIView animateWithDuration:0.2 animations:^{
			addButton.alpha = 1.0;
		}];
		
		[[self.pageViewController.viewControllers objectAtIndex:0] didEnterEditMode];
	}
	
}

- (IBAction)addFields:(id)sender {
	
	[[self.pageViewController.viewControllers objectAtIndex:0] addFieldsForTrimester:currentTrimester OfSubject:[self simplifiedString:materia]];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Editar" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEditMode)];
	
	isEditing = NO;
	currentTrimester = 1;
	
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
	contentViewController.materiaString = [self simplifiedString:materia];
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
