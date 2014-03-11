//
//  CSGrowingTextView.h
//  CSGrowingTextView
//
//  Created by Josip Bernat on 01/03/14.
//  Copyright (c) 2014 Clover-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSGrowDirection) {
    CSGrowDirectionUp = 0,
    CSGrowDirectionDown,
    CSGrowDirectionNone ///CSGrowingTextView will not grow. Usefull for constraints where UIViewContoller updates height of CSGrowingTextView manually.
};

@protocol CSGrowingTextViewDelegate;

/**
 *  The CSGrowingTextView class implements the behavior for a scrollable, multiline text region that grows / shrinks while adding user inputs new text. Using minimumNumberOfLines and maximumNumberOfLines you limit number of lines displayed without shrinking / growing.
 */

@interface CSGrowingTextView : UIView <UITextViewDelegate>

/**
 *  The receiver’s delegate.
 */
@property (nonatomic, weak) id<CSGrowingTextViewDelegate> delegate;

/**
 *  Text view used for the main textual content of the growint text view. You should be careful with direct changing it's attributes since it may affect growing text view shrinking and growing process.
 */
@property (nonatomic, strong, readonly) UITextView *internalTextView;

/**
 *  Label used for the placeholder textual content of the growing text view.
 */
@property (nonatomic, strong, readonly) UILabel *placeholderLabel;

/**
 *  Minimum number of lines displayed inside growing text view without any more shrinking. Default is 1.
 */
@property (nonatomic, readwrite) NSUInteger minimumNumberOfLines;

/**
 *  Maximum number of lines displayed inside growing text view without any more resizing. Default is 3.
 */
@property (nonatomic, readwrite) NSUInteger maximumNumberOfLines;

/**
 *  Boolean value determening if newline character should be enabled, e.g if newline character should be treated as return key or not. Default value is NO.
 */
@property (nonatomic, readwrite) BOOL enablesNewlineCharacter;

/**
 *  CSGrowDirection value determening in what direction should growing text view grow or shring. Default value is CSGrowDirectionUp.
 */
@property (nonatomic, readwrite) CSGrowDirection growDirection;

/**
 *  Time interval representing grow / shrink animation duration. Default is 0.1.
 */
@property (nonatomic, readwrite) NSTimeInterval growAnimationDuration;

/**
 *  UIViewAnimationOptions used for grow / shring animation. Default is UIViewAnimationOptionCurveEaseInOut.
 */
@property (nonatomic, readwrite) UIViewAnimationOptions growAnimationOptions;

@end

@protocol CSGrowingTextViewDelegate <NSObject>

@optional;

#pragma mark - Responding to Editing Notifications

/**
 *  Asks the delegate if editing should begin in the specified growing text view. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textViewShouldBeginEditing: method call.
 *
 *  @param textView The growing text view for which editing is about to begin.
 *
 *  @return YES if an editing session should be initiated; otherwise, NO to disallow editing.
 */
- (BOOL)growingTextViewShouldBeginEditing:(CSGrowingTextView *)textView;

/**
 *  Tells the delegate that editing of the specified growing text view has begun. Implementation of this method is optional. This method forwards UITextViewDelegate textViewDidBeginEditing: method call.
 *
 *  @param textView The growing text view in which editing began.
 */
- (void)growingTextViewDidBeginEditing:(CSGrowingTextView *)textView;

/**
 *  Asks the delegate if editing should stop in the specified growing text view. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textViewShouldEndEditing: method call.
 *
 *  @param textView The text view for which editing is about to end.
 *
 *  @return YES if editing should stop; otherwise, NO if the editing session should continue.
 */
- (BOOL)growingTextViewShouldEndEditing:(CSGrowingTextView *)textView;

/**
 *  Tells the delegate that editing of the specified growing text view has ended. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textViewDidEndEditing: method call.
 *
 *  @param textView The growing text view in which editing ended.
 */
- (void)growingTextViewDidEndEditing:(CSGrowingTextView *)textView;

/**
 *  Asks the delegate if the growing text field should process the pressing of the return button. Method is called only when enablesNewlineCharacter is set to NO. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned NO.
 *
 *  @param textView The growing text view whose return button was pressed.
 *
 *  @return YES if the growing text view should implement its default behavior for the return button; otherwise, NO.
 */
- (BOOL)growingTextViewShouldReturn:(CSGrowingTextView *)textView;

#pragma mark - Responding to Text Changes

/**
 *  Asks the delegate whether the specified text should be replaced in the text view. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textView:shouldChangeTextInRange:replacementText: method call.
 *
 *  @param textView The text view containing the changes.
 *  @param range    The current selection range. If the length of the range is 0, range reflects the current insertion point. If the user presses the Delete key, the length of the range is 1 and an empty string object replaces that single character.
 *  @param text     The text to insert.
 *
 *  @return YES if the old text should be replaced by the new text; NO if the replacement operation should be aborted.
 */
- (BOOL)growingTextView:(CSGrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/**
 *  Tells the delegate that the text or attributes in the specified growing text view were changed by the user. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textViewDidChange: method call.
 *
 *  @param textView The growing text view containing the changes.
 */
- (void)growingTextViewDidChange:(CSGrowingTextView *)textView;

#pragma mark - Responding to Selection Changes

/**
 *  Tells the delegate that the text selection changed in the specified growing text view. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textViewDidChangeSelection: method call.
 *
 *  @param textView The growing text view whose selection changed.
 */
- (void)growingTextViewDidChangeSelection:(CSGrowingTextView *)textView;

#pragma mark - Interacting with Text Data

/**
 *  Asks the delegate if the specified growing text view should allow user interaction with the provided text attachment in the given range of text. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textView:shouldInteractWithTextAttachment:inRange: method call.
 *
 *  @param textView       The growing text view containing the text attachment.
 *  @param textAttachment The text attachment.
 *  @param characterRange The character range containing the text attachment.
 *
 *  @return YES if interaction with the text attachment should be allowed; NO if interaction should not be allowed.
 */
- (BOOL)growingTextView:(CSGrowingTextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);

/**
 *  Asks the delegate if the specified growing text view should allow user interaction with the given URL in the given range of text. Implementation of this method is optional, if it is not present, editing proceeds as if this method had returned YES. This method forwards UITextViewDelegate textView:shouldInteractWithURL:inRange: method call.
 *
 *  @param textView       The growing text view containing the text attachment.
 *  @param URL            The URL to be processed.
 *  @param characterRange The character range containing the URL.
 *
 *  @return YES if interaction with the URL should be allowed; NO if interaction should not be allowed.
 */
- (BOOL)growingTextView:(CSGrowingTextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);

#pragma mark - Height Notifications

/**
 *  Tells the delegate growing text view is about to change height.
 *
 *  @param growingTextView The growing text view whose height will change.
 *  @param height          The future height of the growing text view.
 */
- (void)growingTextView:(CSGrowingTextView *)growingTextView willChangeHeight:(CGFloat)height;

/**
 *  Tells the delegate growing text view did change height.
 *
 *  @param growingTextView The growing text view whose height did change.
 *  @param height          The new height of the growing text view.
 */
- (void)growingTextView:(CSGrowingTextView *)growingTextView didChangeHeight:(CGFloat)height;

@end
