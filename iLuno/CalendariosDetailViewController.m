//
//  CalendariosDetailViewController.m
//  _A_Z
//
//  Created by Gabriel Gino Vincent on 20/07/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import "CalendariosDetailViewController.h"


@implementation CalendariosDetailViewController
@synthesize urlString, fileName, title, table;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillArtificiallyAppear {
	
	fileName = [[userDefaults objectAtIndex:0] objectForKey:@"CalendarioTable"];
	title = [[userDefaults objectAtIndex:0] objectForKey:@"SerieLabel"];
	urlString = [NSString stringWithFormat:@"http://www.iluno.com.br/plistgenerator/calendarios-generator.php?table=%@", fileName];
	
	[self loadCalendars];
}

- (void)successMessage {
	
	NSArray *array = [[NSArray alloc] init];
	array = [plistManager databaseWithName:fileName];
	[self stopSpinner];
}

- (void) distributeData {
	FEV = MAR = ABR = MAI = JUN = JUL = AGO = SET = OUT = NOV = DEZ = totalIndexPath = 0;
	int i;
	
	// Fevereiro
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 2) {
			[arrayFEV insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:FEV];
			
			FEV++;
			totalIndexPath++;
		}
	}
	
	// Março
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 3) {
			[arrayMAR insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:MAR];
			
			MAR++;
			totalIndexPath++;
		}
	}
	
	// Abril
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 4) {
			[arrayABR insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:ABR];
			
			ABR++;
			totalIndexPath++;
		}
	}
	
	// Maio
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 5) {
			[arrayMAI insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:MAI];
			
			MAI++;
			totalIndexPath++;
		}
	}
	
	// Junho
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 6) {
			[arrayJUN insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:JUN];
			
			JUN++;
			totalIndexPath++;
		}
	}
	
	// Julho
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 7) {
			[arrayJUL insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:JUL];
			
			JUL++;
			totalIndexPath++;
		}
	}
	
	// Agosto
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 8) {
			[arrayAGO insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:AGO];
			
			AGO++;
			totalIndexPath++;
		}
	}
	
	// Setembro
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 9) {
			[arraySET insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:SET];
			
			SET++;
			totalIndexPath++;
		}
	}
	
	// Outubro
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 10) {
			[arrayOUT insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:OUT];
			
			OUT++;
			totalIndexPath++;
		}
	}
	
	// Novembro
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 11) {
			[arrayNOV insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:NOV];
			
			NOV++;
			totalIndexPath++;
		}
	}
	
	// Dezembro
	for (i = 0; i < [arrayLoaded count]; i++) {
		int mes = [[[arrayLoaded objectAtIndex: totalIndexPath] objectForKey: @"mes"] intValue];
		if (mes == 12) {
			[arrayDEZ insertObject:[arrayLoaded objectAtIndex:totalIndexPath] atIndex:DEZ];
			
			DEZ++;
			totalIndexPath++;
		}
	}
	
}

