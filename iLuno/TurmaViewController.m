//
//  TurmaViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 13/05/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "TurmaViewController.h"
#import "SemanaViewController.h"

@interface TurmaViewController ()

@end

@implementation TurmaViewController
@synthesize turma, serie, unidade, shouldPass;

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
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	self.navigationItem.title = @"Turma";
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = serie;
	[titleLabel sizeToFit];
	
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.backgroundView = backgroundView;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	if ([unidade isEqualToString:@"Botafogo 1"] || [unidade isEqualToString:@"Botafogo1"]) dataArray = [NSArray arrayWithObjects:@"Manhã A", @"Manhã B", @"Tarde", @"Noite", nil];
	else if ([unidade isEqualToString:@"Botafogo 2"] || [unidade isEqualToString:@"Botafogo2"]) {
		if ([serie isEqualToString:@"9º Ano"]) dataArray = nil;
		else dataArray = [NSArray arrayWithObjects:@"Abelha", @"Zangão", nil];
	}
	else if ([unidade isEqualToString:@"Barra"]) {
		if ([serie isEqualToString:@"3ª Série"]) dataArray = nil;
		else dataArray = [NSArray arrayWithObjects:@"Manhã", @"Tarde/Noite", nil];
	}
	
	if ([shouldPass isEqualToString:@"YES"]) {
		SemanaViewController *semana = [[SemanaViewController alloc] initWithStyle:UITableViewStyleGrouped];
		semana.unidade = unidade;
		semana.serie = serie;;
		semana.turma = turma;
		semana.shouldPass = @"YES";
		[self.navigationController pushViewController:semana animated:NO];
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {

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
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = UIColorFromRGB(0xFFCC00);
	
	UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    accessoryViewImage.center = CGPointMake(12, 25);
    [accessoryView addSubview:accessoryViewImage];
    [cell setAccessoryView:accessoryView];
	cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
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
    SemanaViewController *semana = [[SemanaViewController alloc] initWithStyle:UITableViewStyleGrouped];
	semana.unidade = unidade;
	semana.serie = serie;
	semana.turma = [dataArray objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:semana animated:YES];
}

@end
