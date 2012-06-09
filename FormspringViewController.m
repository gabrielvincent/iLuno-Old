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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) showMessageLoadingMoreQuestions {
	
	messageView.frame = CGRectMake(0, 400, 320, 1);
	messageLabel.frame = CGRectMake(10, 18, 320, 1);
	
	if (isLoadingMore) messageLabel.text = @"Carregando mais pergintas...";
	else messageLabel.text = @"Carregando perguntas...";
	
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

- (void) loadMoreQuestions {
	isLoadingMore = YES;
	
	[self performSelectorOnMainThread:@selector(showMessageLoadingMoreQuestions) withObject:nil waitUntilDone:NO];
	
	NSArray *tempArray = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/get-formspring-xml.php?url=deaaz.xml?max_id=%@", idToKeepListing]]];
	
	[questionsArray addObjectsFromArray:tempArray];
	idToKeepListing = [[questionsArray lastObject] objectForKey:@"id"];
	[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
}


- (void) callLoadMoreQuestions {
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadMoreQuestions)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) loadQuestions {
	questionsArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://iluno.com.br/plistgenerator/get-formspring-xml.php?url=deaaz.xml"]];
	idToKeepListing = [[questionsArray lastObject] objectForKey:@"id"];
	[self performSelectorOnMainThread:@selector(loadDidFinish) withObject:nil waitUntilDone:YES];
}

- (void) callLoadQuestions {
	[self showMessageLoadingMoreQuestions];
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadQuestions)  object:nil];
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
	titleLabel.text = @"Formspring";
	[titleLabel sizeToFit];
	
    self.navigationItem.title = @"Formspring";
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
	
	[self callLoadQuestions];
	
	nextOffsetToLoadMoreQuestions = 2326;
	
	
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.4];
	messageView.frame = CGRectMake(0, 400, 320, 1);
	messageView.alpha = 0.0;
	[UIView commitAnimations];
	
	[messageView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = bgColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
	text.font = [UIFont fontWithName:@"Helvetica-Oblique" size:18];
	text.text = [[questionsArray objectAtIndex:indexPath.row] objectForKey:@"question"];
	[tableView addSubview:text];
	
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
	
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

	
	//[self loadMoreQuestions];
}

@end
