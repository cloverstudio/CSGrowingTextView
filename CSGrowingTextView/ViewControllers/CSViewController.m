//
//  CSViewController.m
//  CSGrowingTextView
//
//  Created by Josip Bernat on 01/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import "CSViewController.h"

NSString * const CSSegueMultiplyGrowingTextViews = @"SegueMultiplyGrowingTextViews";
NSString * const CSSegueKeyboardGrowingTextView = @"SegueKeyboardGrowingTextView";

@interface CSViewController ()

@end

@implementation CSViewController

#pragma mark - Button Selectors

- (IBAction)onMultiplyGrowingTextViews:(id)sender {
    
    [self performSegueWithIdentifier:CSSegueMultiplyGrowingTextViews
                              sender:self];
}

- (IBAction)onKeyboardGrowingTextView:(id)sender {

    [self performSegueWithIdentifier:CSSegueKeyboardGrowingTextView
                              sender:self];
}
@end
