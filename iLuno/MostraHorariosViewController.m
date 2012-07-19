//
//  MostraHorariosViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 13/05/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "MostraHorariosViewController.h"
#import "MateriaViewController.h"

@interface MostraHorariosViewController ()

@end

@implementation MostraHorariosViewController
@synthesize unidade, serie, turma, diaDaSemana;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) stopSpinner {
	[self.navigationItem setHidesBackButton: NO animated: YES];
	self.navigationItem.rightBarButtonItem = nil;
	[spinner stopAnimating];
	updateImageView.hidden = NO;
	isUpdating = NO;
}

- (void) startSpinner {
	[self.navigationItem setHidesBackButton: YES animated: YES];
	self.navigationItem.rightBarButtonItem = nil;
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.color = [UIColor lightGrayColor];
	spinner.center = updateImageView.center;
	[self.view addSubview:spinner];
	[spinner startAnimating];
	updateImageView.hidden = YES;
	updateLabel.text = @"Atualizando...";
	isUpdating = YES;
}

- (void) updateDidFinish {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	updateImageView.transform = CGAffineTransformMakeRotation(0);
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[UIView commitAnimations];
	[self stopSpinner];
}

- (void) setUpdateLabel {
	NSArray *key = [[NSArray alloc] initWithObjects:@"lastUpdate", nil];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	NSDate *now = [[NSDate alloc] init];
	
	NSString *dateString = [dateFormat stringFromDate:now];
	NSString *objectString = [[NSString alloc] initWithFormat:@"Atualizado pela última vez em: %@", dateString];
	
	NSArray *object = [[NSArray alloc] initWithObjects:objectString, nil];
	NSMutableDictionary *lastUpdateDictionary = [[NSMutableDictionary alloc] initWithObjects:object forKeys:key];
	
	[plistManager addNewEntry:lastUpdateDictionary ToDatabase:fileName];
	
	lastUpdateLabel.text = objectString;
}

- (void) alert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Não há conexão com a Internet" message:@"A atualização não pôde ser feita" 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (void) callAlert {
	queue = [NSOperationQueue new];
	NSInvocationOperation *alertOperations = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(alert)  object:nil];
	[queue addOperation:alertOperations];
}

