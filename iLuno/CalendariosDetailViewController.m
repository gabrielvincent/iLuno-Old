//
//  CalendariosDetailViewController.m
//  _A_Z
//
//  Created by Gabriel Gino Vincent on 20/07/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#define ThisCell [self.tableView cellForRowAtIndexPath:indexPath]
#define Connected [self internetIsConnected]
#define Database @"Cal2Serie"
#define DownloadButton 1
#define DownloadSpinner 2
#define Begining 0
#define Ending 1

#if TARGET_IPHONE_SIMULATOR
#define Webservice @"http://api.iluno.com.br/calendarios/?id_serie=%d" //@"http://localhost/iLuno/api/calendarios/?id_serie=%d"
#else
#define Webservice @"http://api.iluno.com.br/calendarios/?id_serie=%d" //@"http://192.168.1.105/iLuno/api/calendarios/?id_serie=%d"
#endif

#import "CalendariosDetailViewController.h"
#import "JSON.h"

@implementation CalendariosDetailViewController
@synthesize fileName, title, id_serie;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void) viewWillArtificiallyAppear {
	
//	fileName = [[userDefaults objectAtIndex:0] objectForKey:@"CalendarioTable"];
//	title = [[userDefaults objectAtIndex:0] objectForKey:@"SerieLabel"];
//	urlString = [NSString stringWithFormat:Webservice, [[[userDefaults objectAtIndex:0] objectForKey:@"SerieID"] integerValue]];
//	
//	[self loadCalendars];
}

- (void) downloadButtonClicked {
	UIButton *downloadButton = ((UIButton *)[self.view viewWithTag:DownloadButton]);
	UIActivityIndicatorView *downloadSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	downloadSpinner.center = downloadButton.center;
	downloadSpinner.transform = CGAffineTransformMakeTranslation(0, 140);
	downloadSpinner.tag = DownloadSpinner;
	
	[downloadSpinner startAnimating];
	[self.tableView addSubview:downloadSpinner];
	[self callUpdateCalendars];
}

- (void) showNoInternetAlert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Não há conexão com a internet" message:@"Conecte-se a alguma rede e tente novamente" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (void) stopSpinner {
	[spinner stopAnimating];
	[spinner removeFromSuperview];
}

- (void) startSpinner {
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.color = [UIColor lightGrayColor];
	spinner.center = updateImageView.center;
	[self.tableView addSubview:spinner];
	[spinner startAnimating];
}

- (void) setUpdateDate {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	NSDate *now = [[NSDate alloc] init];
	
	NSString *dateString = [dateFormat stringFromDate:now];
	NSString *objectString = [[NSString alloc] initWithFormat:@"Atualizado pela última vez em: %@", dateString];
	
	if (![plistManager databaseAlreadyExistsWithName:@"LastUpdates"]) {
		[plistManager createNewDatabaseWithName:@"LastUpdates"];
	}
	
	NSMutableArray *arrayLastUpdates = [NSMutableArray arrayWithArray:[plistManager databaseWithName:@"LastUpdates"]];
	NSMutableDictionary *dateDictionary = [[NSMutableDictionary alloc] init];
	[dateDictionary setValue:dateString forKey:@"Date"];
	[dateDictionary setValue:fileName forKey:@"File"];
	
	int i = 0;
	for (NSDictionary *lastUpdateDictionary in arrayLastUpdates.copy) {
		NSString *file = [lastUpdateDictionary objectForKey:@"File"];
		if ([file isEqualToString:fileName]) {
			[arrayLastUpdates replaceObjectAtIndex:i withObject:dateDictionary];
			break;
		}
		i++;
	}
	
	// If the pair doesn't yet exist
	if (i == arrayLastUpdates.count) {
		[arrayLastUpdates addObject:dateDictionary];
	}
	
	[plistManager overwriteDatabase:@"LastUpdates" WithArray:arrayLastUpdates];
	
	lastUpdateLabel.text = objectString;
}

- (void) updateDidFinish {
	
	[UIView animateWithDuration:0.2 animations:^{
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
		((UIButton *)[self.view viewWithTag:DownloadButton]).alpha = 0.0;
		((UIActivityIndicatorView *)[self.view viewWithTag:DownloadSpinner]).alpha = 0.0;
	} completion:^(BOOL finished){
		[((UIButton *)[self.view viewWithTag:DownloadButton]) removeFromSuperview];
		[((UIActivityIndicatorView *)[self.view viewWithTag:DownloadSpinner]) stopAnimating];
		[((UIActivityIndicatorView *)[self.view viewWithTag:DownloadSpinner]) removeFromSuperview];
	}];
	
	updateImageView.hidden = NO;
	isUpdating = NO;
	[self stopSpinner];
	self.tableView.userInteractionEnabled = YES;
}

- (void) updateDidBegin {
	
	[self startSpinner];
	updateImageView.hidden = YES;
	updateLabel.text = @"Atualizando...";
	isUpdating = YES;
	self.tableView.userInteractionEnabled = NO;
}

