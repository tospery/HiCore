//
//  UITextView+Utils.m
//  HiUtils
//
//  Created by 杨建祥 on 2024/5/16.
//

#import "UITextView+Utils.h"
#import <objc/runtime.h>

@implementation UITextView (Frame)

#pragma mark - Swizzle Dealloc

+ (void)load {
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (textView) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}


#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`

+ (UIColor *)defaultPlaceholderColor {
    if (@available(iOS 13, *)) {
      SEL selector = NSSelectorFromString(@"placeholderTextColor");
      if ([UIColor respondsToSelector:selector]) {
        return [UIColor performSelector:selector];
      }
    }
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        NSDictionary *attributes = [textField.attributedPlaceholder attributesAtIndex:0 effectiveRange:nil];
        color = attributes[NSForegroundColorAttributeName];
        if (!color) {
          color = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
        }
    });
    return color;
}


#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.lineFragmentPadding",
             @"textContainer.exclusionPaths"];
}


#pragma mark - Properties
#pragma mark `placeholderTextView`

- (UITextView *)placeholderTextView {
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (!textView) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;

        textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [self.class defaultPlaceholderColor];
        textView.userInteractionEnabled = NO;
        textView.isAccessibilityElement = NO;
        objc_setAssociatedObject(self, @selector(placeholderTextView), textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        self.needsUpdateFont = YES;
        [self updatePlaceholderTextView];
        self.needsUpdateFont = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderTextView)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return textView;
}


#pragma mark `placeholder`

- (NSString *)placeholder {
    return self.placeholderTextView.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderTextView.text = placeholder;
    [self updatePlaceholderTextView];
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderTextView.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderTextView.attributedText = attributedPlaceholder;
    [self updatePlaceholderTextView];
}

#pragma mark `placeholderColor`

- (UIColor *)placeholderColor {
    return self.placeholderTextView.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderTextView.textColor = placeholderColor;
}


#pragma mark `needsUpdateFont`

- (BOOL)needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderTextView];
}


#pragma mark - Update

- (void)updatePlaceholderTextView {
    if (self.text.length) {
        [self.placeholderTextView removeFromSuperview];
        self.accessibilityValue = self.text;
    } else {
        [self insertSubview:self.placeholderTextView atIndex:0];
        self.accessibilityValue = self.placeholder;
    }

    if (self.needsUpdateFont) {
        self.placeholderTextView.font = self.font;
        self.needsUpdateFont = NO;
    }
    if (self.placeholderTextView.attributedText.length == 0) {
      self.placeholderTextView.textAlignment = self.textAlignment;
    }
    self.placeholderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
    self.placeholderTextView.textContainerInset = self.textContainerInset;
    self.placeholderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    self.placeholderTextView.frame = self.bounds;
}

@end
