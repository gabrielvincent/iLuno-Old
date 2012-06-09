//
//  FormspringQuestionViewController.h
//  iLuno
//
//  Created by Gabriel Vincent on 08/06/12.
//  Copyright (c) 2012 _A_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormspringQuestionViewController : UIViewController {
	IBOutlet UITextView *textView;
}

@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *askedBy;
@property (nonatomic, retain) NSString *time;

@end
