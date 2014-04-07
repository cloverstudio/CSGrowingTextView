CSGrowingTextView
=================

CSGrowingTextView is a iOS text view that sizes while user types using keyboard.

## Usage
You can use it both by code or by Interface Builder, with or without autolayout. Use growDirection to manipulate on what side should CSGrowingTextView grow and growAnimationDuration, growAnimationOptions properties to adjust grow animation.  
In case you want your own growing animation implement CSGrowingTextViewDelegate growingTextView:willChangeHeight method and commit animation as following:
```objective-c
// This example uses autolayout
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
```

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like CSGrowingTextView in your projects.

#### Podfile

```ruby
platform :ios, '6.0'
pod 'CSGrowingTextView', '~> 1.0'
```