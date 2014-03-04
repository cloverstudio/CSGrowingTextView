//
//  CSKeyboardViewController.h
//  CSGrowingTextView
//
//  Created by Josip Bernat on 04/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSGrowingTextView.h"

@interface CSKeyboardViewController : UIViewController <CSGrowingTextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet CSGrowingTextView *growingTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *growintTextViewHeightConstraint;

@end
