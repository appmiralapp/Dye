//
//  UIControl+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 06/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "UIControl+DYEStyleable.h"

#import "NSDictionary+DyeTypeSafety.h"
#import "UIView+DYEPrivateHeader.h"
#import "DYEStyle+DYEPrivateHeader.h"
#import "UIControl+DYEPrivateHeader.h"

static void * kDYEStyleDictionaryPropertyKey = &kDYEStyleDictionaryPropertyKey;
static void * kDYEStyleUseDefaultHighlightedPropertyKey = &kDYEStyleUseDefaultHighlightedPropertyKey;
static void * kDYEStyleUseDefaultDisabledPropertyKey = &kDYEStyleUseDefaultDisabledPropertyKey;



#pragma mark - UIControl DYEStyleable Category -

@implementation UIControl (DYEStyleable)

#pragma mark Swizzle Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dye_extendsSetHighlighted];
        [self dye_extendsSetSelected];
        [self dye_extendsSetEnabled];
    });
}

+ (void)dye_extendsSetHighlighted {
    Class thisClass = self;
    
    SEL setHighlightedSEL = @selector(setHighlighted:);
    Method setHighlightedMethod = class_getInstanceMethod(thisClass, setHighlightedSEL);
    
    SEL dye_setHighlightedSEL = @selector(dye_setHighlighted:);
    Method dye_setHighlightedMethod = class_getInstanceMethod(thisClass, dye_setHighlightedSEL);
    
    method_exchangeImplementations(setHighlightedMethod, dye_setHighlightedMethod);
}

+ (void)dye_extendsSetSelected {
    Class thisClass = self;
    
    SEL setSelectedSEL = @selector(setSelected:);
    Method setSelectedMethod = class_getInstanceMethod(thisClass, setSelectedSEL);
    
    SEL dye_setSelectedSEL = @selector(dye_setSelected:);
    Method dye_setSelectedMethod = class_getInstanceMethod(thisClass, dye_setSelectedSEL);
    
    method_exchangeImplementations(setSelectedMethod, dye_setSelectedMethod);
}

+ (void)dye_extendsSetEnabled {
    Class thisClass = self;
    
    SEL setEnabledSEL = @selector(setEnabled:);
    Method setEnabledMethod = class_getInstanceMethod(thisClass, setEnabledSEL);
    
    SEL dye_setEnabledSEL = @selector(dye_setEnabled:);
    Method dye_setEnabledMethod = class_getInstanceMethod(thisClass, dye_setEnabledSEL);
    
    method_exchangeImplementations(setEnabledMethod, dye_setEnabledMethod);
}



#pragma mark State Change

- (void)dye_setHighlighted:(BOOL)highlighted {
    UIControlState state = self.state;
    [self dye_setHighlighted:highlighted];
    
    if (state != self.state) {
        [self dye_didChangeHighlightedState:highlighted];
    }
}

- (void)dye_setSelected:(BOOL)selected {
    UIControlState state = self.state;
    [self dye_setSelected:selected];
    
    if (state != self.state) {
        [self dye_didChangeSelectedState:selected];
    }
}

- (void)dye_setEnabled:(BOOL)enabled {
    UIControlState state = self.state;
    [self dye_setEnabled:enabled];
    
    if (state != self.state) {
        [self dye_didChangeEnabledState:enabled];
    }
}



#pragma mark Responding to State Changes

- (void)dye_didChangeHighlightedState:(BOOL)highlighted {
    [self dye_updateStyling];
}

- (void)dye_didChangeSelectedState:(BOOL)selected {
    [self dye_updateStyling];
}

- (void)dye_didChangeEnabledState:(BOOL)enabled {
    [self dye_updateStyling];
}



#pragma mark Get & Set Style

- (NSString *)dyeStyleNameForControlState:(UIControlState)state {
    NSMutableDictionary *dyeStyleDictionary = [self dyeStyleDictionary];
    NSString* styleName = [dyeStyleDictionary dye_stringForKeyOrNil:[NSNumber numberWithInteger:state]];
    return styleName;
}