- (void) updateCalendars {
	
	if (Connected) {
		
		NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
		arrayEvents = [jsonString JSONValue];
		
		[arrayEvents writeToFile:filePath atomically:YES];
		[self performSelectorOnMainThread:@selector(setUpdateDate) withObject:nil waitUntilDone:NO];
		
	}
	else {
		[self performSelectorOnMainThread:@selector(showNoInternetAlert) withObject:nil waitUntilDone:NO];
	}
	
	[self performSelectorOnMainThread:@selector(updateDidFinish) withObject:nil waitUntilDone:YES];
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	
}

- (void) callUpdateCalendars {
	
	[self updateDidBegin];
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(updateCalendars)  object:nil];
	[queue addOperation:loadOperation];
}

- (void) setUpdateLabel {
	
	NSArray *arrayLastUpdates = [plistManager databaseWithName:@"LastUpdates"];
	for (NSDictionary *lastUpdate in arrayLastUpdates) {
		NSString *file = [lastUpdate objectForKey:@"File"];
		if ([file isEqualToString:fileName]) {
			NSString *date = [lastUpdate objectForKey:@"Date"];
			lastUpdateLabel.text = [NSString stringWithFormat:@"Atualizado pela última vez em: %@", date];
			break;
		}
	}
	
}

- (void) loadCalendars {
	
	arrayEvents = [NSMutableArray arrayWithArray:[plistManager databaseWithName:fileName]];
	
	if (arrayEvents.count == 0) {
		UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
		downloadButton.tag = 1;
		[downloadButton setImage:[UIImage imageNamed:@"BaixarCalendario.png"] forState:UIControlStateNormal];
		[downloadButton addTarget:self action:@selector(downloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		downloadButton.frame = CGRectMake(0, 0, 173, 200);
		downloadButton.center = self.tableView.center;
		[self.tableView performSelectorOnMainThread:@selector(addSubview:) withObject:downloadButton waitUntilDone:NO];
	}
	
	[self performSelectorOnMainThread:@selector(setUpdateLabel) withObject:nil waitUntilDone:NO];
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void) callLoadCalendars {
	queue = [NSOperationQueue new];
	NSInvocationOperation *loadOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadCalendars)  object:nil];
	[queue addOperation:loadOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	urlString = [NSString stringWithFormat:Webservice, id_serie];
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFCDD5B);
	
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
	
	updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, 320, 20)];
	updateLabel.textAlignment = NSTextAlignmentCenter;
	updateLabel.text = @"Puxe para atualizar";
	updateLabel.textColor = [UIColor lightGrayColor];
	updateLabel.shadowColor = [UIColor blackColor];
	updateLabel.shadowOffset = CGSizeMake(0, -1);
	updateLabel.backgroundColor = [UIColor clearColor];
	
	lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 320, 20)];
	lastUpdateLabel.textAlignment = NSTextAlignmentCenter;
	lastUpdateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
	lastUpdateLabel.textColor = UIColorFromRGB(0x888888);
	lastUpdateLabel.shadowColor = [UIColor blackColor];
	lastUpdateLabel.shadowOffset = CGSizeMake(0, -1);
	lastUpdateLabel.backgroundColor = [UIColor clearColor];
	
	updateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updateArrow.png"]];
	updateImageView.frame = CGRectMake(35, -50, 27, 40);
	
	[self.tableView addSubview:updateLabel];
	[self.tableView addSubview:lastUpdateLabel];
	[self.tableView addSubview:updateImageView];
	
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
	[dateFormatter setLocale:locale];
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	plistManager = [[GVPlistPersistence alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
	
	[self callLoadCalendars];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) internetIsConnected {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gabrielvincent.com/CheckInternetConnection"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:8.0];
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    return (output.length > 0) ? YES : NO;
}

#pragma mark - Table view data methods

- (NSString *) eventForIndexPath:(NSIndexPath *)indexPath {
	return [[[arrayEvents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"evento"];
}

- (NSString *) dateStringForDate:(NSInteger)date AtIndexPath:(NSIndexPath *)indexPath {
	
	if (date == Begining) return [[[arrayEvents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"inicio"];
	else return [[[arrayEvents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"termino"];
}

- (NSString *) monthNameForSection:(NSInteger)section {
	
	NSString *monthName = @"";
	
	switch (section) {
		case 0:
			monthName = @"Fevereiro";
			break;
		case 1:
			monthName = @"Março";
			break;
		case 2:
			monthName = @"Abril";
			break;
		case 3:
			monthName = @"Maio";
			break;
		case 4:
			monthName = @"Junho";
			break;
		case 5:
			monthName = @"Julho";
			break;
		case 6:
			monthName = @"Agosto";
			break;
		case 7:
			monthName = @"Setembro";
			break;
		case 8:
			monthName = @"Outubro";
			break;
		case 9:
			monthName = @"Novembro";
			break;
		case 10:
			monthName = @"Dezembro";
			break;
			
		default:
			break;
	}
	
	return monthName;
}

- (NSString *) monthdayForBeginingDate:(NSDate *)beginingDate EndingDate:(NSDate *)endingDate {
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	if ([beginingDate isEqualToDate:endingDate]) {
		NSDateComponents *component = [calendar components:NSDayCalendarUnit fromDate:beginingDate];
		
		return [NSString stringWithFormat:@"dia %d", [component day]];
	}
	else {
		
		NSMutableArray *days = [[NSMutableArray alloc] init];
		
		NSDateComponents *beginingComponent = [calendar components:NSDayCalendarUnit fromDate:beginingDate];
		[days addObject:[NSString stringWithFormat:@"dia %d", [beginingComponent day]]];
		
		NSDateComponents *endingComponent = [calendar components:NSDayCalendarUnit fromDate:endingDate];
		[days addObject:[NSString stringWithFormat:@"dia %d", [endingComponent day]]];
		
		return [NSString stringWithFormat:@"%@ ao %@", [days objectAtIndex:Begining], [days objectAtIndex:Ending]];
	}
}

- (NSString *) weekdayForBeginigDate:(NSDate *)beginingDate EndingDate:(NSDate *)endingDate {
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	if ([beginingDate isEqualToDate:endingDate]) {
		NSDateComponents *component = [calendar components:NSWeekdayCalendarUnit fromDate:beginingDate];
		
		switch ([component weekday]) {
			case 1:
				return @"domingo,";
				break;
			case 2:
				return @"segunda-feira,";
				break;
			case 3:
				return @"terça-feira,";
				break;
			case 4:
				return @"quarta-feira,";
				break;
			case 5:
				return @"quinta-feira,";
				break;
			case 6:
				return @"sexta-feira,";
				break;
			case 7:
				return @"sábado,";
				break;
				
			default:
				return @"";
				break;
		}
	}
	else {
		
		NSMutableArray *weekdays = [[NSMutableArray alloc] init];
		
		NSDateComponents *beginingComponent = [calendar components:NSWeekdayCalendarUnit fromDate:beginingDate];
		switch ([beginingComponent weekday]) {
			case 1:
				[weekdays addObject:@"domingo"];
				break;
			case 2:
				[weekdays addObject:@"segunda-feira"];
				break;
			case 3:
				[weekdays addObject:@"terça-feira"];
				break;
			case 4:
				[weekdays addObject:@"quarta-feira"];
				break;
			case 5:
				[weekdays addObject:@"quinta-feira"];
				break;
			case 6:
				[weekdays addObject:@"sexta-feira"];
				break;
			case 7:
				[weekdays addObject:@"sábado"];
				break;
				
			default:
				return @"";
				break;
		}
		
		NSDateComponents *endingComponent = [calendar components:NSWeekdayCalendarUnit fromDate:endingDate];
		switch ([endingComponent weekday]) {
			case 1:
				[weekdays addObject:@"domingo,"];
				break;
			case 2:
				[weekdays addObject:@"segunda-feira,"];
				break;
			case 3:
				[weekdays addObject:@"terça-feira,"];
				break;
			case 4:
				[weekdays addObject:@"quarta-feira,"];
				break;
			case 5:
				[weekdays addObject:@"quinta-feira,"];
				break;
			case 6:
				[weekdays addObject:@"sexta-feira,"];
				break;
			case 7:
				[weekdays addObject:@"sábado,"];
				break;
				
			default:
				return @"";
				break;
		}
		
		return [NSString stringWithFormat:@"%@ a %@", [weekdays objectAtIndex:Begining], [weekdays objectAtIndex:Ending]];
		
	}

}

#pragma mark - Table view data source

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)targetContentOffset {
	if (shouldUpdate && !isUpdating) {
		
		[self callUpdateCalendars];
		
		[UIView animateWithDuration:0.2 animations:^{
			self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
		}];
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
	
	if (arrayEvents.count > 0) {
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	cell.backgroundColor = bgColor;
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (arrayEvents.count > 0) return [NSArray arrayWithObjects:@"FEV", @"MAR", @"ABR", @"MAI", @"JUN", @"JUL", @"AGO", @"SET", @"OUT", @"NOV", @"DEZ", nil];
	else return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 96;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [arrayEvents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[arrayEvents objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"CalendariosCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell"]];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:self options:nil];
        cell = customCell;
        customCell = nil;
    }
    
    // Configure the cell...
	
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
	if (realRow % 2 == 0) {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	}
	else {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
	}
	
	NSString *dateString = [[NSString alloc] init];
	
	NSDate *beginingDate = [[NSDate alloc] init];
	dateString = [self dateStringForDate:Begining AtIndexPath:indexPath];
	beginingDate = [dateFormatter dateFromString:dateString];
	
	NSDate *endingDate = [[NSDate alloc] init];
	dateString = [self dateStringForDate:Ending AtIndexPath:indexPath];
	endingDate = [dateFormatter dateFromString:dateString];
	
	eventLabel.text = [self eventForIndexPath:indexPath];
	weekdayLabel.text = [self weekdayForBeginigDate:beginingDate EndingDate:endingDate];
	monthdayLabel.text = [self monthdayForBeginingDate:beginingDate EndingDate:endingDate];
	
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