- (void) updateHorarios {
	[self performSelectorOnMainThread:@selector(startSpinner) withObject:nil waitUntilDone:NO];
	
	if (connected) {
		NSLog(@"Table: %@", tableURL);
		[plistManager downloadPlistFromURL:tableURL AndSaveItAs:fileName OverwrittingExistingFiles:YES];
		dataArray = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
		[self performSelectorOnMainThread:@selector(setUpdateLabel) withObject:nil waitUntilDone:YES];
		[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		[activityView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
		[darkView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
		self.tableView.userInteractionEnabled = YES;
	}
	else{
		[self callAlert];
	}
	
	[self performSelectorOnMainThread:@selector(updateDidFinish) withObject:nil waitUntilDone:YES];
}

- (void) callUpdateHorarios {
	queue = [NSOperationQueue new];
	NSInvocationOperation *updateOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(updateHorarios)  object:nil];
	[queue addOperation:updateOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	self.navigationItem.title = diaDaSemana;
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = diaDaSemana;
	[titleLabel sizeToFit];
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	unidade = [unidade stringByReplacingOccurrencesOfString:@" " withString:@""];
	serie = [serie stringByReplacingOccurrencesOfString:@"ª" withString:@""]; serie = [serie stringByReplacingOccurrencesOfString:@"º" withString:@""]; serie = [serie stringByReplacingOccurrencesOfString:@" " withString:@""]; serie = [serie stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
	turma = [turma stringByReplacingOccurrencesOfString:@" " withString:@""]; turma = [turma stringByReplacingOccurrencesOfString:@"ã" withString:@"a"]; turma = [turma stringByReplacingOccurrencesOfString:@"Abelha" withString:@"A"]; turma = [turma stringByReplacingOccurrencesOfString:@"Zangao" withString:@"Z"]; turma = [turma stringByReplacingOccurrencesOfString:@"/" withString:@""];
	
	diaDaSemana = [[[diaDaSemana lowercaseString] stringByReplacingOccurrencesOfString:@"-feira" withString:@""] stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
	fileName = [[NSString stringWithFormat:@"%@%@%@%@", serie, turma, unidade, diaDaSemana] stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
	tableURL = [[NSString stringWithFormat:@"%@/horarios-generator.php?dia=%@&table=%@%@%@", webservice, diaDaSemana, serie, turma, unidade] stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
	
	plistManager = [[GVPlistPersistence alloc] init];
	dataArray = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
	
	updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, 320, 20)];
	updateLabel.textAlignment = UITextAlignmentCenter;
	updateLabel.text = @"Puxe para atualizar";
	updateLabel.textColor = [UIColor lightGrayColor];
	updateLabel.shadowColor = [UIColor blackColor];
	updateLabel.shadowOffset = CGSizeMake(0, -1);
	updateLabel.backgroundColor = [UIColor clearColor];
	
	lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 320, 20)];
	lastUpdateLabel.textAlignment = UITextAlignmentCenter;
	lastUpdateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
	lastUpdateLabel.textColor = UIColorFromRGB(0x888888);
	lastUpdateLabel.shadowColor = [UIColor blackColor];
	lastUpdateLabel.shadowOffset = CGSizeMake(0, -1);
	lastUpdateLabel.backgroundColor = [UIColor clearColor];
	
	updateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updateArrow.png"]];
	
	updateImageView.frame = CGRectMake(35, -50, 27, 40);
	
	shouldUpdate = NO;
	isUpdating = NO;
	
	[self.tableView addSubview:updateLabel];
	[self.view addSubview:lastUpdateLabel];
	[self.tableView addSubview:updateImageView];
	
	lastUpdateLabel.text = [[dataArray lastObject] objectForKey:@"lastUpdate"];
	
	if (![[dataArray lastObject] objectForKey:@"materia"]) [dataArray removeLastObject];
	
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

#pragma mark - Table view data source

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)targetContentOffset {
	NSLog(@"Offset: %f", self.tableView.contentOffset.y*-1);
	if (shouldUpdate && !isUpdating) {
		
		[self callUpdateHorarios];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
		[UIView commitAnimations];
	}
}

-(void)scrollViewDidScroll:(UIScrollView *)sender {
	
    float offset = self.tableView.contentOffset.y;
	offset *= -1;
	
	if (offset > 0 && offset < 60) {
		if(!isUpdating) updateLabel.text = @"Puxe para atualizar";
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.2];
		updateImageView.transform = CGAffineTransformMakeRotation(0);
		[UIView commitAnimations];
		shouldUpdate = NO;
	}
	if (offset >= 60) {
		if(!isUpdating) updateLabel.text = @"Solte para atualizar";
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.2];
		updateImageView.transform = CGAffineTransformMakeRotation(3.14159265);
		[UIView commitAnimations];
		shouldUpdate = YES;
	}
	
	if (isUpdating) shouldUpdate = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (dataArray.count == 0) return 1;
    else return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (dataArray.count == 0) {
		cell.textLabel.text = @"Baixar horários";
		cell.textLabel.textColor = UIColorFromRGB(0xFFCC00);
		cell.backgroundColor = [UIColor clearColor];
	}
	// Evita a criação de uma cell vazia
	else  {
		NSLog(@"%@", [[dataArray objectAtIndex:indexPath.row] objectForKey:@"materia"]);
		// Configure the cell...
		cell.backgroundColor = [UIColor clearColor];
		
		if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"materia"] isEqualToString:@"Intervalo"] || [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"materia"] isEqualToString:@"Almoço"]) {
			NSLog(@"Intervalo");
			cell.textLabel.textColor = [UIColor lightGrayColor];
			cell.userInteractionEnabled = NO;
		}
		else {
			cell.textLabel.textColor = UIColorFromRGB(0xFFCC00);
			UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
			UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
			accessoryViewImage.center = CGPointMake(12, 25);
			[accessoryView addSubview:accessoryViewImage];
			[cell setAccessoryView:accessoryView];
		}
		if ([serie isEqualToString:@"Monitoria"]) {
			cell.accessoryView = nil;
			cell.userInteractionEnabled = NO;
			cell.textLabel.textColor = UIColorFromRGB(0xFFCC00);
		}
		
		cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"materia"];
		cell.detailTextLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"horario"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (dataArray.count == 0) {
		darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.center = self.view.center;
		[activityView startAnimating];
		[self.view addSubview:activityView];
		darkView.backgroundColor = [UIColor blackColor];
		darkView.alpha = 0.5;
		[self.view addSubview:darkView];
		self.tableView.userInteractionEnabled = NO;
		if (connected) [self callUpdateHorarios];
		else {
			[self callAlert];
			[darkView removeFromSuperview];
			[activityView removeFromSuperview];
			self.tableView.userInteractionEnabled = YES;
		}
	}
	else {
		MateriaViewController *materia = [[MateriaViewController alloc] init];
		
		materia.unidade = unidade;
		materia.serie = serie;
		materia.turma = turma;
		materia.materia = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"materia"];
		materia.professor = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"professor"];
		materia.dias = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"dias"];
		if ([serie isEqualToString:@"3Serie"] || [serie isEqualToString:@"Extensivo"]) materia.hasABook = NO;
		else materia.hasABook = YES;
		materia.bookName = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"livroNome"];
		materia.bookFile = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"livroFile"];
		
		[self.navigationController pushViewController:materia animated:YES];
	}
}

@end