- (void)setDyeStyleName:(NSString *)dyeStyleName forState:(UIControlState)state {
    // Temporarily remove self as a styleable to avoid any auto updates
    [DYEStyle removeStyleable:self];
    
    // Set the style name
    NSMutableDictionary *dyeStyleDictionary = [self dyeStyleDictionary];
    if (dyeStyleName) {
        [dyeStyleDictionary setObject:dyeStyleName forKey:[NSNumber numberWithInteger:state]];
    } else {
        [dyeStyleDictionary removeObjectForKey:[NSNumber numberWithInteger:state]];
    }
    
    // Update styling for the set state
    DYEStyle *style = [self dye_styleForState:state];
    [self dye_updateControlForStyle:style state:state];
    
    // Update styling for the current state just in case
    [self dye_updateStyling];

    // Add to styleables if required
    if ([dyeStyleDictionary count] > 0) {
        [DYEStyle addStyleable:self];
    }
}

- (NSString *)dyeStyleName {
    NSString *dyeStyleName = [self dyeStyleNameForControlState:UIControlStateNormal];
    return dyeStyleName;
}

- (void)setDyeStyleName:(NSString *)dyeStyleName {
    [self setDyeStyleName:dyeStyleName forState:UIControlStateNormal];
}

- (NSString *)dyeHighlightedStyleName {
    NSString *dyeStyleName = [self dyeStyleNameForControlState:UIControlStateHighlighted];
    return dyeStyleName;
}

- (void)setDyeHighlightedStyleName:(NSString *)dyeHighlightedStyleName {
    [self setDyeStyleName:dyeHighlightedStyleName forState:UIControlStateHighlighted];
    [self setDyeStyleName:dyeHighlightedStyleName forState:(UIControlStateHighlighted | UIControlStateFocused)];
}

- (NSString *)dyeSelectedStyleName {
    NSString *dyeStyleName = [self dyeStyleNameForControlState:UIControlStateSelected];
    return dyeStyleName;
}

- (void)setDyeSelectedStyleName:(NSString *)dyeSelectedStyleName {
    [self setDyeStyleName:dyeSelectedStyleName forState:UIControlStateSelected];
}

- (NSString *)dyeDisabledStyleName {
    NSString *dyeStyleName = [self dyeStyleNameForControlState:UIControlStateDisabled];
    return dyeStyleName;
}

- (void)setDyeDisabledStyleName:(NSString *)dyeDisabledStyleName {
    [self setDyeStyleName:dyeDisabledStyleName forState:UIControlStateDisabled];
}

- (NSString *)dyeFocusedStyleName {
    NSString *dyeStyleName = [self dyeStyleNameForControlState:UIControlStateFocused];
    return dyeStyleName;
}

- (void)setDyeFocusedStyleName:(NSString *)dyeFocusedStyleName {
    [self setDyeStyleName:dyeFocusedStyleName forState:UIControlStateFocused];
}

- (NSString *)dyeSelectedHighlightedStyleName {
    NSString *dyeStyleName = [self dyeStyleNameForControlState:(UIControlStateSelected | UIControlStateHighlighted)];
    return dyeStyleName;
}

