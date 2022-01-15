//
//  UIButton+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 05/03/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>

#import "UIButton+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEStyleable.h"
#import "UIControl+DYEPrivateHeader.h"
#import "NSMutableAttributedString+DYEStyleable.h"

static void * kDYEStyleNamePropertyKey = &kDYEStyleNamePropertyKey;
static void * kDYEStyleHighlightedNamePropertyKey = &kDYEStyleHighlightedNamePropertyKey;
static void * kDYEStyleSelectedNamePropertyKey = &kDYEStyleSelectedNamePropertyKey;
static void * kDYEStyleDisabledNamePropertyKey = &kDYEStyleDisabledNamePropertyKey;
static void * kDYEStyleFocusedNamePropertyKey = &kDYEStyleFocusedNamePropertyKey;



#pragma mark - UIButton DYEStyleable Category -

@implementation UIButton (DYEStyleable)

#pragma mark Swizzle Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dye_extendsSetTitle];
        [self dye_extendsSetAttributedTitle];
    });
}

+ (void)dye_extendsSetTitle {
    Class thisClass = self;
    
    SEL setTitleSEL = @selector(setTitle:forState:);
    Method setTitleMethod = class_getInstanceMethod(thisClass, setTitleSEL);
    
    SEL dye_setTitleSEL = @selector(dye_setTitle:forState:);
    Method dye_setTitleMethod = class_getInstanceMethod(thisClass, dye_setTitleSEL);
    
    method_exchangeImplementations(setTitleMethod, dye_setTitleMethod);
}

+ (void)dye_extendsSetAttributedTitle {
    Class thisClass = self;
    
    SEL setAttributedTitleSEL = @selector(setAttributedTitle:forState:);
    Method setAttributedTitleMethod = class_getInstanceMethod(thisClass, setAttributedTitleSEL);
    
    SEL dye_setAttributedTitleSEL = @selector(dye_setAttributedTitle:forState:);
    Method dye_setAttributedTitleMethod = class_getInstanceMethod(thisClass, dye_setAttributedTitleSEL);
    
    method_exchangeImplementations(setAttributedTitleMethod, dye_setAttributedTitleMethod);
}



#pragma mark Overridden Methods

- (void)dye_setTitle:(NSString *)title forState:(UIControlState)controlState {
    [self dye_setTitle:title forState:controlState];
    
    NSMutableAttributedString *attributedString = nil;
    if (title) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    }
    
    DYEStyle *style = [self dye_styleForState:controlState];
    [self dye_updateTitle:attributedString forStyle:style state:controlState];
}

- (void)dye_setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)controlState {
    [self dye_setAttributedTitle:title forState:controlState];
    
    DYEStyle *style = [self dye_styleForState:controlState];
    [self dye_updateTitle:[title mutableCopy] forStyle:style state:controlState];
}



#pragma mark Responding to State Changes

- (void)dye_didChangeHighlightedState:(BOOL)highlighted {
#if TARGET_OS_TV
    BOOL animated = YES;
    if (animated) {
        [UIView animateWithDuration:0.11 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self dye_updateStyling];
        } completion:nil];
    } else {
        [self dye_updateStyling];
    }
#else
    [self dye_updateStyling];
#endif
}



#pragma mark Update Styling

- (void)dye_updateStyling {
    [super dye_updateStyling];
}

- (void)dye_updateControlForStyle:(DYEStyle *)style state:(UIControlState)state {
    [super dye_updateControlForStyle:style state:state];
    
    if (style) {
        NSString *title = [self titleForState:state];
        NSMutableAttributedString *attributedString = [[self attributedTitleForState:state] mutableCopy];

        if (title && (!attributedString || (attributedString && ![[attributedString string] isEqualToString:title]))) {
            attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        }
        
        [self dye_updateTitle:attributedString forStyle:style state:state];
    }
}

- (void)dye_updateTitle:(NSMutableAttributedString*)attributedString forStyle:(DYEStyle*)style state:(UIControlState)state {
    if (style) {
        // Title font
        self.titleLabel.font = style.font;
        
        // Title
        if (attributedString) {
            if ([attributedString length] > 0) {
                attributedString.dyeLineBreakMode = self.titleLabel.lineBreakMode;
                attributedString.dyeStyleName = style.dyeStyleName;
                
                NSRangePointer range = NULL;
                NSMutableParagraphStyle *paragraphStyle = [[attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:range] mutableCopy];
                
                paragraphStyle.alignment = self.titleLabel.textAlignment;
                paragraphStyle.lineBreakMode = self.titleLabel.lineBreakMode;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
            }
            
            [UIView performWithoutAnimation:^{
                [self dye_setAttributedTitle:attributedString forState:state];
            }];
        }
    }
}

@end
