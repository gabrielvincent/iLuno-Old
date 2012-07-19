//
//  MateriaViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 17/05/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "MateriaViewController.h"

@interface MateriaViewController ()

@end

@implementation MateriaViewController
@synthesize unidade, serie, turma, hasABook, bookFile, bookName, professor, dias, materia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) alert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Não há conexão com a Internet" message:@"A atualização não pôde ser feita" 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

-(IBAction)downloadCover:(id)sender {
	
	if (connected) {
		postItImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downloading-post-it.png"]];
		postItImageView.center = bookImage.center;
		[scrollView addSubview:postItImageView];
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[activityIndicator startAnimating];
		activityIndicator.center = postItImageView.center;
		activityIndicator.frame = CGRectMake(activityIndicator.frame.origin.x, activityIndicator.frame.origin.y+25, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
		[scrollView addSubview:activityIndicator];
		
		[scrollView setContentOffset:CGPointMake(220, 0) animated:YES];
		
		int fromNumber = 8;
		int toNumber = 14;
		int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
		postItImageView.transform = CGAffineTransformMakeRotation(3.14/randomNumber);
		
		[self callDownloadBook];
	}
	else [self performSelectorInBackground:@selector(alert) withObject:nil];
}

- (void) downloadBook {
	
	[imageDownloader downloadImageFromURL:[NSString stringWithFormat:@"http://iluno.com.br/plists/BookImages/%@.png", bookFile] AndSaveItWithFileName:bookFile WithFormat:@"png"];
	[bookImage performSelectorOnMainThread:@selector(setImage:) withObject:[imageDownloader pickExistentImageWithFileName:bookFile] waitUntilDone:YES];
	[postItImageView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
	[activityIndicator performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
	[downloadButton performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
	[underlineImageView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
}

- (void) callDownloadBook {
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *downloadBookOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(downloadBook)  object:nil];
	[queue addOperation:downloadBookOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    scrollView.frame = CGRectMake(0, 0, 320, 367);
	scrollView.contentSize = CGSizeMake(550, 380);
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(1, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = materia;
	[titleLabel sizeToFit];
	
	imageDownloader = [[GVImageDownloader alloc] init];
	
	[bookImage setImage:[imageDownloader pickExistentImageWithFileName:bookFile]];
	
	if (bookImage.image) downloadButton.hidden = underlineImageView.hidden = YES;
	
	bookImage.layer.shadowColor = [[UIColor blackColor] CGColor];
	bookImage.layer.shadowOffset = CGSizeMake(1, 1);
	bookImage.layer.shadowOpacity = 0.7f;
	bookImage.layer.shadowRadius = 3.0f;
	
	int fromNumber = 8;
	int toNumber = 14;
	int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
	
	bookImage.transform = CGAffineTransformMakeRotation(3.14/randomNumber);
	
	labelProfessor.text = professor;
	labelDias.text = dias;
	labelLivroNome.text = bookName;
	
	labelProfessor.font = labelDias.font = labelLivroNome.font = [UIFont fontWithName:@"Dakota" size:18];
	downloadButton.titleLabel.font = [UIFont fontWithName:@"Dakota" size:14];
	staticLabelDias.font = staticLabelLivro.font = staticLabelProfessor.font = [UIFont fontWithName:@"Dakota" size:18];
	
	if ([bookName isEqualToString:@""]) {
		labelLivro.hidden = YES;
		scrollView.contentSize = CGSizeMake(340, 380);
		downloadButton.hidden = YES;
		underlineImageView.hidden = YES;
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
	
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName: @"www.apple.com"];
    [hostReachable startNotifier];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	
	if (internetStatus == NotReachable) {
		NSLog(@"Internet is down.");
		connected = NO;
	}
	else {
		NSLog(@"Internet is up.");
		connected = YES;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
