//
//  HomeScreenViewController.m
//  iLuno
//
//  Created by Gabriel Vincent on 06/04/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "HorariosViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)scrollViewDidScroll:(UIScrollView *)sender {
//	
//    float offset = scrollView.contentOffset.y;
//	offset *= -1;
//	
//	if (offset >= 70) {
//		[self showSpecifiedViewController:iconId];
//		[self leaveHomeScreen];
//	}
//	
//}

- (IBAction)highlightButton:(id)sender {
	horariosButton.imageView.image = [UIImage imageNamed:@"highlightButton.png"];
}

- (void) showSpecifiedViewController:(NSString *) viewController {
	
	navigationHorarios.view.alpha = 0.0;
	navigationCalendarios.view.alpha = 0.0;
	navigationMedias.view.alpha = 0.0;
	navigationRedes.view.alpha = 0.0;
	navigationControle.view.alpha = 0.0;
	videos.alpha = 0.0;
	login.view.alpha = 0.0;
	configuracoes.view.alpha = 0.0;
	
	// Horários
	if ([viewController isEqualToString:@"horarios"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:navigationHorarios.view];
			navigationHorarios.view.alpha = 1.0;
			[horarios viewWillAppear:YES];
		}
		else {
			horarios = [[HorariosViewController alloc] initWithStyle:UITableViewStyleGrouped];
			mostraHorarios = [[MostraHorariosViewController alloc] initWithStyle:UITableViewStyleGrouped];
			navigationHorarios = [[UINavigationController alloc] initWithRootViewController:horarios];
			navigationHorarios.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:navigationHorarios.view];
		}
	}
	// Calendários
	else if ([viewController isEqualToString:@"calendarios"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:navigationCalendarios.view];
			navigationCalendarios.view.alpha = 1.0;
			[calendariosDetail viewWillArtificiallyAppear];
		}
		else {
			calendarios = [[CalendariosViewController alloc] initWithStyle:UITableViewStyleGrouped];
			calendariosDetail = [[CalendariosDetailViewController alloc] init];
			navigationCalendarios = [[UINavigationController alloc] initWithRootViewController:calendarios];
			navigationCalendarios.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:navigationCalendarios.view];
		}
	}
	// Médias
	else if ([viewController isEqualToString:@"medias"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:navigationMedias.view];
			navigationMedias.view.alpha = 1.0;
		}
		else {
			medias = [[MediasViewController alloc] initWithStyle:UITableViewStyleGrouped];
			navigationMedias = [[UINavigationController alloc] initWithRootViewController:medias];
			navigationMedias.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:navigationMedias.view];
		}
	}
	// Redes Sociais
	else if ([viewController isEqualToString:@"redes"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:navigationRedes.view];
			navigationRedes.view.alpha = 1.0;
		}
		else {
			redes = [[RedesSociaisViewController alloc] init];
			navigationRedes = [[UINavigationController alloc] initWithRootViewController:redes];
			navigationRedes.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:navigationRedes.view];
		}
	}
	// Vídeos
	else if ([viewController isEqualToString:@"videos"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:videos];
			videos.alpha = 1.0;
		}
		else {
			videos = [[UIWebView alloc] init];
			[videos loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://videos.iluno.com.br"]]];
			videos.frame = CGRectMake(0, 0, 320, 400);
			videos.delegate = self;
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:videos];
			spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner.center = videos.center;
			[videos addSubview:spinner];
			[spinner startAnimating];
		}
	}
	// Login
	else if ([viewController isEqualToString:@"login"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:login.view];
			login.view.alpha = 1.0;
		}
		else {
			login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
			login.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:login.view];
		}
	}
	// Controle de Notas
	else if ([viewController isEqualToString:@"controle"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:navigationControle.view];
			navigationControle.view.alpha = 1.0;
		}
		else {
			controle = [[ControleDeNotasViewController alloc] initWithStyle:UITableViewStylePlain];
			navigationControle = [[UINavigationController alloc] initWithRootViewController:controle];
			navigationControle.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:navigationControle.view];
		}
	}
	// Configurações
	else if ([viewController isEqualToString:@"configuracoes"]) {
		if ([[subviewsDict objectForKey:viewController] isEqualToString:@"YES"]) {
			[vuashView bringSubviewToFront:configuracoes.view];
			configuracoes.view.alpha = 1.0;
		}
		else {
			configuracoes = [[ConfiguracoesViewController alloc] init];
			configuracoes.view.frame = CGRectMake(0, 0, 320, 400);
			[subviewsDict setValue:@"YES" forKey:viewController];
			[vuashView addSubview:configuracoes.view];
		}
	}
}

