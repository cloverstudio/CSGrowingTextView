//
//  CSMultiplyViewController.m
//  CSGrowingTextView
//
//  Created by Josip Bernat on 04/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import "CSMultiplyViewController.h"

@interface CSMultiplyViewController ()

@end

@implementation CSMultiplyViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    self.firstGrowingTextView.delegate = self;
    self.firstGrowingTextView.placeholderLabel.text = @"First description";
    
    self.secondGrowingTextView.delegate = self;
    self.secondGrowingTextView.placeholderLabel.text = @"Second description";
    
    self.thirdGrowingTextView.delegate = self;
    self.thirdGrowingTextView.placeholderLabel.text = @"Third description";
}

#pragma mark - CSGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(CSGrowingTextView *)textView {

    if ([textView isEqual:self.firstGrowingTextView]) {
        [self.secondGrowingTextView becomeFirstResponder];
    }
    else if ([textView isEqual:self.secondGrowingTextView]) {
        [self.thirdGrowingTextView becomeFirstResponder];
    }
    else {
        [self.thirdGrowingTextView resignFirstResponder];
    }
    
    return YES;
}

@end
