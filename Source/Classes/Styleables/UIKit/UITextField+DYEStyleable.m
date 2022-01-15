//
//  UITextField+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 27/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>

#import "UITextField+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEPrivateHeader.h"
#import "UIControl+DYEPrivateHeader.h"
#import "NSMutableAttributedString+DYEStyleable.h"



#pragma mark - UITextField DYEStyleable Category -

@implementation UITextField (DYEStyleable)

#pragma mark Swizzle Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dye_extendsSetText];
        [self dye_extendsSetPlaceholder];
    });
}

+ (void)dye_extendsSetText {
    Class thisClass = self;

    SEL setTextSEL = @selector(setText:);
    Method setTextMethod = class_getInstanceMethod(thisClass, setTextSEL);
    
    SEL dye_setTextSEL = @selector(dye_setText:);
    Method dye_setTextMethod = class_getInstanceMethod(thisClass, dye_setTextSEL);
    
    method_exchangeImplementations(setTextMethod, dye_setTextMethod);
}

+ (void)dye_extendsSetPlaceholder {
    Class thisClass = self;
    
    SEL setPlaceholderSEL = @selector(setPlaceholder:);
    Method setPlaceholderMethod = class_getInstanceMethod(thisClass, setPlaceholderSEL);
    
    SEL dye_setPlaceholderSEL = @selector(dye_setPlaceholder:);
    Method dye_setPlaceholderMethod = class_getInstanceMethod(thisClass, dye_setPlaceholderSEL);
    
    method_exchangeImplementations(setPlaceholderMethod, dye_setPlaceholderMethod);
}



#pragma mark Overridden Methods

- (void)dye_setText:(NSString *)text {
    [self dye_setText:text];
    
    [self dye_updateStyling];
}

- (void)dye_setPlaceholder:(NSString *)placeholder {
    [self dye_setPlaceholder:placeholder];
    
    [self dye_updateStyling];
}



#pragma mark Update Styling

- (void)dye_updateStyling {
    [super dye_updateStyling];
    
    NSString *styleName = [self dyeStyleNameForControlState:self.state];
    DYEStyle *style = [DYEStyle styleNamed:styleName];
    
    if (style) {
        // Font
        self.font = style.font;
        
        // Text Color
        self.textColor = style.primaryColor;
    }
}

- (void)dye_updateControlForStyle:(DYEStyle *)style state:(UIControlState)state {
    [super dye_updateControlForStyle:style state:state];
    
    if (style)
    {
        // Get text for this text field
        NSString* textString = self.attributedText.string;
        if (!textString) {
            textString = self.text;
        }
        
        // Get placeholder for this text field
        NSString *placeholderString = self.attributedPlaceholder.string;
        if (!placeholderString) {
            placeholderString = self.placeholder;
        }
        
        if (textString) {
            // If no attributed string yet, create one
            NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
            if (!attributedString) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
            }
            
            attributedString.dyeStyleName = style.dyeStyleName;
            
            // Set the attributed text
            self.attributedText = attributedString;
        }
        
        if (placeholderString) {
            // If no attributed string yet, create one
            NSMutableAttributedString *attributedString = [self.attributedPlaceholder mutableCopy];
            if (!attributedString) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:placeholderString];
            }
        
            attributedString.dyeStyleName = style.dyeStyleName;
            
            if (style.secondaryColor) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:style.secondaryColor range:NSMakeRange(0, [attributedString length])];
            }
            
            // Set the attributed placeholder
            self.attributedPlaceholder = attributedString;
        }
    }
}

@end
