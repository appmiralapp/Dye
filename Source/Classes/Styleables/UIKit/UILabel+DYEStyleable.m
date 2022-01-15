//
//  UILabel+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 27/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>

#import "UILabel+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEPrivateHeader.h"
#import "NSMutableAttributedString+DYEStyleable.h"



#pragma mark - UILabel DYEStyleable Category -

@implementation UILabel (DYEStyleable)

#pragma mark Swizzle Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dye_extendsSetText];
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



#pragma mark Overridden Methods

- (void)dye_setText:(NSString *)text {
    [self dye_setText:text];
    
    [self dye_updateStyling];
}



#pragma mark Update Styling

- (void)dye_updateStyling {
    [super dye_updateStyling];
    
    NSString *styleName = [self dye_isFocused] ? self.dyeFocusedStyleName : self.dyeStyleName;
    DYEStyle *style = [DYEStyle styleNamed:styleName];
    
    if (style)
    {
        // Background
        // This is here because labels with a nil background color that are created in code get a black background by default
        if (!style.backgroundColor) {
            self.backgroundColor = [UIColor clearColor];
        }
        
        // Font
        self.font = style.font;
        
        // Text Color
        self.textColor = style.primaryColor;
        
        // Get text for this label
        NSString *textString = self.attributedText.string;
        if (!textString) {
            textString = self.text;
        }
        
        if (textString) {
            // If no attributed string yet, create one
            NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
            if (!attributedString)
                attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
            
            if ([attributedString length] > 0) {
                attributedString.dyeLineBreakMode = self.lineBreakMode;
                attributedString.dyeStyleName = self.dyeStyleName;
                
                NSRangePointer range = NULL;
                NSMutableParagraphStyle* paragraphStyle = [[attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:range] mutableCopy];
                
                paragraphStyle.alignment = self.textAlignment;
                paragraphStyle.lineBreakMode = self.lineBreakMode;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
            }
        
            // Set the attributed text
            self.attributedText = attributedString;
        }
    }
}

@end
