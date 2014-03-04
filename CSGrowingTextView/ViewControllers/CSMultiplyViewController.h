//
//  CSMultiplyViewController.h
//  CSGrowingTextView
//
//  Created by Josip Bernat on 04/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSGrowingTextView.h"

@interface CSMultiplyViewController : UIViewController <CSGrowingTextViewDelegate>

@property (weak, nonatomic) IBOutlet CSGrowingTextView *firstGrowingTextView;
@property (weak, nonatomic) IBOutlet CSGrowingTextView *secondGrowingTextView;
@property (weak, nonatomic) IBOutlet CSGrowingTextView *thirdGrowingTextView;

@end
