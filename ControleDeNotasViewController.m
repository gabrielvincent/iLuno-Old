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

#import "ControleDeNotasViewController.h"
#import "AdicionarMateriaViewController.h"

@interface ControleDeNotasViewController ()

@end

@implementation ControleDeNotasViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dynamicallyValidateSubject:(id)sender {
	
	if (materiaTextField.text.length == 0) self.navigationItem.rightBarButtonItem.enabled = NO;
	else self.navigationItem.rightBarButtonItem.enabled = YES;
	
}

- (BOOL) subjectNameIsValid {
	
	for (NSDictionary *dict in arrayMaterias) {
		
		NSString *materia1 = materiaTextField.text;
		materia1 = [materia1 lowercaseString];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"i" withString:@"i"];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"ú" withString:@"ú"];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
		materia1 = [materia1 stringByReplacingOccurrencesOfString:@"ã" withString:@"a"];
		
		NSString *materia2 = [dict objectForKey:@"Materia"];
		materia2 = [materia2 lowercaseString];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"i" withString:@"i"];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"ú" withString:@"ú"];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
		materia2 = [materia2 stringByReplacingOccurrencesOfString:@"ã" withString:@"a"];
		
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
		
		if (darkView == nil) {
			darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
			darkView.backgroundColor = [UIColor blackColor];
			[self.view addSubview:darkView];
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
		darkView.alpha = 0.5;
		adicionarMateriaView.frame = CGRectMake(0, 0, 320, 44);
		
		[UIView commitAnimations];
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" style:UIBarButtonItemStyleDone target:self action:@selector(saveSubject)];
		self.navigationItem.rightBarButtonItem.enabled = NO;
		
		[materiaTextField becomeFirstResponder];
	}
	else {
		[materiaTextField resignFirstResponder];
		
		[self.view addSubview:darkView];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		
		self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
		darkView.alpha = 0.0;
		adicionarMateriaView.frame = CGRectMake(0, 0, 320, 44);
		
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		adicionarMateriaView.frame = CGRectMake(0, -44, 320, 44);
		[UIView commitAnimations];
		
		[adicionarMateriaView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
		[materiaTextField performSelector:@selector(setText:) withObject:@"" afterDelay:0.2];
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject)];
		self.tableView.scrollEnabled = YES;
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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
	}
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFDDD5B);
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	self.navigationItem.title = @"Matérias";
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject)];
	
	plistManager = [[GVPlistPersistence alloc] init];
	arrayMaterias = [NSMutableArray arrayWithArray:[plistManager databaseWithName:Database]];
	
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
