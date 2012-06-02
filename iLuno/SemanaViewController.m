//
//  SemanaViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 06/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "SemanaViewController.h"
#import "MostraHorariosViewController.h"

@interface SemanaViewController ()

@end

@implementation SemanaViewController
@synthesize unidade, serie, turma, shouldPass;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) getWeekDay {
	NSDate *now = [NSDate date];
	weekday = [[NSDateFormatter alloc] init];
    
	[weekday setDateFormat: @"EEEE"];
	
	NSLog(@"Weekday: %@", [weekday stringFromDate:now]);
	
	//Segunda
	if ([[weekday stringFromDate:now] isEqualToString:@"Monday"] || [[weekday stringFromDate:now] isEqualToString:@"segunda-feira"] || [[weekday stringFromDate:now] isEqualToString:@"lunes"] ||[[weekday stringFromDate:now] isEqualToString:@"ludi"]) diaDaSemana = @"Segunda-feira";
	
	//Terça
	else if ([[weekday stringFromDate:now] isEqualToString:@"Tuesday"] || [[weekday stringFromDate:now] isEqualToString:@"terça-feira"] || [[weekday stringFromDate:now] isEqualToString:@"martes"] ||[[weekday stringFromDate:now] isEqualToString:@"mardy"]) diaDaSemana = @"Terca-feira";
	
	//Quarta
	else if ([[weekday stringFromDate:now] isEqualToString:@"Wednesday"] || [[weekday stringFromDate:now] isEqualToString:@"quarta-feira"] || [[weekday stringFromDate:now] isEqualToString:@"miércoles"] ||[[weekday stringFromDate:now] isEqualToString:@"marcredi"]) diaDaSemana = @"Quarta-feira";
	
	//Quinta
	else if ([[weekday stringFromDate:now] isEqualToString:@"Thursday"] || [[weekday stringFromDate:now] isEqualToString:@"quinta-feira"] || [[weekday stringFromDate:now] isEqualToString:@"jueves"] ||[[weekday stringFromDate:now] isEqualToString:@"jeudi"]) diaDaSemana = @"Quinta-feira";
	
	//Sexta
	else if ([[weekday stringFromDate:now] isEqualToString:@"Friday"] || [[weekday stringFromDate:now] isEqualToString:@"sexta-feira"] || [[weekday stringFromDate:now] isEqualToString:@"viernes"] ||[[weekday stringFromDate:now] isEqualToString:@"vendredi"]) diaDaSemana = @"Sexta-feira";
	
    else diaDaSemana = @"Fim de semana";
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    dias = [[NSArray alloc] initWithObjects:@"Segunda-feira", @"Terça-feira", @"Quarta-feira", @"Quinta-feira", @"Sexta-feira", nil];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	self.navigationItem.title = @"Semana";
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	if (turma != nil) titleLabel.text = [NSString stringWithFormat:@"%@ ➥ %@", serie, turma];
	else titleLabel.text = serie;
	[titleLabel sizeToFit];
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	[self getWeekDay];
	
	if ([shouldPass isEqualToString:@"YES"] && ![diaDaSemana isEqualToString:@"Fim de semana"]) {
		MostraHorariosViewController *mostra = [[MostraHorariosViewController alloc] initWithStyle:UITableViewStyleGrouped];
		mostra.unidade = unidade;
		mostra.serie = serie;;
		mostra.turma = turma;
		mostra.diaDaSemana = diaDaSemana;
		[self.navigationController pushViewController:mostra animated:NO];
	}
	else {
		NSLog(@"Unidade: %@ | Serie: %@ | Turma: %@ | Dia da Semana: %@ | ShouldPass: %@", unidade, serie, turma, diaDaSemana, shouldPass);
	}
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
    return [dias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
	cell.textLabel.text = [dias objectAtIndex:indexPath.row];
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MostraHorariosViewController *mostraHorarios = [[MostraHorariosViewController alloc] initWithStyle:UITableViewStyleGrouped];
	mostraHorarios.unidade = unidade;
	mostraHorarios.serie = serie;
	mostraHorarios.turma = turma;
	mostraHorarios.diaDaSemana = [dias objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:mostraHorarios animated:YES];
}

@end
