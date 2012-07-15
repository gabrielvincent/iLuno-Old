//
//  FormspringViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 08/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "FormspringViewController.h"
#import "FormspringQuestionViewController.h"

@interface FormspringViewController ()

@end

@implementation FormspringViewController
@synthesize tableView, titleString;

- (void) dismissLoadingView {
	[loadingView dismissWithAnimation:GVLoadingViewDismissAnimationDisappear];
}

- (void) loadDidFinish {
	
	[self.tableView reloadData];
	if (isLoadingMore) [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+80) animated:YES];
}

- (void) loadMoreQuestions {
	
	if (isReloading) [loadingView performSelectorOnMainThread:@selector(exitReloadModeWithMessage:) withObject:@"Recarregando mais perguntas" waitUntilDone:NO];
	else loadingView.messageLabel.text = @"Carregando mais perguntas...";
	
	if ([self internetIsConnected]) {
		isLoadingMore = YES;
		
		NSArray *tempArray = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/get-formspring-xml.php?id=%@", idToKeepListing]]];
		
		[questionsArray addObjectsFromArray:tempArray];
		idToKeepListing = [[questionsArray lastObject] objectForKey:@"id"];
		[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(dismissLoadingView) withObject:nil waitUntilDone:NO];
		isReloading = NO;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"As perguntas não podem ser carregadas" message:@"Verifique sua conexão com a internet e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
		
		loadingView.reloadMethod = @selector(callLoadMoreQuestions);
		[loadingView performSelectorOnMainThread:@selector(enterReloadModeWithMessage:) withObject:@"Recarregar" waitUntilDone:NO];
		isReloading = YES;
	}
}


- (void) callLoadMoreQuestions {
	loadingView.messageLabel.text = @"Carregando mais perguntas...";
	[loadingView showWithAnimation:GVLoadingViewShowAnimationAppear];
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadMoreQuestions)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) loadQuestions {
	
	if (isReloading) [loadingView performSelectorOnMainThread:@selector(exitReloadModeWithMessage:) withObject:@"Recarregando perguntas..." waitUntilDone:NO];
	
	if ([self internetIsConnected]) {
		
		questionsArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://iluno.com.br/plistgenerator/get-formspring-xml.php"]];
		
		
		idToKeepListing = [[questionsArray lastObject] objectForKey:@"id"];
		[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(dismissLoadingView) withObject:nil waitUntilDone:NO];
		isReloading = NO;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"As perguntas não podem ser carregadas" message:@"Verifique sua conexão com a internet e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
		
		loadingView.reloadMethod = @selector(callLoadQuestions);
		[loadingView performSelectorOnMainThread:@selector(enterReloadModeWithMessage:) withObject:@"Recarregar" waitUntilDone:NO];
		isReloading = YES;
	}
}

- (void) callLoadQuestions {
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadQuestions)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) configureLoadingView {
	loadingView = [[GVLoadingView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
	loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
	loadingView.animationTime = 0.4;
	loadingView.delegate = (id)self;
	loadingView.message = @"Carregando perguntas...";
	loadingView.messageLabelFont = [UIFont boldSystemFontOfSize:14];
	loadingView.messageLabelColor = [UIColor whiteColor];
	loadingView.messageLabelShadowOffset = CGSizeMake(0, -1);
	loadingView.messageLabelShadowColor = [UIColor blackColor];
	loadingView.reloadImage = [UIImage imageNamed:@"ReloadIcon.png"];
	loadingView.reloadMethod = @selector(loadQuestions);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
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
	
    self.navigationItem.title = @"Formspring";
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFDDD5B);
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	isLoadingMore = NO;
	shouldLoadMoreOnInternetRecover = NO;
	isReloading = NO;
	
	// Atrasa a chamada do carregamento das perguntas para que dê tempo de verificar a conexão com a internet
	[self performSelector:@selector(callLoadQuestions) withObject:nil afterDelay:0.2];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	
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
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) internetIsConnected {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gabrielvincent.com/CheckInternetConnection"]];  
    
	NSLog(@"Verifying...");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:8.0];      
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Verified!");
    
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
//		if (!isLoadingMore && [questionsArray count] == 0) [self callLoadQuestions];
//		if (shouldLoadMoreOnInternetRecover) [self callLoadMoreQuestions];
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = bgColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
	text.font = [UIFont fontWithName:@"Helvetica-Oblique" size:18];
	text.text = [[questionsArray objectAtIndex:indexPath.row] objectForKey:@"question"];
	[self.tableView addSubview:text];
	
	CGFloat height = text.contentSize.height;
	[text removeFromSuperview];
	
	// Cell isn't selected so return single height
	return height+40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [questionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:self.tableView];
	
	if (realRow % 2 == 0) {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	}
	else {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
	}
	
	if (realRow == [questionsArray count]-1) {
		[self callLoadMoreQuestions];
	}
	
	cell.textLabel.text = [[questionsArray objectAtIndex:indexPath.row] objectForKey:@"question"];
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = UIColorFromRGB(0xFDDD5B);
	cell.textLabel.shadowColor = [UIColor blackColor];
	cell.textLabel.shadowOffset = CGSizeMake(0, -1);
	
	cell.detailTextLabel.text = [[questionsArray objectAtIndex:indexPath.row] objectForKey:@"answer"];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.shadowColor = [UIColor blackColor];
	cell.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
	
	UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    accessoryViewImage.center = CGPointMake(12, 25);
    [accessoryView addSubview:accessoryViewImage];
    [cell setAccessoryView:accessoryView];
	
	if (cell.subviews.count < 2) {
		UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
		separatorView.frame = CGRectMake(0, 0, 320, 9);
		[cell addSubview:separatorView];
	}
    
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

	FormspringQuestionViewController *question = [[FormspringQuestionViewController alloc] initWithNibName:@"FormspringQuestionViewController" bundle:nil];
	
	question.question = [[questionsArray objectAtIndex:indexPath.row] objectForKey:@"question"];
	question.answer = [[questionsArray objectAtIndex:indexPath.row] objectForKey:@"answer"];
	
	[self.navigationController pushViewController:question animated:YES];
}

@end
