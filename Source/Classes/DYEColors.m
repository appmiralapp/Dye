//
//  DYEColors.m
//  Dye
//
//  Created by David De Bels on 03/12/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>

#import "DYEColors.h"

#import "NSDictionary+DyeTypeSafety.h"

static void *kDYEColorNamePropertyKey = &kDYEColorNamePropertyKey;



#pragma mark - DYEColor Dye Category Interface -

@implementation DYEColor (Dye)

- (NSString *)dyeColorName {
    
    NSString *dyeColorName = objc_getAssociatedObject(self, kDYEColorNamePropertyKey);
    return dyeColorName;
}

- (void)setDyeColorName:(NSString *)dyeColorName {
    
    objc_setAssociatedObject(self, kDYEColorNamePropertyKey, dyeColorName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



#pragma mark - DYEColors Implementation -

@implementation DYEColors

#pragma mark Manage Colors Cache

+ (NSMutableDictionary *)dye_definedColors {

    static NSMutableDictionary *_dye_definedColors;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dye_definedColors = [[NSMutableDictionary alloc] init];
    });

    return _dye_definedColors;
}

+ (NSDictionary *)availableColors {

    return [[DYEColors dye_definedColors] copy];
}

+ (DYEColor *)colorNamed:(NSString *)colorName {

    DYEColor *color = nil;
    if (colorName) {
        color = [[DYEColors dye_definedColors] objectForKey:colorName];
    }

    return color;
}

+ (void)addColor:(DYEColor *)color withName:(NSString *)colorName {

    if (colorName && [color isKindOfClass:[DYEColor class]]) {
        color.dyeColorName = colorName;
        [[DYEColors dye_definedColors] setObject:color forKey:colorName];
    }
}

+ (void)removeColorWithName:(NSString *)colorName {

    if (colorName) {
        DYEColor *color = [DYEColors colorNamed:colorName];
        color.dyeColorName = nil;
        [[DYEColors dye_definedColors] removeObjectForKey:colorName];
    }
}

+ (void)removeAllColors {

    for (DYEColor *color in [DYEColors dye_definedColors].allValues) {
        color.dyeColorName = nil;
    }
    [[DYEColors dye_definedColors] removeAllObjects];
}



#pragma mark Create Colors

+ (DYEColor *)colorFromObject:(id)object {

    DYEColor *color = nil;

    // If object is a dictionary, parse it to a DYEColor
    if ([object isKindOfClass:[NSDictionary class]]) {
        color = [DYEColors colorFromDictionary:(NSDictionary *)object];
    }
    // If object is a string, assume it's a defined color
    else if ([object isKindOfClass:[NSString class]]) {
        color = [DYEColors colorFromString:(NSString *)object];
    }
    // If object is already a DYEColor, just return it
    else if ([object isKindOfClass:[DYEColor class]]) {
        color = (DYEColor *)object;
    }

    return color;
}

+ (DYEColor *)colorFromString:(NSString *)string {

    DYEColor *color = nil;

    if ([string isKindOfClass:[NSString class]]) {
        color = [DYEColors colorNamed:string];
        if (!color) {
            SEL colorSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", string]);
            if ([DYEColor respondsToSelector:colorSelector]) {
                DYEColor *standardColor = [DYEColor performSelector:colorSelector];
                if ([standardColor isKindOfClass:[DYEColor class]]) {
                    color = standardColor;
                }
            }
        }
    }

    return color;
}

