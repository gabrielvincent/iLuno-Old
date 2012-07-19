//
//  LoadingView.m
//  RioGastronomia
//
//  Created by Gabriel Vincent on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define messageLabelOriginY messageLabel.frame.origin.y
#define messageLabelWidth messageLabel.frame.size.width
#define messageLabelHeight messageLabel.frame.size.height

#define spinnerOriginY spinner.frame.origin.y
#define spinnerHeight spinner.frame.size.height
#define spinnerWidth spinner.frame.size.width

#import "LoadingView.h"

@implementation LoadingView
@synthesize labelString, spinner, reloadImage, messageLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithLabel:(NSString *) label {
    self = [super init];
    if (self) {
        labelString = label;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	
	NSLog(@"DrawRect");
	
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.75;
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.shadowColor = [UIColor blackColor];
    messageLabel.shadowOffset = CGSizeMake(0, -1);
    messageLabel.text = labelString;
	messageLabel.font = [UIFont boldSystemFontOfSize:14];
    
    if (reloadImage == nil) {
		spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[self addSubview:spinner];
	}
	
    [self addSubview:messageLabel];
	[spinner startAnimating];
}

- (void) setRealoadWithLabel:(NSString *) label AndImage:(UIImage *) image {
	
	NSLog(@"Reload");
	
	labelString = label;
	
	if (reloadImage) [reloadImage removeFromSuperview];
	reloadImage = [[UIImageView alloc] initWithImage:image];
	reloadImage.frame = CGRectMake(10, 10, 20, 23);
	
	[self addSubview:reloadImage];
	[spinner removeFromSuperview];
}

- (void) setLoadingWithLabel:(NSString *)label {
	
	NSLog(@"SetLoading");
	
	messageLabel.text = label;

	spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
	spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	spinner.center = reloadImage.center;
	spinner.alpha = 0.0;
	[spinner startAnimating];
	[self addSubview:spinner];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.4];
	reloadImage.transform = CGAffineTransformMakeRotation(2);
    reloadImage.alpha = 0.0;
	spinner.alpha = 1.0;
	[UIView commitAnimations];
	
	[reloadImage performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
}


@end
