//
//  DYEStyle+StringAttributes.m
//  Dye
//
//  Created by David De Bels on 17/09/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEStyle+StringAttributes.h"

#import "NSDictionary+DyeTypeSafety.h"



#pragma mark - DYEStyle StringAttributes Category Implementation -

@implementation DYEStyle (FileImport)

- (NSDictionary<NSAttributedStringKey, id> *)stringAttributes {
    NSMutableDictionary *stringAttributes = [NSMutableDictionary new];
    
    // Foreground color
    if (self.primaryColor) {
        [stringAttributes setObject:self.primaryColor forKey:NSForegroundColorAttributeName];
    }
    
    // Background color
    /* TODO: @david some components (UITextField) use the secondaryColor for other purposes, which this breaks, how to solve this?
    if (self.secondaryColor) {
        [stringAttributes setObject:self.secondaryColor forKey:NSBackgroundColorAttributeName];
    }
     */

    // Font
    if (self.font) {
        DYEFont* font = self.font;
        NSDictionary *fontWeightValues = [[self class] dye_fontWeightValues];
        NSString *fontWeight = [fontWeightValues dye_stringForKeyOrNil:self.fontWeight];
        
        if (fontWeight) {
            DYEFontDescriptor* fontDescriptor = [font.fontDescriptor fontDescriptorByAddingAttributes:@{ @"NSCTFontUIUsageAttribute": fontWeight }];
            font = [DYEFont fontWithDescriptor:fontDescriptor size:0.0];
        }
        
        [stringAttributes setObject:font forKey:NSFontAttributeName];
    }
    
    // Text underline
    if (self.textUnderline) {
        [stringAttributes setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    }
    
    // Text strikethrough
    if (self.textStrikethrough) {
        [stringAttributes setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
    }
    
    // Text stroke
    if (self.textStrokeColor) {
        [stringAttributes setObject:self.textStrokeColor forKey:NSStrokeColorAttributeName];
    }
    if (self.textStrokeWidth > 0) {
        [stringAttributes setObject:@(self.textStrokeWidth*-1) forKey:NSStrokeWidthAttributeName];
    }
    
    // Text shadow
    if (!CGSizeEqualToSize(self.textShadowOffset, CGSizeZero) || self.textShadowRadius > 0) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = self.textShadowRadius;
        shadow.shadowColor = self.textShadowColor;
        shadow.shadowOffset = self.textShadowOffset;
        [stringAttributes setObject:shadow forKey:NSShadowAttributeName];
    }

    // Text character spacing
    if (self.textCharacterSpacing != 0) {
        [stringAttributes setObject:@(self.textCharacterSpacing) forKey:NSKernAttributeName];
    }

    // Paragraph style
    // https://medium.com/@at_underscore/nsparagraphstyle-explained-visually-a8659d1fbd6f
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = self.textLineHeightMultiple;
    if (self.textLineHeight > 0.0) {
        paragraphStyle.minimumLineHeight = self.textLineHeight;
        paragraphStyle.maximumLineHeight = self.textLineHeight;
    }
    [stringAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return stringAttributes;
}

+ (NSDictionary*)dye_fontWeightValues {
    // UltraLight, Thin, Light, Regular, Medium, SemiBold, Bold, Heavy, Black
    return @{ @"UltraLight": @"CTFontUltraLightUsage",
              @"Thin": @"CTFontThinUsage",
              @"Light": @"CTFontLightUsage",
              @"Regular": @"CTFontRegularUsage",
              @"Medium": @"CTFontMediumUsage",
              @"SemiBold": @"CTFontDemiUsage",
              @"Bold": @"CTFontEmphasizedUsage",
              @"Heavy": @"CTFontHeavyUsage",
              @"Black": @"CTFontBlackUsage"
              };
}

@end