+ (DYEColor *)colorFromDictionary:(NSDictionary *)dictionary {

    DYEColor *color = nil;

    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        // Default alpha is always 1
        CGFloat alpha = 1.0;

        // Check for an alpha component
        NSNumber *alphaComponent = [dictionary dye_numberForKeyOrNil:@"alpha"];
        if (alphaComponent) {
            alpha = [alphaComponent floatValue];
        }

        // Check for an inherited color
        NSString *parentColorName = [dictionary dye_stringForKeyOrNil:@"inherits"];
        DYEColor *parentColor = [DYEColors colorFromString:parentColorName];

        // Check for Hex
        NSString *hexComponent = [dictionary dye_stringForKeyOrNil:@"hex"];

        // Check for RGB
        NSDictionary *rgbDictionary = [dictionary dye_dictionaryForKeyOrNil:@"rgb"];
        NSNumber *rComponent = [rgbDictionary dye_numberForKeyOrNil:@"r"];
        NSNumber *gComponent = [rgbDictionary dye_numberForKeyOrNil:@"g"];
        NSNumber *bComponent = [rgbDictionary dye_numberForKeyOrNil:@"b"];

        // Check for HSV
        NSDictionary *hsvDictionary = [dictionary dye_dictionaryForKeyOrNil:@"hsv"];
        NSNumber *hComponent = [hsvDictionary dye_numberForKeyOrNil:@"h"];
        NSNumber *sComponent = [hsvDictionary dye_numberForKeyOrNil:@"s"];
        NSNumber *vComponent = [hsvDictionary dye_numberForKeyOrNil:@"v"];

        // Check for CMYK
        NSDictionary *cmykDictionary = [dictionary dye_dictionaryForKeyOrNil:@"cmyk"];
        NSNumber *cComponent = [cmykDictionary dye_numberForKeyOrNil:@"c"];
        NSNumber *mComponent = [cmykDictionary dye_numberForKeyOrNil:@"m"];
        NSNumber *yComponent = [cmykDictionary dye_numberForKeyOrNil:@"y"];
        NSNumber *kComponent = [cmykDictionary dye_numberForKeyOrNil:@"k"];

        // Inherited color
        if (parentColor) {
            color = alphaComponent ? [parentColor colorWithAlphaComponent:alpha] : parentColor;
        }
        // Hex (RGB)
        else if ([hexComponent length] == 6) {
            color = [DYEColors colorWithHex:hexComponent alpha:alpha];
        }
        // RGB
        else if (rgbDictionary && rComponent && gComponent && bComponent) {
            color = [DYEColors colorWithRed:[rComponent integerValue] green:[gComponent integerValue] blue:[bComponent integerValue] alpha:alpha];
        }
        // HSB / HSV
        else if (hsvDictionary && hComponent && sComponent && vComponent) {
            color = [DYEColors colorWithHue:[hComponent floatValue] saturation:[sComponent floatValue] brightness:[vComponent floatValue] alpha:alpha];
        }
        // CMYK
        else if (cmykDictionary && cComponent && mComponent && yComponent && kComponent) {
            color = [DYEColors colorWithCyan:[cComponent floatValue] magenta:[mComponent floatValue] yellow:[yComponent floatValue] black:[kComponent floatValue] alpha:alpha];
        }
    }

    return color;
}

+ (DYEColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {

    DYEColor *color = [DYEColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:alpha];
    return color;
}

+ (DYEColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha {

    DYEColor *color = [DYEColor colorWithHue:(hue / 360.0) saturation:saturation brightness:brightness alpha:alpha];
    return color;
}

+ (DYEColor *)colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow black:(CGFloat)black alpha:(CGFloat)alpha {

    CGFloat red = (1-cyan) * (1-black);
    CGFloat green = (1-magenta) * (1-black);
    CGFloat blue = (1-yellow) * (1-black);

    DYEColor *color = [DYEColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

+ (DYEColor *)colorWithHex:(NSString *)hex {

    DYEColor *color = nil;
    CGFloat alpha = 1;

    if ([hex length] == 8) {
        NSString *alphaComponent = [hex substringWithRange:NSMakeRange(6, 2)];

        uint hexAlpha;
        [[NSScanner scannerWithString:alphaComponent] scanHexInt:&hexAlpha];
        alpha = (hexAlpha / 255.0);
    }

    if ([hex length] >= 6) {
        NSString *hexComponent = [hex substringWithRange:NSMakeRange(0, 6)];
        color = [self colorWithHex:hexComponent alpha:alpha];
    }

    return color;
}

+ (DYEColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha {

    DYEColor *color = nil;
    uint red = 0;
    uint green = 0;
    uint blue = 0;
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];

    if ([hex length] == 6 || [hex length] == 8) {
        NSString *redComponent = [hex substringWithRange:NSMakeRange(0, 2)];
        NSString *greenComponent = [hex substringWithRange:NSMakeRange(2, 2)];
        NSString *blueComponent = [hex substringWithRange:NSMakeRange(4, 2)];

        [[NSScanner scannerWithString:redComponent] scanHexInt:&red];
        [[NSScanner scannerWithString:greenComponent] scanHexInt:&green];
        [[NSScanner scannerWithString:blueComponent] scanHexInt:&blue];

        color = [DYEColors colorWithRed:red green:green blue:blue alpha:alpha];
    }

    return color;
}

+ (DYEColor *)darkerColorForColor:(DYEColor *)color {

    DYEColor *darkerColor = nil;
    if (color) {
        CGFloat h, s, b, a;
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
        darkerColor = [DYEColor colorWithHue:h saturation:s*(1-0.1f) brightness:b*(1-0.27f) alpha:a];
    }

    return darkerColor;
}

+ (DYEColor *)lighterColorForColor:(DYEColor *)color {

    DYEColor *lighterColor = nil;
    if (color) {
        CGFloat h, s, b, a;
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
        lighterColor = [DYEColor colorWithHue:h saturation:s*(1+0.1f) brightness:b*(1+0.35f) alpha:a];
    }

    return lighterColor;
}



#pragma mark Debugging

static DYEColorFormat _preferredColorFormat = DYEColorFormatRGB;

+ (DYEColorFormat)preferredColorFormat {

    return _preferredColorFormat;
}

+ (void)setPreferredColorFormat:(DYEColorFormat)colorFormat {

    _preferredColorFormat = colorFormat;
}

@end
