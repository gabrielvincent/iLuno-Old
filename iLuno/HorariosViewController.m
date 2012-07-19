//
//  HorariosViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 06/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//


#import "HorariosViewController.h"
#import "HomeScreenViewController.h"
#import "SemanaViewController.h"
#import "TurmaViewController.h"
#import "TurmaViewController.h"

@interface HorariosViewController ()

@end

@implementation HorariosViewController

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
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFDDD5B);
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	self.navigationItem.title = @"Horários";
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = @"Horários";
	[titleLabel sizeToFit];
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	plistManager = [[GVPlistPersistence alloc] init];
	userDefaults = [plistManager databaseWithName:@"UserDefaults"];
	
	if (userDefaults.count > 0) {
		NSString *unidade = [[userDefaults objectAtIndex:0] objectForKey:@"Unidade"];
		NSString *serie = [[userDefaults objectAtIndex:0] objectForKey:@"SerieLabel"];
		
		if (([unidade isEqualToString:@"Botafogo2"] && [serie isEqualToString:@"9º Ano"]) || ([unidade isEqualToString:@"Barra"] && [serie isEqualToString:@"3ª Série"]) || [serie isEqualToString:@"Monitorias"]) {
			SemanaViewController *semana = [[SemanaViewController alloc] initWithStyle:UITableViewStyleGrouped];
			semana.unidade = unidade;
			semana.serie = serie;
			semana.turma = nil;
			semana.shouldPass = @"YES";
			[self.navigationController pushViewController:semana animated:NO];
		}
		else {
			TurmaViewController *turma = [[TurmaViewController alloc] initWithStyle:UITableViewStyleGrouped];
			turma.unidade = [[userDefaults objectAtIndex:0] objectForKey:@"Unidade"];
			turma.serie = [[userDefaults objectAtIndex:0] objectForKey:@"SerieLabel"];
			turma.turma = [[userDefaults objectAtIndex:0] objectForKey:@"TurmaLabel"];
			turma.shouldPass = @"YES";
			[self.navigationController pushViewController:turma animated:NO];
		}
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
		case 0:
			dataBF1 = [[NSArray alloc] initWithObjects:@"Extensivo", @"Monitoria", nil];
			return [dataBF1 count];
			break;
		case 1:
			dataBF2 = [[NSArray alloc] initWithObjects:@"9º Ano", @"1ª Série", @"2ª Série", @"3ª Série", @"Monitoria", nil];
			return [dataBF2 count];
			break;
		case 2:
			dataBA = [[NSArray alloc] initWithObjects:@"3ª Série", @"Extensivo", @"Monitoria", nil];
			return [dataBA count];
			break;
		default:
			return 1;
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 25.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
	headerView.backgroundColor = [UIColor clearColor];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, -2, headerView.bounds.size.width, 30)];
	
	switch (section) {
		case 0:
			title = @"Botafogo 1";
			break;
		case 1:
			title = @"Botafogo 2";
			break;
		case 2:
			title = @"Barra";
			break;
		default:
			break;
	}
	label.text = title;
	[label setFont:[UIFont fontWithName:@"Helvetica Neue-CondensedBold" size:14]];
	label.textColor = UIColorFromRGB(0xFFCC00);
	label.shadowOffset = CGSizeMake(0, -1);
	label.shadowColor = [UIColor colorWithRed:0.203921569 green:0.203921569 blue:0.203921569 alpha:1.0];
	label.backgroundColor = [UIColor clearColor];
	
	[headerView addSubview:label];
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
    // Configure the cell...
    
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [dataBF1 objectAtIndex:indexPath.row];
			break;
		case 1:
			cell.textLabel.text = [dataBF2 objectAtIndex:indexPath.row];
			break;
		case 2:
			cell.textLabel.text = [dataBA objectAtIndex:indexPath.row];
			break;
		default:
			break;
	}
	
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = UIColorFromRGB(0xFFCC00);
	
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
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *unidade;
	NSArray *dataToReadFrom;
	switch (indexPath.section) {
		case 0:
			unidade = @"Botafogo 1";
			dataToReadFrom = dataBF1;
			break;
		case 1:
			unidade = @"Botafogo 2";
			dataToReadFrom = dataBF2;
			break;
		case 2:
			unidade = @"Barra";
			dataToReadFrom = dataBA;
			break;
		default:
			break;
	}
	
	if (([unidade isEqualToString:@"Botafogo 2"] && indexPath.row == 0) || ([unidade isEqualToString:@"Barra"] && indexPath.row == 0) || indexPath.row == dataToReadFrom.count-1) {
		SemanaViewController *semana = [[SemanaViewController alloc] initWithStyle:UITableViewStyleGrouped];
		semana.unidade = unidade;
		semana.serie = [dataToReadFrom objectAtIndex:indexPath.row];
		semana.turma = nil;
		[self.navigationController pushViewController:semana animated:YES];
	}
	else {
		TurmaViewController *turmaViewController = [[TurmaViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		turmaViewController.unidade = unidade;
		turmaViewController.serie = [dataToReadFrom objectAtIndex:indexPath.row];
		
		[self.navigationController pushViewController:turmaViewController animated:YES];
	}
	
}

@end
