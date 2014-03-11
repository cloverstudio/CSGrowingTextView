//
//  CSKeyboardViewController.m
//  CSGrowingTextView
//
//  Created by Josip Bernat on 04/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import "CSKeyboardViewController.h"

@interface CSKeyboardViewController ()

@end

@implementation CSKeyboardViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    self.growingTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    __weak id this = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                    
                                                      __strong CSKeyboardViewController *strongThis = this;
                                                      [strongThis keyboardWillAppearNotification:note];
                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

#pragma mark - Layout Changes

- (void)keyboardWillAppearNotification:(NSNotification *)note {
    
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect contentViewFrame = self.view.bounds;
    
    BOOL isKeyboardShown = (CGRectGetMinY(keyboardFrame) < CGRectGetHeight([[UIScreen mainScreen] bounds]));
    if (isKeyboardShown) {
        contentViewFrame.size.height -= CGRectGetHeight(keyboardFrame);
    }
    
    [self adjustTableViewFrame:contentViewFrame
          keyboardNotification:note];
}

- (void)adjustTableViewFrame:(CGRect)frame
        keyboardNotification:(NSNotification *)note {
    
    UIViewAnimationOptions animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak id this = self;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurve
                     animations:^{
                         
                         __strong CSKeyboardViewController *strongThis = this;
                         
                         self.contentViewBottomConstraint.constant = CGRectGetHeight(strongThis.view.bounds) - CGRectGetMaxY(frame);
                         [strongThis.contentView setNeedsUpdateConstraints];
                         [strongThis.contentView.superview layoutIfNeeded];
                     } completion:nil];
}


#pragma mark - CSGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(CSGrowingTextView *)textView {
    [textView resignFirstResponder];
    
    self.textView.text = textView.internalTextView.text;
    
    return YES;
}

- (void)growingTextView:(CSGrowingTextView *)growingTextView willChangeHeight:(CGFloat)height {

    __weak id this = self;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         __strong CSKeyboardViewController *strongThis = this;
                         
                         strongThis.growingTextViewHeightConstraint.constant = height;
                         [strongThis.growingTextView setNeedsUpdateConstraints];
                         [strongThis.growingTextView.superview layoutIfNeeded];
                     } completion:nil];
}

@end