- (void)setDyeSelectedHighlightedStyleName:(NSString *)dyeSelectedHighlightedStyleName {
    [self setDyeStyleName:dyeSelectedHighlightedStyleName forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [self setDyeStyleName:dyeSelectedHighlightedStyleName forState:(UIControlStateSelected | UIControlStateHighlighted | UIControlStateFocused)];
}

- (NSString *)dyeSelectedDisabledStyleName {
    NSString* dyeStyleName = [self dyeStyleNameForControlState:(UIControlStateSelected | UIControlStateDisabled)];
    return dyeStyleName;
}

- (void)setDyeSelectedDisabledStyleName:(NSString *)dyeSelectedDisabledStyleName {
    [self setDyeStyleName:dyeSelectedDisabledStyleName forState:(UIControlStateSelected | UIControlStateDisabled)];
}

- (NSString *)dyeSelectedFocusedStyleName {
    NSString* dyeStyleName = [self dyeStyleNameForControlState:(UIControlStateSelected | UIControlStateFocused)];
    return dyeStyleName;
}

- (void)setDyeSelectedFocusedStyleName:(NSString *)dyeSelectedFocusedStyleName {
    [self setDyeStyleName:dyeSelectedFocusedStyleName forState:(UIControlStateSelected | UIControlStateFocused)];
}

- (BOOL)dyeUseDefaultHighlightedStyle {
    BOOL useDefaultHighlightedStyle = YES;
    NSNumber* useDefault = objc_getAssociatedObject(self, kDYEStyleUseDefaultHighlightedPropertyKey);
    if (useDefault) {
        useDefaultHighlightedStyle = [useDefault boolValue];
    }
    
    return useDefaultHighlightedStyle;
}

- (void)setDyeUseDefaultHighlightedStyle:(BOOL)dyeUseDefaultHighlightedStyle {
    objc_setAssociatedObject(self, kDYEStyleUseDefaultHighlightedPropertyKey, @(dyeUseDefaultHighlightedStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)dyeUseDefaultDisabledStyle {
    BOOL useDefaultDisabledStyle = YES;
    NSNumber* useDefault = objc_getAssociatedObject(self, kDYEStyleUseDefaultDisabledPropertyKey);
    if (useDefault) {
        useDefaultDisabledStyle = [useDefault boolValue];
    }
    
    return useDefaultDisabledStyle;
}

- (void)setDyeUseDefaultDisabledStyle:(BOOL)dyeUseDefaultDisabledStyle {
    objc_setAssociatedObject(self, kDYEStyleUseDefaultDisabledPropertyKey, @(dyeUseDefaultDisabledStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
}



#pragma mark Additional Properties

- (NSMutableDictionary *)dyeStyleDictionary {
    NSMutableDictionary *dyeStyleDictionary = objc_getAssociatedObject(self, kDYEStyleDictionaryPropertyKey);
    if (!dyeStyleDictionary) {
        dyeStyleDictionary = [NSMutableDictionary new];
        objc_setAssociatedObject(self, kDYEStyleDictionaryPropertyKey, dyeStyleDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dyeStyleDictionary;
}



#pragma mark Update Styling

- (void)dye_updateStyling {
    // Don't call super, instead update the view for the style of the current state
    DYEStyle *style = [self dye_styleForState:self.state];

    [self dye_updateViewForStyle:style];
    [self dye_updateControlForStyle:style state:self.state];
}

- (void)dye_updateControlForStyle:(DYEStyle *)style state:(UIControlState)state {
    
}

- (DYEStyle *)dye_styleForState:(UIControlState)state {
    NSString *styleName = [self dyeStyleNameForControlState:state];
    DYEStyle *style = [DYEStyle styleNamed:styleName];
    
    if (!style) {
        NSString *normalStyleName = [self dyeStyleNameForControlState:UIControlStateNormal];
        NSString *selectedStyleName = [self dyeStyleNameForControlState:UIControlStateSelected];
        
        DYEStyle *normalStyle = [DYEStyle styleNamed:normalStyleName];
        DYEStyle *selectedStyle = [DYEStyle styleNamed:selectedStyleName];
        
        // State contains selected + highlighted, use selected style + darker
        if ((state & UIControlStateSelected) != 0 && (state & UIControlStateHighlighted) != 0 && selectedStyle) {
            style = [selectedStyle darkerStyle];
        }
        // State contains selected + disabled, use selected style + lighter
        else if ((state & UIControlStateSelected) != 0 && (state & UIControlStateDisabled) != 0 && selectedStyle) {
            style = [selectedStyle lighterStyle];
        }
        // State contains highlighted, use normal style + darker
        else if ((state & UIControlStateHighlighted) != 0 && normalStyle) {
            style = [normalStyle darkerStyle];
        }
        // State contains disabled, use normal style + lighter
        else if ((state & UIControlStateDisabled) != 0 && normalStyle) {
            style = [normalStyle lighterStyle];
        }
    }
    
    return style;
}

@end
