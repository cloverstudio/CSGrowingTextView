//
//  CSGrowingTextView.m
//  CSGrowingTextView
//
//  Created by Josip Bernat on 01/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import "CSGrowingTextView.h"

#define kPladeholderPadding 8

@interface CSGrowingTextView ()

@end

@implementation CSGrowingTextView

#pragma mark - Memory Management

- (void)dealloc {
    
    [self.textView removeObserver:self
                       forKeyPath:@"font"];
    
    self.textView.delegate = nil;
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

    _minimumNumberOfLines = 1;
    _maximumNumberOfLines = 4;
    _growDirection = CSGrowDirectionUp;
    
    _textView = [[UITextView alloc] initWithFrame:self.bounds];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPladeholderPadding,
                                                                  kPladeholderPadding,
                                                                  CGRectGetWidth(self.frame) - kPladeholderPadding * 2,
                                                                  CGRectGetHeight(self.frame) - kPladeholderPadding * 2)];
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.placeholderLabel.font = self.textView.font;
    self.placeholderLabel.textColor = [UIColor whiteColor];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self insertSubview:self.placeholderLabel belowSubview:self.textView];
    
    [self.textView addObserver:self
                    forKeyPath:@"font"
                       options:0
                       context:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqualToString:@"font"]) {
        [self updateLayout];
    }
}

#pragma mark - Setters

- (void)setMinimumNumberOfLines:(NSUInteger)minimumNumberOfLines {

    NSAssert(!(minimumNumberOfLines > _maximumNumberOfLines), @"minimumNumberOfLines cannot be greater then maximumNumberOfLines");
    _minimumNumberOfLines = (minimumNumberOfLines < _maximumNumberOfLines ?
                             minimumNumberOfLines : 1);
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines {

    NSAssert(!(maximumNumberOfLines < _minimumNumberOfLines), @"maximumNumberOfLines cannot be less then minimumNuberOfLines");
    _maximumNumberOfLines = (maximumNumberOfLines > _minimumNumberOfLines ?
                             _maximumNumberOfLines : 3);
}

#pragma mark - Layout

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self updateLayout];
}

- (void)updateLayout {

    CGRect textViewFrame = CGRectMake(0, 0,
                                      CGRectGetWidth(self.frame),
                                      [self textViewHeight]);
    [self updateFrame:textViewFrame];
    
    self.placeholderLabel.alpha = (self.textView.text.length ? 0.0 : 1.0);
}

- (void)updateFrame:(CGRect)frame {

    if (CGRectEqualToRect(frame, self.textView.frame) &&
        CGRectGetHeight(frame) == CGRectGetHeight(self.frame)) {return;}
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)]) {
        [_delegate growingTextView:self
                  willChangeHeight:CGRectGetHeight(frame)];
    }
    
    if (_growDirection == CSGrowDirectionNone) {return;}
    
    CGFloat currentHeight = CGRectGetHeight(self.frame);
    CGFloat newHeight = CGRectGetHeight(frame);
    CGFloat yOrigin = CGRectGetMinY(self.frame);
    
    //Growing
    yOrigin = (_growDirection == CSGrowDirectionUp ?
               yOrigin - abs(newHeight - currentHeight) : yOrigin);
    
    __weak id this = self;
    [UIView animateWithDuration:0.1 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         __strong CSGrowingTextView *strongThis = this;
                         strongThis.frame = CGRectMake(CGRectGetMinX(strongThis.frame),
                                                       CGRectGetMinY(strongThis.frame),
                                                       CGRectGetWidth(strongThis.frame),
                                                       CGRectGetHeight(frame));
                         
                         strongThis.textView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                         __strong CSGrowingTextView *strongThis = this;
                         
                         if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                             CGRect r = [strongThis.textView caretRectForPosition:strongThis.textView.selectedTextRange.end];
                             CGFloat caretY =  MAX(r.origin.y - strongThis.textView.frame.size.height + r.size.height + 8, 0);
                             if (strongThis.textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
                                 strongThis.textView.contentOffset = CGPointMake(0, caretY);
                             }
                         }
                         
                         if ([(NSObject *)strongThis.delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
                            
                             [strongThis.delegate growingTextView:strongThis
                                                  didChangeHeight:CGRectGetHeight(frame)];
                         }
                     }];
}

#pragma mark - Height

- (CGFloat)textViewHeight {

    CGFloat contentHeight = (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 ?
                             ceilf([self.textView sizeThatFits:self.bounds.size].height) :
                             self.textView.contentSize.height);
    
    
    NSInteger lines = contentHeight / self.textView.font.lineHeight;
    lines = (lines < self.minimumNumberOfLines ? self.minimumNumberOfLines :
             (lines > self.maximumNumberOfLines ? self.maximumNumberOfLines : lines));
    
    UIEdgeInsets iOS6Insets = UIEdgeInsetsMake(-7, 0, -7, 0);
    CGFloat insets = (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 ?
                      self.textView.textContainerInset.top + self.textView.textContainerInset.bottom :
                      -iOS6Insets.top + (-iOS6Insets.bottom));

    CGFloat lineHeight = self.textView.font.lineHeight;
    if (lineHeight) {
        lineHeight = (lineHeight - (NSInteger)lineHeight < 0.5 ?
                      lineHeight - (lineHeight - (NSInteger)lineHeight) + 0.5 :
                      ceil(lineHeight));
        
        return lineHeight * lines + insets;
    }
    else {
        return lineHeight * lines + insets;
    }
}

#pragma mark - Responders

- (BOOL)becomeFirstResponder {
    
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {

    return [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewDidBeginEditing:)]) {
        [_delegate growingTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self updateLayout];
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewDidChange:)]) {
        [_delegate growingTextViewDidChange:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {

    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewDidChangeSelection:)]) {
        [_delegate growingTextViewDidChangeSelection:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
        [_delegate growingTextViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {

    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextView:shouldInteractWithTextAttachment:inRange:)]) {
        return [_delegate growingTextView:self
         shouldInteractWithTextAttachment:textAttachment
                                  inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextView:shouldInteractWithURL:inRange:)]) {
        return [_delegate growingTextView:self
                    shouldInteractWithURL:URL
                                  inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (!_enablesNewlineCharacter && [text isEqualToString:@"\n"]) {
        
        if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewShouldReturn:)]) {
            return ![_delegate growingTextViewShouldReturn:self];
        }
        return NO;
    }
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextView:shouldChangeTextInRange:replacementText:)]) {
        return [_delegate growingTextView:self
                  shouldChangeTextInRange:range
                          replacementText:text];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
        return [_delegate growingTextViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
        return [_delegate growingTextViewShouldEndEditing:self];
    }
    return YES;
}

@end
