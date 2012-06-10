//
//  TwitterViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 08/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "TwitterViewController.h"
#import "TweetViewController.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController
@synthesize title;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadDidFinish {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.4];
	messageView.frame = CGRectMake(0, 400, 320, 1);
	messageLabel.frame = CGRectMake(10, 18, 320, 0);
	messageView.alpha = 0.0;
	[UIView commitAnimations];
	
	[self.tableView reloadData];
	if (isLoadingMore) [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+80) animated:YES];
	[messageView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
	[spinner performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.4];
}

- (void) loadMoreTweets {
	isLoadingMore = YES;
	
	NSArray *tempArray = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/get-twitter-xml.php?id=%@", idToKeepListing]]];
	NSLog(@"URL: %@", [NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/get-twitter-xml.php?id=%@", idToKeepListing]);
	[tweetsArray addObjectsFromArray:tempArray];
	idToKeepListing = [[tweetsArray lastObject] objectForKey:@"id"];
	[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
}


- (void) callLoadMoreTweets {
	[self showMessageLoadingMoreTweets];
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadMoreTweets)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) showMessageLoadingMoreTweets {
	
	messageView.frame = CGRectMake(0, 400, 320, 1);
	messageLabel.frame = CGRectMake(10, 18, 320, 1);
	
	if (isLoadingMore) messageLabel.text = @"Carregando mais tweets...";
	else messageLabel.text = @"Carregando tweets...";
	
	if (spinner == nil) {
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		spinner.center = messageLabel.center;
		spinner.frame = CGRectMake(10, 20, spinner.frame.size.width, spinner.frame.size.height);
	}
	
	[spinner startAnimating];
	[messageView addSubview:spinner];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.4];
	messageView.frame = CGRectMake(0, 340, 320, 60);
	messageLabel.frame = CGRectMake(10, 18, 320, 21);
	messageView.alpha = 1.0;
	[UIView commitAnimations];
	
	messageView.backgroundColor = [UIColor blackColor];
	messageView.alpha = 0.8;
	[self.navigationController.view addSubview:messageView];
}

- (void) loadTweets {
	tweetsArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://iluno.com.br/plistgenerator/get-twitter-xml.php"]];
	idToKeepListing = [[tweetsArray lastObject] objectForKey:@"id"];
	[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
}

- (void) callLoadTweets {
	[self showMessageLoadingMoreTweets];
	
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
	titleLabel.text = title;
	[titleLabel sizeToFit];

    self.navigationItem.title = title;
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFDDD5B);
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 1)];
	messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 320, 21)];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.shadowColor = [UIColor blackColor];
	messageLabel.shadowOffset = CGSizeMake(0, -1);
	messageLabel.textAlignment = UITextAlignmentCenter;
	[messageView addSubview:messageLabel];
	
	isLoadingMore = NO;
	
	[self callLoadTweets];
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

#pragma mark - Table view data source

- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSInteger retInt = 0;
	if (!indexPath.section)
	{
		return indexPath.row;
	}
	for (int i = 0; i < indexPath.section; i++) {
		retInt += [tableView numberOfRowsInSection:i];
	}
	
	return retInt + indexPath.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
	text.font = [UIFont fontWithName:@"Helvetica" size:18];
	text.text = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"tweet"];
	[tableView addSubview:text];
	
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
	
	if (realRow % 2 == 0) {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	}
	else {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
	}
	
	if (realRow == [tweetsArray count]-1) {
		[self callLoadMoreTweets];
	}
	
//	cell.textLabel.text = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"tweet"];
//	cell.textLabel.numberOfLines = 0;
//	cell.textLabel.backgroundColor = [UIColor clearColor];
//	cell.textLabel.textColor = [UIColor whiteColor];
//	cell.textLabel.shadowColor = [UIColor blackColor];
//	cell.textLabel.shadowOffset = CGSizeMake(0, -1);
	
	for (UITextView *textView in cell.subviews) {
		[textView removeFromSuperview];
	}
	
	tweetTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, cell.frame.size.height+20)];
	tweetTextView.font = [UIFont fontWithName:@"Helvetica" size:18];
	tweetTextView.text = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"tweet"];
	tweetTextView.dataDetectorTypes = UIDataDetectorTypeLink;
	tweetTextView.backgroundColor = [UIColor clearColor];
	tweetTextView.textColor = [UIColor whiteColor];
	tweetTextView.editable = NO;
	tweetTextView.scrollEnabled = NO;
	[cell addSubview:tweetTextView];
	
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
	TweetViewController *tweet = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    
	tweet.tweet = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"tweet"];
	tweet.link = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"link"];
	tweet.date = [[tweetsArray objectAtIndex:indexPath.row] objectForKey:@"date"];
	
	[self.navigationController pushViewController:tweet animated:YES];

}

@end
