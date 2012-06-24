//
//  LoadingView.h
//  RioGastronomia
//
//  Created by Gabriel Vincent on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView {
    UILabel *messageLabel;
    UIActivityIndicatorView *spinner;
    NSString *labelString;
	UIImageView *reloadImage;
}

@property (nonatomic, retain) NSString *labelString;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIImageView *reloadImage;
@property (nonatomic, retain) UILabel *messageLabel;

- (id) initWithLabel:(NSString *) label;
- (void) setRealoadWithLabel:(NSString *) label AndImage:(UIImage *) image;
- (void) setLoadingWithLabel:(NSString *)label;

@end
