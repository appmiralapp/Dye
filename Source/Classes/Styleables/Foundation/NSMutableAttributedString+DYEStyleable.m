//
//  NSMutableAttributedString+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 05/03/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>

#import "NSMutableAttributedString+DYEStyleable.h"

#import "NSDictionary+DyeTypeSafety.h"
#import "DYEStyle+DYEPrivateHeader.h"
#import "DYEStyle+StringAttributes.h"

static void * kDYEStyleNamePropertyKey = &kDYEStyleNamePropertyKey;
static void * kDYELineBreakModePropertyKey = &kDYELineBreakModePropertyKey;



#pragma mark - NSMutableAttributedString DYEStyleable Category -

@implementation NSMutableAttributedString (DYEStyleable)

#pragma mark Additional Properties

-(NSString *)dyeStyleName
{
    return objc_getAssociatedObject(self, kDYEStyleNamePropertyKey);
}

-(void)setDyeStyleName:(NSString *)styleName
{
    [DYEStyle removeStyleable:self];
    objc_setAssociatedObject(self, kDYEStyleNamePropertyKey, styleName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self dye_updateStyling];
    
    if (styleName)
        [DYEStyle addStyleable:self];
}

-(NSLineBreakMode)dyeLineBreakMode
{
    NSNumber* storedLineBreakMode = objc_getAssociatedObject(self, kDYELineBreakModePropertyKey);
    NSLineBreakMode lineBreakMode = [storedLineBreakMode integerValue];
    return lineBreakMode;
}

-(void)setDyeLineBreakMode:(NSLineBreakMode)dyeLineBreakMode
{
    NSNumber* storeLineBreakMode = [NSNumber numberWithInteger:dyeLineBreakMode];
    objc_setAssociatedObject(self, kDYELineBreakModePropertyKey, storeLineBreakMode, OBJC_ASSOCIATION_ASSIGN);
}



#pragma mark Update Styling

-(void)dye_updateStyling
{
    DYEStyle* style = [DYEStyle styleNamed:self.dyeStyleName];
    if (style)
    {
        NSString* textString = self.string;
        if ([textString length] > 0) {
            // Apply text transform
            NSRange range = NSMakeRange(0, [textString length]);
            if (style.textTransform != DYETextTransformNone) {
                if (style.textTransform == DYETextTransformUppercase) {
                    textString = [textString uppercaseString];
                } else if (style.textTransform == DYETextTransformLowercase) {
                    textString = [textString lowercaseString];
                } else if (style.textTransform == DYETextTransformCapitalize) {
                    textString = [textString capitalizedString];
                }
                
                // TODO: @david, this will modify the original text so once a text transform has been set, it's not possible to revert to the default text (store the original string?)
                [self replaceCharactersInRange:range withString:textString];
            }
        
            // Apply string attributes
            NSMutableDictionary *stringAttributes = [style.stringAttributes mutableCopy];
            NSMutableParagraphStyle *paragraphStyle = [stringAttributes objectForKey:NSParagraphStyleAttributeName];
            paragraphStyle.lineBreakMode = self.dyeLineBreakMode;

            [self setAttributes:stringAttributes range:range];
        }
    }
}

@end
