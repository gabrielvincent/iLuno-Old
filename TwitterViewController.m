//
//  TwitterViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 08/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "TwitterViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TwitterViewController ()

@end

@implementation TwitterViewController
@synthesize titleString, tableView;

- (void) dismissLoadingView {
	[loadingView dismissWithAnimation:GVLoadingViewDismissAnimationDisappear];
}

- (void) loadDidFinish {
	
	[self.tableView reloadData];
	if (isLoadingMore) [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+80) animated:YES];
}

- (void) loadMoreTweets {
	
	if (isReloading) [loadingView performSelectorOnMainThread:@selector(exitReloadModeWithMessage:) withObject:@"Recarregando mais tweets..." waitUntilDone:NO];
	
	if ([self internetIsConnected]) {
		isLoadingMore = YES;
		
		NSArray *tempArray = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/get-twitter-xml.php?id=%@", idToKeepListing]]];
		NSLog(@"URL: %@", [NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/get-twitter-xml.php?id=%@", idToKeepListing]);
		[tweetsArray addObjectsFromArray:tempArray];
		idToKeepListing = [[tweetsArray lastObject] objectForKey:@"id"];
		[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(dismissLoadingView) withObject:nil waitUntilDone:NO];
		isReloading = NO;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Os tweets não podem ser carregados" message:@"Verifique sua conexão com a internet e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
		
		loadingView.reloadMethod = @selector(callLoadTweets);
		[loadingView performSelectorOnMainThread:@selector(enterReloadModeWithMessage:) withObject:@"Recarregar" waitUntilDone:NO];
		isReloading = YES;
	}
}


- (void) callLoadMoreTweets {
	loadingView.messageLabel.text = @"Carregando mais tweets...";
	[loadingView showWithAnimation:GVLoadingViewShowAnimationAppear];
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadMoreTweets)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) loadTweets {
	
	if (isReloading) [loadingView performSelectorOnMainThread:@selector(exitReloadModeWithMessage:) withObject:@"Recarregando tweets..." waitUntilDone:NO];
	
	if ([self internetIsConnected]) {
		tweetsArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://iluno.com.br/plistgenerator/get-twitter-xml.php"]];
		idToKeepListing = [[tweetsArray lastObject] objectForKey:@"id"];
		[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(dismissLoadingView) withObject:nil waitUntilDone:NO];
		isReloading = NO;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Os tweets não podem ser carregados" message:@"Verifique sua conexão com a internet e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
		
		loadingView.reloadMethod = @selector(callLoadTweets);
		[loadingView performSelectorOnMainThread:@selector(enterReloadModeWithMessage:) withObject:@"Recarregar" waitUntilDone:NO];
		isReloading = YES;
	}
}

- (void) callLoadTweets {
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadTweets)  object:nil];
	[queue addOperation:loadOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = titleString;
	[titleLabel sizeToFit];

    self.navigationItem.title = title;
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFDDD5B);
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	isLoadingMore = NO;
	shouldLoadMoreOnInternetRecover = NO;
	isReloading = NO;
	
	// Atrasa a chamada do carregamento dos tweets para que dê tempo de verificar a conexão com a internet
	[self performSelector:@selector(callLoadTweets) withObject:nil afterDelay:0.2];
}

- (void) viewWillAppear:(BOOL)animated {
	
	if (!loadingView) {
		[self configureLoadingView];
		[loadingView showWithAnimation:GVLoadingViewShowAnimationAppear];
	}
	
//	// check for internet connection
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
//	
//    internetReachable = [Reachability reachabilityForInternetConnection];
//    [internetReachable startNotifier];
//	
//    // check if a pathway to a random host exists
//    hostReachable = [Reachability reachabilityWithHostName: @"www.apple.com"];
//    [hostReachable startNotifier];
	
	[super viewWillAppear:animated];
}

- (void) configureLoadingView {
	loadingView = [[GVLoadingView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
	loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
	loadingView.animationTime = 0.4;
	loadingView.delegate = (id)self;
	loadingView.messageLabel.text = @"Carregando tweets...";
	loadingView.messageLabel.font = [UIFont boldSystemFontOfSize:14];
	loadingView.messageLabel.textColor = [UIColor whiteColor];
	loadingView.messageLabel.shadowOffset = CGSizeMake(0, -1);
	loadingView.messageLabel.ShadowColor = [UIColor blackColor];
	loadingView.reloadImage = [UIImage imageNamed:@"ReloadIcon.png"];
	loadingView.reloadMethod = @selector(loadTweets);
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

- (BOOL) internetIsConnected {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gabrielvincent.com/CheckInternetConnection"]];  
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:8.0];      
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    return (output.length > 0) ? YES : NO;
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
//    // called after network status changes
//    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
//	
//	if (internetStatus == NotReachable) {
//		NSLog(@"Internet is down.");
//		connected = NO;
//	}
//	else {
//		NSLog(@"Internet is up.");
//		connected = YES;
//		if (!isLoadingMore) [self callLoadTweets];
//		if (shouldLoadMoreOnInternetRecover) [self callLoadMoreTweets];
//	}
}

#pragma mark - Table view data source

- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSInteger retInt = 0;
	if (!indexPath.section)
	{
		return indexPath.row;
	}
	for (int i = 0; i < indexPath.section; i++) {
		retInt += [self.tableView numberOfRowsInSection:i];
	}
	
	return retInt + indexPath.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
	text.font = [UIFont fontWithName:@"Helvetica" size:18];
	text.text = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"tweet"];
	[self.tableView addSubview:text];
	
	CGFloat height = text.contentSize.height;
	[text removeFromSuperview];
	
	// Cell isn't selected so return single height
	return height+20;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = bgColor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tweetsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    static NSString *MyIdentifier = @"TwitterCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell"]];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:self options:nil];
		
        cell = customCell;
        customCell = nil;
    }
	
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:self.tableView];
	
	if (realRow % 2 == 0) {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	}
	else {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
	}
	
	if (realRow == [tweetsArray count]-1) {
		[self callLoadMoreTweets];
	}
	
	tweetTextView.text = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"tweet"];
	tweetTextView.frame = CGRectMake(10, 10, 300, tweetTextView.contentSize.height+40);
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
