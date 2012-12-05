//
//  ConfiguracoesViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 23/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "ConfiguracoesViewController.h"
#import "JSON.h"

@interface ConfiguracoesViewController ()

@end

@implementation ConfiguracoesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) showAlertWithTitle:(NSString *)title {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	
	for (NSString *option in alertData) {
		[alert addButtonWithTitle:option];
	}
	[alert addButtonWithTitle:@"Cancelar"];
	
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (void)callShowAlertWithTitle:(NSString *)title {
	
	queue = [NSOperationQueue new];
	NSInvocationOperation *alertOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(showAlertWithTitle:)  object:title];
	[queue addOperation:alertOperation];
}

- (void) fadeProgressView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.5];
	progressView.alpha = 0.0;
	currentFileLabel.alpha = 0.0;
	percentageLabel.alpha = 0.0;
	[UIView commitAnimations];
	
	progressView.progress = 0.0;
	progressView.hidden = YES;
	progressView.alpha = 1.0;
	downloadButton.enabled = YES;
}

- (void) setProgressViewProgressWithCurrentFile:(NSString *)currentFile {
	progressView.progress += 0.09090909;
	
	currentFileLabel.alpha = 1.0;
	percentageLabel.alpha = 1.0;
	currentFileLabel.text = currentFile;
	percentageLabel.text = [NSString stringWithFormat:@"%.0f", progressView.progress*100];
	percentageLabel.text = [percentageLabel.text stringByAppendingString:@"%"];
	
	if (progressView.progress >= 0.99999) {
		[self performSelector:@selector(fadeProgressView) withObject:nil afterDelay:1.5];
		[self performSelector:@selector(fadeConfirmation) withObject:nil afterDelay:3.0];
		confirmationLabel.text = @"Suas informações foram baixadas";
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.5];
		confirmationLabel.alpha = 1.0;
		check.alpha = 1.0;
		[UIView commitAnimations];
		shouldDismissViewController = YES;
	}
}

