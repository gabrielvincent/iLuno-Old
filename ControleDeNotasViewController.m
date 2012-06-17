//
//  ControleDeNotasViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 16/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#define Opening 0
#define Closing 1
#define Database @"ControleDeNotas"
#define Add 0
#define Save 1
#define Edit 0
#define OK 1
#define None -1
#define Disabled 2
#define Enabled 3

#import "ControleDeNotasViewController.h"
#import "TrimestresViewController.h"

@interface ControleDeNotasViewController ()

@end

@implementation ControleDeNotasViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (NSString *) simplifiedString:(NSString *)string {
	
	string = [string lowercaseString];
	string = [string stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
	string = [string stringByReplacingOccurrencesOfString:@"i" withString:@"i"];
	string = [string stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
	string = [string stringByReplacingOccurrencesOfString:@"ú" withString:@"ú"];
	string = [string stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
	string = [string stringByReplacingOccurrencesOfString:@"ã" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"â" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"ê" withString:@"e"];
	string = [string stringByReplacingOccurrencesOfString:@"ô" withString:@"o"];
	string = [string stringByReplacingOccurrencesOfString:@"à" withString:@"a"];
	string = [string stringByReplacingOccurrencesOfString:@"è" withString:@"e"];
	string = [string stringByReplacingOccurrencesOfString:@"ì" withString:@"i"];
	string = [string stringByReplacingOccurrencesOfString:@"ò" withString:@"ò"];
	string = [string stringByReplacingOccurrencesOfString:@"ù" withString:@"u"];
	string = [string stringByReplacingOccurrencesOfString:@"ñ" withString:@"n"];
	
	return string;
}

- (void) setLeftBarButton:(NSInteger) button {
	if (button == Edit) self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleTableViewEdditing)];
	else if (button == OK) self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(toggleTableViewEdditing)];
	else if (button == None) self.navigationItem.leftBarButtonItem = nil;
	else if (button == Disabled) self.navigationItem.leftBarButtonItem.enabled = NO;
	else if (button == Enabled) self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void) setRightBarButton:(NSInteger) button {
	
	if (button == Add) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject)];
	else if (button == Save) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" style:UIBarButtonItemStyleDone target:self action:@selector(saveSubject)];
	else if (button == None) self.navigationItem.rightBarButtonItem = nil;
	else if (button == Disabled) self.navigationItem.rightBarButtonItem.enabled = NO;
	else if (button == Enabled) self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) toggleTableViewEdditing {
	
	if ([self.tableView isEditing]) {
		[self.tableView setEditing:NO animated:YES];
		[self setRightBarButton:Add];
		[self setLeftBarButton:Edit];
	}
	else {
		[self.tableView setEditing:YES animated:YES];
		[self setLeftBarButton:OK];
		[self setRightBarButton:None];
	}
	
}

- (IBAction)dynamicallyValidateSubject:(id)sender {
	
	// Verifica se a string está vazia ou se é composta por epaços
	if (materiaTextField.text.length == 0  || [materiaTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
		[self setRightBarButton:Disabled];
	}
	else {
		[self setRightBarButton:Enabled];
	}
}

- (BOOL) subjectNameIsValid {
	
	for (NSDictionary *dict in arrayMaterias) {
		
		NSString *materia1 = [self simplifiedString:materiaTextField.text];
		NSString *materia2 = [self simplifiedString:[dict objectForKey:@"Materia"]];
		
		if ([materia1 isEqualToString:materia2]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:[NSString stringWithFormat:@"Uma matéria com o nome \"%@\" já foi inserida. Por favor, escolha outro nome e tente novamente.", materiaTextField.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			return NO;
		}
	}
	
	return YES;
}

- (void) cancelAdding {
	[self performGraphicalAdjustmentsFor:Closing];
}

- (void) performGraphicalAdjustmentsFor:(NSInteger) action {
	if (action == Opening) {
		self.tableView.scrollEnabled = NO;
		[self.tableView setEditing:NO];
		titleLabel.text = @"Nova Matéria";
		
		if (darkView == nil) {
			darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
			darkView.backgroundColor = [UIColor blackColor];
			[self.navigationController.view addSubview:darkView];
		}
		darkView.alpha = 0.0;
		
		if (cancelGesture == nil) {
			cancelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self	action:@selector(cancelAdding)];
			[darkView addGestureRecognizer:cancelGesture];
		}
		
		if (adicionarMateriaView == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"AdicionarMateria" owner:self options:nil];
			adicionarMateriaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
		}
		[self.navigationController.view addSubview:adicionarMateriaView];
		[self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
		adicionarMateriaView.frame = CGRectMake(0, -44, 320, 44);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];

		self.navigationController.navigationBar.frame = CGRectMake(0, 44, 320, 44);
		[self.tableView setContentOffset:CGPointMake(0, -44) animated:YES];
		darkView.alpha = 0.6;
		adicionarMateriaView.frame = CGRectMake(0, 0, 320, 44);
		
		[UIView commitAnimations];
		
		[self setRightBarButton:Save];
		[self setRightBarButton:Disabled];
		[self setLeftBarButton:None];
		
		[materiaTextField becomeFirstResponder];
	}
	else if (action == Closing) {
		[materiaTextField resignFirstResponder];
		titleLabel.text = @"Controle de Notas";
		[self.navigationController.view addSubview:darkView];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		
		[self.tableView setContentOffset:CGPointMake(0, -44) animated:YES];
		self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
		darkView.alpha = 0.0;
		adicionarMateriaView.frame = CGRectMake(0, 0, 320, 44);
		self.tableView.scrollEnabled = YES;
		
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		adicionarMateriaView.frame = CGRectMake(0, -44, 320, 44);
		[UIView commitAnimations];
		
		[adicionarMateriaView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
		[materiaTextField performSelector:@selector(setText:) withObject:@"" afterDelay:0.2];
		
		[self setRightBarButton:Add];
		[self setRightBarButton:Enabled];
		[self setLeftBarButton:Edit];
	}
}

- (void) saveSubject {
	
	if ([self subjectNameIsValid]) {
		
		NSString *materia = [materiaTextField text];
		
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:materia forKey:@"Materia"];
		[plistManager addNewEntry:dict ToDatabase:Database];
		[arrayMaterias addObject:dict];
		
		[self performGraphicalAdjustmentsFor:Closing];
		[self.tableView reloadData];
	}
}

