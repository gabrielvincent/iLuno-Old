//
//  CalendariosViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 07/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "CalendariosViewController.h"
#import "CalendariosDetailViewController.h"

@interface CalendariosViewController ()

@end

@implementation CalendariosViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	plistManager = [[GVPlistPersistence alloc] init];
	NSString *indexPath = [NSString stringWithFormat:@"%@", [plistManager valueOfKey:@"CalendariosIndexPath" ForEntryAtIndex:0 FromDatabase:@"UserDefaults"]];
	[self artificiallyPushViewControllerWithIndexPathRow:indexPath.intValue];
	
    series = [NSArray arrayWithObjects:@"9º Ano", @"1ª Série", @"2ª Série", @"3ª Série", @"Extensivo", nil];
	
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
	titleLabel.text = @"Calendários";
	[titleLabel sizeToFit];
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	self.navigationItem.title = @"Calendários";
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.backgroundView = backgroundView;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor lightGrayColor];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [series count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
	cell.textLabel.text = [series objectAtIndex:indexPath.row];
	cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
	
	cell.backgroundColor = [UIColor clearColor];
	
	UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    accessoryViewImage.center = CGPointMake(12, 25);
    [accessoryView addSubview:accessoryViewImage];
    [cell setAccessoryView:accessoryView];
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

- (void) artificiallyPushViewControllerWithIndexPathRow:(NSInteger)indexPath {
	CalendariosDetailViewController *detailViewController = [[CalendariosDetailViewController alloc] init];
	
	switch (indexPath) {
		case 0:
			detailViewController.table = @"Cal9Ano";
			detailViewController.fileName = @"Cal9Ano";
			detailViewController.title = @"9º Ano";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal9Ano";
			break;
		case 1:
			detailViewController.fileName = @"Cal1Serie";
			detailViewController.title = @"1ª Série";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal1Serie";
			break;
		case 2:
			detailViewController.fileName = @"Cal2Serie";
			detailViewController.title = @"2ª Série";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal2Serie";
			break;
		case 3:
			detailViewController.fileName = @"Cal3Serie";
			detailViewController.title = @"3ª Série";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal3Serie";
			break;
		case 4:
			detailViewController.fileName = @"CalExtensivo";
			detailViewController.title = @"Extensivo";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=CalExtensivo";
			break;
			
		default:
			break;
	}
	[self.navigationController pushViewController:detailViewController animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CalendariosDetailViewController *detailViewController = [[CalendariosDetailViewController alloc] init];
	
	switch (indexPath.row) {
		case 0:
			detailViewController.table = @"Cal9Ano";
			detailViewController.fileName = @"Cal9Ano";
			detailViewController.title = @"9º Ano";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal9Ano";
			break;
		case 1:
			detailViewController.fileName = @"Cal1Serie";
			detailViewController.title = @"1ª Série";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal1Serie";
			break;
		case 2:
			detailViewController.fileName = @"Cal2Serie";
			detailViewController.title = @"2ª Série";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal2Serie";
			break;
		case 3:
			detailViewController.fileName = @"Cal3Serie";
			detailViewController.title = @"3ª Série";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=Cal3Serie";
			break;
		case 4:
			detailViewController.fileName = @"CalExtensivo";
			detailViewController.title = @"Extensivo";
			detailViewController.urlString = @"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=CalExtensivo";
			break;
			
		default:
			break;
	}
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