- (void) downloadTheWholeShit {
	
	[self saveData:nil AndShowConfirmation:NO];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSURL *query;
	NSArray *data;
	NSString *table;
	NSInteger id_serie;
	NSString *fileName;
	
	for (int i = 0; i < 5; i++) {
		NSString *dia;
		if (i == 0) dia = @"segunda";
		if (i == 1) dia = @"terca";
		if (i == 2) dia = @"quarta";
		if (i == 3) dia = @"quinta";
		if (i == 4) dia = @"sexta";
		
		// Baixa os Horários
		table = [[userDefaults objectAtIndex:0] objectForKey:@"HorarioTable"];
		NSLog(@"Dia: %@", dia);
		query = [NSURL URLWithString:[NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/horarios-generator.php?dia=%@&table=%@", dia, table]];
		data = [NSArray arrayWithContentsOfURL:query];
		
		[data writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist", table, dia]] atomically:YES];
		[self performSelectorOnMainThread:@selector(setProgressViewProgressWithCurrentFile:) withObject:[NSString stringWithFormat:@"%@%@", table, dia] waitUntilDone:NO];
		
		
		//Baixa os horários da Monitoria
		table = [[userDefaults objectAtIndex:0] objectForKey:@"MonitoriaTable"];
		query = [NSURL URLWithString:[NSString stringWithFormat:@"http://iluno.com.br/plistgenerator/horarios-generator.php?dia=%@&table=%@", dia, table]];
		data = [NSArray arrayWithContentsOfURL:query];
		
		[data writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist", table, dia]] atomically:YES];
		[self performSelectorOnMainThread:@selector(setProgressViewProgressWithCurrentFile:) withObject:[NSString stringWithFormat:@"%@%@", table, dia] waitUntilDone:NO];
		
	}
	
	
	// Baixa os Calendários
	fileName = [serieTextField.text stringByReplacingOccurrencesOfString:@"ª" withString:@""]; fileName = [fileName stringByReplacingOccurrencesOfString:@"º" withString:@""]; fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""]; fileName = [fileName stringByReplacingOccurrencesOfString:@"é" withString:@"e"]; fileName = [NSString stringWithFormat:@"Cal%@", fileName];
	id_serie = [[[userDefaults objectAtIndex:0]objectForKey:@"ID"] integerValue];
	query = [NSURL URLWithString:[NSString stringWithFormat:CalendariosURL, id_serie]];
	NSString *jsonString = [NSString stringWithContentsOfURL:query encoding:NSUTF8StringEncoding error:nil];
	data = [jsonString JSONValue];
	
	[data writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
	[self performSelectorOnMainThread:@selector(setProgressViewProgressWithCurrentFile:) withObject:[NSString stringWithFormat:@"%@", fileName] waitUntilDone:YES];
	
}

- (IBAction)callDownloadTheWholeShit:(id)sender {
	[self validateFields];
	
	if (fieldsAreValid) {
		progressView.progress = 0.0;
		percentageLabel.alpha = 1.0;
		downloadButton.enabled = NO;
		percentageLabel.text = @"0%";
		progressView.hidden = NO;
		shouldDismissViewController = NO;
		
		queue = [NSOperationQueue new];
		NSInvocationOperation *downloadOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(downloadTheWholeShit)  object:nil];
		[queue addOperation:downloadOperation];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Preencha os campos acima para baixar suas informações." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
	
}

- (void) fadeConfirmation {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.5];
	confirmationLabel.alpha = 0.0;
	check.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) confirmation {
	confirmationLabel.text = @"Suas informações foram salvas.";
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2];
	confirmationLabel.alpha = 1.0;
	check.alpha = 1.0;
	[UIView commitAnimations];
	
	[self performSelector:@selector(fadeConfirmation) withObject:nil afterDelay:3.0];

}

- (IBAction)hideKeyboard:(id)sender {
	
	[self pickerView:pickerView didSelectRow:[pickerView selectedRowInComponent:0] inComponent:0];
	
	[unidadeTextField resignFirstResponder];
	[serieTextField resignFirstResponder];
	[turmaTextField resignFirstResponder];
}

- (void) validateFields {
	if ((nameTextField.text.length > 0 && unidadeTextField.text.length > 0 && serieTextField.text.length > 0 && turmaTextField.text.length > 0) || ([unidadeTextField.text isEqualToString:@"Barra"] && [serieTextField.text isEqualToString:@"3ª Série"] && turmaTextField.text.length == 0) || ([serieTextField.text isEqualToString:@"9º Ano"] && turmaTextField.text.length == 0)) {
		saveButton.enabled = YES;
		fieldsAreValid = YES;
	}
	else fieldsAreValid = NO;
}

- (IBAction)showTurmaSelector:(id)sender {
	
	whatIsSelecting = @"turma";
	
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SeriesData" ofType:@"plist"];
	NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
	NSString *unidade = [unidadeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	for (NSDictionary *dict in array) {
		if ([[dict objectForKey:@"unidade"] isEqualToString:unidade]) {
			turmasArray = [dict objectForKey:@"turmas"];
		}
	}
	
	generalDataArray = turmasArray;
	pickerViewToolBarLabel.text = @"Turma";
	
	[pickerView reloadAllComponents];
}

- (IBAction)showSerieSelector:(id)sender {
	
	whatIsSelecting = @"serie";
	
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SeriesData" ofType:@"plist"];
	NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
	NSString *unidade = [unidadeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	for (NSDictionary *dict in array) {
		if ([[dict objectForKey:@"unidade"] isEqualToString:unidade]) {
			seriesArray = [dict objectForKey:@"series"];
		}
	}
	
	generalDataArray = seriesArray;
	pickerViewToolBarLabel.text = @"Série";
	
	[pickerView reloadAllComponents];
}

- (IBAction)showUnidadeSelector:(id)sender {
	
	whatIsSelecting = @"unidade";
	generalDataArray = [NSArray arrayWithArray:unidadeData];
	pickerViewToolBarLabel.text = @"Unidade";
	
	[pickerView reloadAllComponents];
	
	
	serieLabel.alpha = 1.0;
	serieTextField.userInteractionEnabled = YES;
	turmaLabel.alpha = 0.3;
	turmaTextField.userInteractionEnabled = NO;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [generalDataArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [generalDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	if ([whatIsSelecting isEqualToString:@"unidade"]) {
		serieTextField.text = @"";
		turmaTextField.text = @"";
		turmaLabel.alpha = 0.3;
		turmaTextField.userInteractionEnabled = NO;
		unidadeTextField.text = [generalDataArray objectAtIndex:row];
	}
	else if ([whatIsSelecting isEqualToString:@"serie"]) {
		turmaLabel.alpha = 1.0;
		turmaTextField.userInteractionEnabled = YES;
		serieTextField.text = [generalDataArray objectAtIndex:row];
	}
	else if ([whatIsSelecting isEqualToString:@"turma"]) {
		turmaTextField.text = [generalDataArray objectAtIndex:row];
	}
	
	
	if (([unidadeTextField.text isEqualToString:@"Barra"] && [serieTextField.text isEqualToString:@"3ª Série"]) || [serieTextField.text isEqualToString:@"9º Ano"]) {
		turmaLabel.alpha = 0.3;
		turmaTextField.text = @"";
		turmaTextField.userInteractionEnabled = NO;
	}
	
	[self validateFields];
}

- (IBAction)saveData:(id)sender AndShowConfirmation:(BOOL)shouldShowConfirmation {
	
	[self validateFields];
	
	if (fieldsAreValid) {
		
		NSString *unidade;
		NSString *serie;
		NSString *turma;
		NSNumber *serie_id;
		NSString *horarioTable;
		NSString *monitoriaTable;
		
		unidade = [unidadeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
		serie = [serieTextField.text stringByReplacingOccurrencesOfString:@"ª" withString:@""]; serie = [serie stringByReplacingOccurrencesOfString:@"º" withString:@""]; serie = [serie stringByReplacingOccurrencesOfString:@" " withString:@""]; serie = [serie stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
		turma = [turmaTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]; turma = [turma stringByReplacingOccurrencesOfString:@"ã" withString:@"a"]; turma = [turma stringByReplacingOccurrencesOfString:@"Abelha" withString:@"A"]; turma = [turma stringByReplacingOccurrencesOfString:@"/" withString:@""]; turma = [turma stringByReplacingOccurrencesOfString:@"Zangao" withString:@"Z"];
		horarioTable = [NSString stringWithFormat:@"%@%@%@", serie, turma, unidade];
		monitoriaTable = [NSString stringWithFormat:@"Monitoria%@", unidade];
		
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SeriesData" ofType:@"plist"];
		NSArray *arraySeries = [NSArray arrayWithContentsOfFile:plistPath];
		serie_id = [[arraySeries objectAtIndex:3] objectForKey:serieTextField.text];
		
		dataArray = [NSMutableArray arrayWithArray:[plistManager databaseWithName:@"UserDefaults"]];
		if (dataArray.count == 0) {
			[plistManager createNewDatabaseWithName:@"UserDefaults"];
			
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			[dict setValue:nameTextField.text forKey:@"Nome"];
			[dict setValue:unidade forKey:@"Unidade"];
			[dict setValue:serie forKey:@"Serie"];
			[dict setValue:turma forKey:@"Turma"];
			[dict setValue:serie_id forKey:@"ID"];
			[dict setValue:horarioTable forKey:@"HorarioTable"];
			[dict setValue:monitoriaTable forKey:@"MonitoriaTable"];
			[dict setValue:serieTextField.text forKey:@"SerieLabel"];
			[dict setValue:turmaTextField.text forKey:@"TurmaLabel"];
			[dict setValue:unidadeTextField.text forKey:@"UnidadeLabel"];
			
			[plistManager addNewEntry:dict ToDatabase:@"UserDefaults"];
		}
		else {
			[plistManager setValue:nameTextField.text ForKey:@"Nome" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:unidade ForKey:@"Unidade" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:serie ForKey:@"Serie" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:turma ForKey:@"Turma" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:serie_id ForKey:@"ID" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:horarioTable ForKey:@"HorarioTable" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:monitoriaTable ForKey:@"MonitoriaTable" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:serieTextField.text ForKey:@"SerieLabel" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:turmaTextField.text ForKey:@"TurmaLabel" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			[plistManager setValue:unidadeTextField.text ForKey:@"UnidadeLabel" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			
			if ([serieTextField.text isEqualToString:@"9º Ano"]) [plistManager setValue:@"0" ForKey:@"CalendariosIndexPath" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			else if ([serieTextField.text isEqualToString:@"1ª Série"]) [plistManager setValue:@"1" ForKey:@"CalendariosIndexPath" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			else if ([serieTextField.text isEqualToString:@"2ª Série"]) [plistManager setValue:@"2" ForKey:@"CalendariosIndexPath" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			else if ([serieTextField.text isEqualToString:@"3ª Série"]) [plistManager setValue:@"3" ForKey:@"CalendariosIndexPath" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			else if ([serieTextField.text isEqualToString:@"Extensivo"]) [plistManager setValue:@"4" ForKey:@"CalendariosIndexPath" ForEntryAtIndex:0 InDatabase:@"UserDefaults"];
			
			if (shouldShowConfirmation) [self confirmation];
		}
		
		userDefaults = [plistManager databaseWithName:@"UserDefaults"];
		[nameTextField resignFirstResponder];
		if (shouldDismissViewController)[self dismissModalViewControllerAnimated:YES];
	}
	else {
		if (nameTextField.text.length == 0) {
			[nameTextField becomeFirstResponder];
		}
		else if (unidadeTextField.text.length == 0) {
			[unidadeTextField becomeFirstResponder];
		}
		else if (serieTextField.text.length == 0) {
			[serieTextField becomeFirstResponder];
		}
		else if (turmaTextField.text.length == 0 && ![unidadeTextField.text isEqualToString:@"Barra"] && ![serieTextField.text isEqualToString:@"3ª Série"]) {
			[turmaTextField becomeFirstResponder];
		}
	}
}

- (void) loadData {
	turmaTextField.userInteractionEnabled = NO;
	
	userDefaults = [plistManager databaseWithName:@"UserDefaults"];
	if (userDefaults.count > 0) {
		nameTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"Nome"];
		unidadeTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"UnidadeLabel"];
		serieTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"SerieLabel"];
		turmaTextField.text = [[userDefaults objectAtIndex:0] objectForKey:@"TurmaLabel"];
		
		serieLabel.alpha = 1.0;
		turmaLabel.alpha = 1.0;
		serieTextField.userInteractionEnabled = YES;
		turmaTextField.userInteractionEnabled = YES;
		
		if (([unidadeTextField.text isEqualToString:@"Barra"] && [serieTextField.text isEqualToString:@"3ª Série"]) || [serieTextField.text isEqualToString:@"9º Ano"]) {
			turmaLabel.alpha = 0.3;
			turmaTextField.userInteractionEnabled = NO;
		}
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
	plistManager = [[GVPlistPersistence alloc] init];
	unidadeData = [[NSArray alloc] initWithObjects:@"Botafogo 1", @"Botafogo 2", @"Barra", nil];
	confirmationLabel.alpha = 0.0;
	check.alpha = 0.0;
	percentageLabel.alpha = 0.0;
	[self loadData];
	fieldsAreValid = NO;
	shouldDismissViewController = YES;
	pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 179.9)];
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	pickerViewToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard:)];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	pickerViewToolBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
	pickerViewToolBarLabel.textAlignment = UITextAlignmentCenter;
	pickerViewToolBarLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
	pickerViewToolBarLabel.textColor = [UIColor whiteColor];
	pickerViewToolBarLabel.backgroundColor = [UIColor clearColor];
	pickerViewToolBarLabel.shadowOffset = CGSizeMake(0, -1);
	pickerViewToolBarLabel.shadowColor = [UIColor darkGrayColor];
	pickerViewToolBarLabel.center = pickerViewToolBar.center;
	NSArray *itemsArray = [NSArray arrayWithObjects:flexibleSpace,okButton, nil];
	[pickerViewToolBar addSubview:pickerViewToolBarLabel];
	[pickerViewToolBar setItems:itemsArray];
	unidadeTextField.inputAccessoryView = serieTextField.inputAccessoryView = turmaTextField.inputAccessoryView = pickerViewToolBar;
	unidadeTextField.inputView = serieTextField.inputView = turmaTextField.inputView = pickerView;
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

@end