- (void) leaveHomeScreen {
	if (![iconId isEqualToString:@"none"]) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.4];
		
		scrollView.frame = CGRectMake(0, 400, 320, 460);
		menuImage.frame = CGRectMake(5, 0, 312, 316);
		//scrollView.scrollEnabled = NO;
		scrollView.alpha = 0.5;
		//returnToHomeButton.hidden = NO;
		vuashView.frame = CGRectMake(0, 0, 320, 400);
		shadowImage.hidden = NO;
		shadowImage.alpha = 1.0;
		//scrollView.userInteractionEnabled = NO;
		menuIsHidden = YES;
		logoImage.alpha = 0.0;
		
		[UIView commitAnimations];
	}
	else {
		// Same as "returnToHomeScreen"
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.4];
		
		scrollView.frame = CGRectMake(0, 0, 320, 460);
		menuImage.frame = CGRectMake(5, 64, 312, 316);
		scrollView.scrollEnabled = YES;
		scrollView.alpha = 1.0;
		returnToHomeButton.hidden = YES;
		vuashView.frame = CGRectMake(0, -400, 320, 400);
		shadowImage.alpha = 0.0;
		menuIsHidden = NO;
		logoImage.alpha = 1.0;
		
		[UIView commitAnimations];
	}
}

- (IBAction)returnToHomeScreen:(id)sender {
	
	[self setLabels];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.4];
	
	scrollView.frame = CGRectMake(0, 0, 320, 460);
	menuImage.frame = CGRectMake(5, 64, 312, 316);
	scrollView.scrollEnabled = YES;
	scrollView.alpha = 1.0;
	returnToHomeButton.hidden = YES;
	vuashView.frame = CGRectMake(0, -400, 320, 400);
	shadowImage.alpha = 0.0;
	menuIsHidden = NO;
	logoImage.alpha = 1.0;
	
	[UIView commitAnimations];
	
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
	CGPoint translation = [sender translationInView:menuImage];
	scrollView.center = CGPointMake(scrollView.center.x, scrollView.center.y + translation.y);
	[sender setTranslation:CGPointMake(0, 0) inView:self.navigationController.view];
	
	float alpha;
	
	alpha = 400/(400+scrollView.frame.origin.y);
	
	if (alpha <= 1 && alpha >= 0 && ![iconId isEqualToString:@"none"]) {
		scrollView.alpha = alpha;
	}
	
	alpha = scrollView.frame.origin.y/400;
	
	if (alpha <= 1 && alpha >= 0 && ![iconId isEqualToString:@"none"]) {
		shadowImage.hidden = NO;
		shadowImage.alpha = alpha;
	}
	
	if (isFirstScroll && !menuIsHidden) {
		point = [sender locationInView:scrollView];
		x = point.x;
		y = point.y;
		
		// Horários
		if ((x >= 0 && x <= 105) && (y >= 64 && y <= 169)) {
			iconId = @"horarios";
			[self showSpecifiedViewController:@"horarios"];
		}
		//Calendários
		else if ((x >= 106 && x <= 215) && (y >= 64 && y <= 169)) {
			iconId = @"calendarios";
			[self showSpecifiedViewController:@"calendarios"];
		}
		//Médias
		else if ((x >= 216 && x <= 320) && (y >= 64 && y <= 169)) {
			iconId = @"medias";
			[self showSpecifiedViewController:@"medias"];
		}
		//Redes Sociais
		else if ((x >= 0 && x <= 105) && (y >= 170 && y <= 279)) {
			iconId = @"redes";
			[self showSpecifiedViewController:@"redes"];
		}
		//Vídeos
		else if ((x >= 106 && x <= 215) && (y >= 170 && y <= 279)) {
			iconId = @"videos";
			[self showSpecifiedViewController:@"videos"];
		}
		//Folhas _A_Z
		else if ((x >= 216 && x <= 320) && (y >= 170 && y <= 279)) {
			iconId = @"folhas";
			[self showSpecifiedViewController:@"folhas"];
		}
		//Login
		else if ((x >= 0 && x <= 105) && (y >= 280 && y <= 320)) {
			iconId = @"login";
			[self showSpecifiedViewController:@"login"];
		}
		//Controle de Notas
		else if ((x >= 106 && x <= 215) && (y >= 280 && y <= 320)) {
			iconId = @"controller";
			[self showSpecifiedViewController:@"controle"];
		}
		//Configurações
		else if ((x >= 216 && x <= 320) && (y >= 280 && y <= 375)) {
			iconId = @"configuracoes";
			[self showSpecifiedViewController:@"configuracoes"];
			higlightImage.frame = CGRectMake(210, 268, 86, 83);
		}
		else {
			iconId = @"none";
			
			navigationHorarios.view.alpha = 0.0;
			navigationCalendarios.view.alpha = 0.0;
			navigationMedias.view.alpha = 0.0;
			navigationRedes.view.alpha = 0.0;
			videos.alpha = 0.0;
		}
		
		NSLog(@"IconID: %@", iconId);
		
		isFirstScroll = NO;
	}
	
	if ((persistentY >= 400 && translation.y > 0) || (persistentY <= 0 && translation.y < 0)) translation = CGPointMake(0, 0);
	else persistentY += translation.y;
	
	if (panRecognizer.state == UIGestureRecognizerStateEnded) {
		if (menuIsHidden) {
			if (scrollView.frame.origin.y <= 330) [self returnToHomeScreen:sender];
			else if (scrollView.frame.origin.y > 480 || scrollView.frame.origin.y > 330) [self leaveHomeScreen];
		}
		else {
			if (scrollView.frame.origin.y >= 50) [self leaveHomeScreen];
			else if (scrollView.frame.origin.y < 0 || scrollView.frame.origin.y < 50 || [iconId isEqualToString:@""]) [self returnToHomeScreen:sender];
		}
		
		isFirstScroll = YES;
	}
	
	vuashView.frame = CGRectMake(0, scrollView.frame.origin.y-400, 320, 400);
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
	
    CGPoint tapPoint = [sender locationInView:scrollView];
	x = tapPoint.x;
	y = tapPoint.y;
	if (menuIsHidden) {
		[self returnToHomeScreen:sender];
	}
	else {
		// Horários
		if ((x >= 0 && x <= 105) && (y >= 64 && y <= 169)) {
			iconId = @"horarios";
			[self showSpecifiedViewController:@"horarios"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(26, 83, 86, 83);
		}
		//Calendários
		else if ((x >= 106 && x <= 215) && (y >= 64 && y <= 169)) {
			iconId = @"calendarios";
			[self showSpecifiedViewController:@"calendarios"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(118, 83, 86, 83);
		}
		//Médias
		else if ((x >= 216 && x <= 320) && (y >= 64 && y <= 169)) {
			iconId = @"medias";
			[self showSpecifiedViewController:@"medias"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(210, 83, 86, 83);
		}
		//Redes Sociais
		else if ((x >= 0 && x <= 105) && (y >= 170 && y <= 279)) {
			iconId = @"redes";
			[self showSpecifiedViewController:@"redes"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(26, 178, 86, 83);
		}
		//Vídeos
		else if ((x >= 106 && x <= 215) && (y >= 170 && y <= 279)) {
			iconId = @"videos";
			[self showSpecifiedViewController:@"videos"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(119, 178, 86, 83);
		}
		//Folhas _A_Z
		else if ((x >= 216 && x <= 320) && (y >= 170 && y <= 279)) {
			iconId = @"folhas";
			[self showSpecifiedViewController:@"folhas"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(210, 178, 86, 83);
		}
		//Login
		else if ((x >= 0 && x <= 105) && (y >= 280 && y <= 375)) {
			iconId = @"login";
			[self showSpecifiedViewController:@"login"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(26, 268, 86, 83);
		}
		//Controle de Notas
		else if ((x >= 106 && x <= 215) && (y >= 280 && y <= 375)) {
			iconId = @"controller";
			[self showSpecifiedViewController:@"controle"];
			//higlightImage.hidden = NO;
			higlightImage.frame = CGRectMake(119, 268, 86, 83);
		}
		//Configurações
		else if ((x >= 216 && x <= 320) && (y >= 280 && y <= 375)) {
			iconId = @"configuracoes";
			[self showSpecifiedViewController:@"configuracoes"];
			higlightImage.frame = CGRectMake(210, 268, 86, 83);
		}
		
		if (![iconId isEqualToString:@""]) [self leaveHomeScreen];
		
	}
}

- (void) setLabels {
	userDefaultsArray = [plistManager databaseWithName:@"UserDefaults"];
	if (userDefaultsArray.count > 0) {
		nameLabel.text = [[userDefaultsArray objectAtIndex:0] objectForKey:@"Nome"];
		if (![[[userDefaultsArray objectAtIndex:0] objectForKey:@"TurmaLabel"] isEqualToString:@""]) {
			serieTurmaLabel.text = [NSString stringWithFormat:@"%@ – %@", [[userDefaultsArray objectAtIndex:0] objectForKey:@"SerieLabel"], [[userDefaultsArray objectAtIndex:0] objectForKey:@"TurmaLabel"]];
		}
		else serieTurmaLabel.text = [[userDefaultsArray objectAtIndex:0] objectForKey:@"SerieLabel"];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	scrollView.frame = CGRectMake(0, 0, 320, 460);
	[scrollView setDelegate:self];
	
	tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
	[scrollView addGestureRecognizer:tapRecognizer];
	[scrollView addGestureRecognizer:panRecognizer];
	subviewsDict = [[NSMutableDictionary alloc] init];
	isFirstScroll = YES;
	iconId = @"none";
	persistentY = 0;
	menuIsHidden = NO;
	plistManager = [[GVPlistPersistence alloc] init];
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	NSString *dateString = [dateFormat stringFromDate:today];
	dateLabel.text = dateString;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSLog(@"Will Appear");
	userDefaultsArray = [plistManager databaseWithName:@"UserDefaults"];
	[self setLabels];

}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (userDefaultsArray.count == 0) {
		ConfiguracoesViewController *modal = [[ConfiguracoesViewController alloc] initWithNibName:@"ConfiguracoesViewController" bundle:nil];
		[self presentModalViewController:modal animated:YES];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 
    return NO;
}

#pragma mark UIWebView delegate Methods

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	[spinner removeFromSuperview];
}

@end