- (void) addSubject {
	[self performGraphicalAdjustmentsFor:Opening];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFDDD5B);
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	self.navigationItem.title = @"Matérias";
	titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.shadowColor = [UIColor colorWithRed:252.0/255.0 green:234.0/255.0 blue:162.0/255.0 alpha:0.9];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = @"Controle de Notas";
	[titleLabel sizeToFit];
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	plistManager = [[GVPlistPersistence alloc] init];
	arrayMaterias = [NSMutableArray arrayWithArray:[plistManager databaseWithName:Database]];
	
	[self setRightBarButton:Add];
	[self setLeftBarButton:Edit];
	if ([arrayMaterias count] == 0) [self setLeftBarButton:Disabled];
	
	if (![plistManager databaseAlreadyExistsWithName:Database]) [plistManager createNewDatabaseWithName:Database];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayMaterias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	cell.textLabel.text = [[arrayMaterias objectAtIndex:indexPath.row] objectForKey:@"Materia"];
	cell.textLabel.textColor = UIColorFromRGB(0xFFCC00);
	cell.textLabel.shadowOffset = CGSizeMake(0, -1);
	cell.textLabel.shadowColor = [UIColor blackColor];
	
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
	
	if (realRow % 2 == 0) {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darker-background-pattern.png"]];
	}
	else {
		bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkest-background-full.png"]];
	}
	
	UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    accessoryViewImage.center = CGPointMake(12, 25);
    [accessoryView addSubview:accessoryViewImage];
    [cell setAccessoryView:accessoryView];
	
	// Adiciona o separador no topo da cell
	if ([[cell subviews] count] < 2) {
		UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
		separatorView.frame = CGRectMake(0, 0, 320, 9);
		[cell addSubview:separatorView];
	}
	
	// Verifica se alguma row tem um separador a mais (acontece quando é inserida uma nova matéria];
	if (cell.subviews.count == 3 && indexPath.row < [arrayMaterias count]-1) {
		for (UIImageView *separator in cell.subviews) {
			if (separator.frame.origin.y == 44) {
				[separator removeFromSuperview];
				break;
			}
		}
	}
	
	// Insere um segundo separador à última row da TableView
	if (indexPath.row == [arrayMaterias count]-1) {
		if ([[cell subviews] count] < 3) {
			UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
			separatorView.frame = CGRectMake(0, 44, 320, 9);
			[cell addSubview:separatorView];
		}
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

// When single cell will be eddited
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[self setLeftBarButton:OK];
}

// When single cell did finish being eddited
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[self setLeftBarButton:Edit];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arrayMaterias removeObjectAtIndex:indexPath.row];
		[plistManager removeEntryAtIndex:indexPath.row FromDatabase:Database];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		
		if ([arrayMaterias count] == 0) {
			[self.tableView setEditing:NO];
			[self setLeftBarButton:Edit];
			[self setLeftBarButton:Disabled];
			[self setRightBarButton:Add];
		}
		
		[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	NSMutableDictionary *temporarySubject = [arrayMaterias objectAtIndex:fromIndexPath.row];
	
	[arrayMaterias removeObjectAtIndex:fromIndexPath.row];
	[arrayMaterias insertObject:temporarySubject atIndex:toIndexPath.row];
	[plistManager removeEntryAtIndex:fromIndexPath.row FromDatabase:Database];
	[plistManager addEntry:temporarySubject atIndex:toIndexPath.row ToDatabase:Database];
	
	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
	
}


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
    TrimestresViewController *trimestres = [[TrimestresViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	
	[self.navigationController pushViewController:trimestres animated:YES];
}

@end