- (void) loadCalendars {
	
	arrayLoaded = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
	
	if (arrayLoaded != nil) {
		self.navigationItem.rightBarButtonItem = atualizar;
		if ([[arrayLoaded lastObject] objectForKey: @"lastUpdate"]) {
			lastUpdateLabel.text = [[arrayLoaded lastObject] objectForKey:@"lastUpdate"];
			[arrayLoaded removeLastObject];
		}
		[self distributeData];
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
	
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void) stopSpinner {
	[self.navigationItem setHidesBackButton: NO animated: YES];
	self.navigationItem.rightBarButtonItem = nil;
	[spinner stopAnimating];
	self.navigationItem.rightBarButtonItem = atualizar;
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

- (void) setUpdateDate {
	
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
	[alert show];
	
	[self stopSpinner];
}

- (void) updateDidFinish {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	updateImageView.transform = CGAffineTransformMakeRotation(0);
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[UIView commitAnimations];
	
	[self stopSpinner];
}

- (void)updateCalendars {
	[self performSelectorOnMainThread:@selector(startSpinner) withObject:nil waitUntilDone:NO];
	
    if (connected) {
		NSLog(@"Loading from internet...");
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		arrayEventos = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
		
		[arrayEventos writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
		[self setUpdateDate];
		
		[self performSelectorOnMainThread:@selector(stopSpinner) withObject:nil waitUntilDone:NO];
		
		[self performSelectorOnMainThread:@selector(successMessage) withObject:nil waitUntilDone:YES];
		[self loadCalendars];
		
	}
	else  {
		[self performSelectorOnMainThread:@selector(alert) withObject:nil waitUntilDone:NO];
	}
	
	[self performSelectorOnMainThread:@selector(updateDidFinish) withObject:nil waitUntilDone:YES];
}

- (void) callUpdateCalendars {
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(updateCalendars)  object:nil];
	[queue addOperation:loadOperation];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	shouldUpdate = NO;
	
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
	
	[self.tableView addSubview:updateLabel];
	[self.view addSubview:lastUpdateLabel];
	[self.tableView addSubview:updateImageView];
	
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
	
	bgColor = [[UIColor alloc] init];
	
	atualizar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(callUpdateCalendars)];
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	atualizando = [[UIBarButtonItem alloc] initWithCustomView:spinner];	
	[spinner startAnimating];
	self.navigationItem.rightBarButtonItem = atualizar;
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:253.0/255.0 green:221.0/255.0 blue:91.0/255.0 alpha:1.0];
	
	backToBlack = 0;
	isUpdating = NO;
	
	arrayFEV = [[NSMutableArray alloc] init];
	arrayMAR = [[NSMutableArray alloc] init];
	arrayABR = [[NSMutableArray alloc] init];
	arrayMAI = [[NSMutableArray alloc] init];
	arrayJUN = [[NSMutableArray alloc] init];
	arrayJUL = [[NSMutableArray alloc] init];
	arrayAGO = [[NSMutableArray alloc] init];
	arraySET = [[NSMutableArray alloc] init];
	arrayOUT = [[NSMutableArray alloc] init];
	arrayNOV = [[NSMutableArray alloc] init];
	arrayDEZ = [[NSMutableArray alloc] init];
	
	plistManager = [[GVPlistPersistence alloc] init];
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(loadCalendars)  object:nil];
	[queue addOperation:loadOperation];
	
	userDefaults = [plistManager databaseWithName:@"UserDefaults"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];

	// check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
	
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName: @"www.apple.com"];
    [hostReachable startNotifier];
	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{	
    typedef enum {
        UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
        UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
        UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeLeft,
        UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeRight
    } UIInterfaceOrientation;
    
	return UIInterfaceOrientationPortrait;
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

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	view.backgroundColor = [UIColor lightGrayColor];
	view.alpha = 0.8;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -5, 300, 30)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = UIColorFromRGB(0x333333);
	label.font = [UIFont fontWithName:@"Helvetica-bold" size:18];
	label.shadowOffset = CGSizeMake(0, 1);
	label.shadowColor = UIColorFromRGB(0xAAAAAA);
	
	if (arrayLoaded.count > 0) {
		switch (section) {
			case 0:
				label.text = @"Fevereiro";
				break;
			case 1:
				label.text = @"Março";
				break;
			case 2:
				label.text = @"Abril";
				break;
			case 3:
				label.text = @"Maio";
				break;
			case 4:
				label.text = @"Junho";
				break;
			case 5:
				label.text = @"Julho";
				break;
			case 6:
				label.text = @"Agosto";
				break;
			case 7:
				label.text = @"Setembro";
				break;
			case 8:
				label.text = @"Outubro";
				break;
			case 9:
				label.text = @"Novembro";
				break;
			case 10:
				label.text = @"Dezembro";
				break;
			default:
				label.text = @"";
				break;
		}
	}
	else label.text = @"Download";
	
	[view addSubview:label];
	return view;
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)targetContentOffset {
	NSLog(@"Offset: %f", self.tableView.contentOffset.y*-1);
	if (shouldUpdate && !isUpdating) {
		
		[self callUpdateCalendars];
		
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

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    return 80.0;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = bgColor;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (arrayLoaded.count == 0) return [NSArray arrayWithObjects:@"", nil];
    else return [NSArray arrayWithObjects:@"FEV", @"MAR", @"ABR", @"MAI", @"JUN", @"JUL", @"AGO", @"SET", @"OUT", @"NOV", @"DEZ", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (arrayLoaded.count == 0) return 1;	
	
    else return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	if (arrayLoaded.count == 0) {
		return 1;
	}
	else {
		
		switch (section) {
			case 0:
				return FEV;
				break;
			case 1:
				return MAR;
				break;
			case 2:
				return ABR;
				break;
			case 3:
				return MAI;
				break;
			case 4:
				return JUN;
				break;
			case 5:
				return JUL;
				break;
			case 6:
				return AGO;
				break;
			case 7:
				return SET;
				break;
			case 8:
				return OUT;
				break;
			case 9:
				return NOV;
				break;
			case 10:
				return DEZ;
				break;	
				
			default:
				return 0;
				break;
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (arrayLoaded.count > 0) {
		switch (section) {
			case 0:
				return @"Fevereiro";
				break;
			case 1:
				return @"Março";
				break;
			case 2:
				return @"Abril";
				break;
			case 3:
				return @"Maio";
				break;
			case 4:
				return @"Junho";
				break;
			case 5:
				return @"Julho";
				break;
			case 6:
				return @"Agosto";
				break;
			case 7:
				return @"Setembro";
				break;
			case 8:
				return @"Outubro";
				break;
			case 9:
				return @"Novembro";
				break;
			case 10:
				return @"Dezembro";
				break;
			default:
				return @"";
				break;
		}
	}
	else return @"";
	
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	
	if (arrayLoaded.count == 0) {
		cell.textLabel.text = @"Baixar o Calendário";
		cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
		UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
		separatorView.frame = CGRectMake(0, 80, 320, 9);
		[cell addSubview:separatorView];
	}
	else {
		
		// Aloc the cell
		customCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
		eventoLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 11, 320, 18)];
		diaDaSemanaLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 31, 320, 21)];
		diaDoMesLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 52, 320, 27)];
		
		
		//Edit the content
		
		NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
		
		if (realRow % 2 == 0) {
			bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
		}
		else {
			bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
		}
		
		queue = [NSOperationQueue new];
		NSInvocationOperation *style = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(styleCells)  object:nil];
		[queue addOperation:style];
		
		eventoLabel.backgroundColor = [UIColor clearColor];
		eventoLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
		eventoLabel.textColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
		eventoLabel.shadowOffset = CGSizeMake(0, -1);
		eventoLabel.shadowColor = [UIColor blackColor];
		
		diaDaSemanaLabel.backgroundColor = [UIColor clearColor];
		diaDaSemanaLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
		diaDaSemanaLabel.textColor = [UIColor whiteColor];
		diaDaSemanaLabel.shadowOffset = CGSizeMake(0, -1);
		diaDaSemanaLabel.shadowColor = [UIColor blackColor];
		
		diaDoMesLabel.backgroundColor = [UIColor clearColor];
		diaDoMesLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
		diaDoMesLabel.textColor = [UIColor lightGrayColor];
		diaDoMesLabel.shadowOffset = CGSizeMake(0, -1);
		diaDoMesLabel.shadowColor = [UIColor blackColor];
		
		UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
		separatorView.frame = CGRectMake(0, 0, 320, 9);
		
		// Remove as labels anteriormente alocadas
		for (UILabel *label in cell.subviews) [label removeFromSuperview];
		for (UIImageView *image in cell.subviews) [image removeFromSuperview];
		
		[customCell addSubview:separatorView];
		[customCell addSubview:eventoLabel];
		[customCell addSubview:diaDaSemanaLabel];
		[customCell addSubview:diaDoMesLabel];
		
		// Configure the cell...
		switch (indexPath.section) {
			case 0:
				eventoLabel.text = [[arrayFEV objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayFEV objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayFEV objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 1:
				eventoLabel.text = [[arrayMAR objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayMAR objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayMAR objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 2:
				eventoLabel.text = [[arrayABR objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayABR objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayABR objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 3:
				eventoLabel.text = [[arrayMAI objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayMAI objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayMAI objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 4:
				eventoLabel.text = [[arrayJUN objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayJUN objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayJUN objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 5:
				eventoLabel.text = [[arrayJUL objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayJUL objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayJUL objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 6:
				eventoLabel.text = [[arrayAGO objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayAGO objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayAGO objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 7:
				eventoLabel.text = [[arraySET objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arraySET objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arraySET objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 8:
				eventoLabel.text = [[arrayOUT objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayOUT objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayOUT objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 9:
				eventoLabel.text = [[arrayNOV objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayNOV objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayNOV objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
			case 10:
				eventoLabel.text = [[arrayDEZ objectAtIndex: indexPath.row] objectForKey: @"evento"];
				diaDaSemanaLabel.text = [[arrayDEZ objectAtIndex: indexPath.row] objectForKey: @"dia_da_semana"];
				diaDoMesLabel.text = [[arrayDEZ objectAtIndex: indexPath.row] objectForKey: @"dia_do_mes"];
				break;
				
			default:
				cell.textLabel.text = @"";
				cell.detailTextLabel.text = @"";
				break;
		}
		
		[cell addSubview:customCell];
		
		
		cell.userInteractionEnabled = NO;
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
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self callUpdateCalendars];
}

@end
