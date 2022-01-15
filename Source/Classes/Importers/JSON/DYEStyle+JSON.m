//
//  DYEStyle+JSON.m
//  Dye
//
//  Created by David De Bels on 01/03/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEStyle+JSON.h"

#import "DYEColors+JSON.h"
#import "NSDictionary+DyeTypeSafety.h"
#import "DYEColors+DYEPrivateHeader.h"



#pragma mark - DYEStyle JSON Category -

@implementation DYEStyle (JSON)

#pragma mark Manage the Styles Cache

+ (DYEStyle *)addStyleFromJSONDictionary:(NSDictionary *)dictionary {
    DYEStyle *style = [[DYEStyle alloc] initWithJSONDictionary:dictionary];
    if (style) {
        [DYEStyle addStyle:style withName:style.dyeStyleName];
    }

    return style;
}

+ (void)addStylesFromJSONArray:(NSArray<NSDictionary *> *)array {
    for (NSDictionary *dictionary in array) {
        [self addStyleFromJSONDictionary:dictionary];
    }
}



#pragma mark Initialize Styles

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    NSString *styleName = [dictionary dye_stringForKeyOrNil:@"name"];
    NSString *parentStyleName = [dictionary dye_stringForKeyOrNil:@"inherits"];

    if (styleName) {
        self = [self initWithName:styleName parentStyleName:parentStyleName];

        if (self) {
            // Background Color
            self.backgroundColor = dye_parseColor([DYEColors colorFromObject:[dictionary objectForKey:@"background-color"]], self.backgroundColor);
            
            // Colors
            self.primaryColor = dye_parseColor([DYEColors colorFromObject:[dictionary objectForKey:@"primary-color"]], self.primaryColor);
            self.secondaryColor = dye_parseColor([DYEColors colorFromObject:[dictionary objectForKey:@"secondary-color"]], self.secondaryColor);
            self.tintColor = dye_parseColor([DYEColors colorFromObject:[dictionary objectForKey:@"tint-color"]], self.tintColor);

            // Background Gradient
            NSDictionary *backgroundGradientDict = [dictionary dye_dictionaryForKeyOrNil:@"background-gradient"];
            if (backgroundGradientDict) {
                NSArray *colorsArray = [backgroundGradientDict objectForKey:@"colors"];
                NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[colorsArray count]];
                for (NSDictionary *colorDict in colorsArray) {
                    DYEColor *color = [DYEColors colorFromObject:colorDict];
                    if (color) {
                        [colors addObject:color];
                    }
                }
                self.backgroundGradientColors = colors;
                self.backgroundGradientPositions = [backgroundGradientDict objectForKey:@"locations"];

                self.backgroundGradientStartPoint = dye_parsePoint([backgroundGradientDict objectForKey:@"from"], self.backgroundGradientStartPoint);
                self.backgroundGradientEndPoint = dye_parsePoint([backgroundGradientDict objectForKey:@"to"], self.backgroundGradientEndPoint);
            }

            // Background Shadow
            NSDictionary *backgroundShadowDict = [dictionary dye_dictionaryForKeyOrNil:@"background-shadow"];
            if (backgroundShadowDict) {
                if ([backgroundShadowDict dye_numberForKeyOrNil:@"blur"]) {
                    self.backgroundShadowBlur = dye_parseFloat([backgroundShadowDict dye_numberForKeyOrNil:@"blur"], self.backgroundShadowBlur);
                } else {
                    self.backgroundShadowRadius = dye_parseFloat([backgroundShadowDict dye_numberForKeyOrNil:@"radius"], self.backgroundShadowRadius);
                }
                self.backgroundShadowColor = dye_parseColor([DYEColors colorFromObject:[backgroundShadowDict objectForKey:@"color"]], self.backgroundShadowColor);
                self.backgroundShadowOffset = dye_parseSize([backgroundShadowDict objectForKey:@"offset"], self.backgroundShadowOffset);
                self.backgroundShadowSpread = dye_parseFloat([backgroundShadowDict objectForKey:@"spread"], self.backgroundShadowSpread);
            }
        
            // Corner Radius
            self.cornerRadius = dye_parseFloat([dictionary dye_numberForKeyOrNil:@"corner-radius"], self.cornerRadius);

            // Border
            NSDictionary *backgroundBorderDict = [dictionary dye_dictionaryForKeyOrNil:@"background-border"];
            if (backgroundBorderDict) {
                self.borderWidth = dye_parseFloat([backgroundBorderDict dye_numberForKeyOrNil:@"width"], self.borderWidth);
                self.borderColor = dye_parseColor([DYEColors colorFromObject:[backgroundBorderDict objectForKey:@"color"]], self.borderColor);
            }
 
            // Transform
            NSDictionary *transformDict = [dictionary dye_dictionaryForKeyOrNil:@"transform"];
            if (transformDict) {
                self.transformTranslation = dye_parsePoint([transformDict objectForKey:@"translation"], self.transformTranslation);
                self.transformRotation = dye_parseFloat([transformDict dye_numberForKeyOrNil:@"rotation"], self.transformRotation);
                self.transformScale = dye_parsePoint([transformDict objectForKey:@"scale"], self.transformScale);
            }

            // Font
            NSDictionary *fontDict = [dictionary dye_dictionaryForKeyOrNil:@"font"];
            if (fontDict) {
                self.fontName = dye_parseString([fontDict dye_stringForKeyOrNil:@"font-name"], self.fontName, nil);
                self.fontWeight = dye_parseString([fontDict dye_stringForKeyOrNil:@"font-weight"], self.fontWeight, @[DYEFontWeightUltraLight, DYEFontWeightThin, DYEFontWeightLight, DYEFontWeightRegular, DYEFontWeightMedium, DYEFontWeightSemiBold, DYEFontWeightBold, DYEFontWeightHeavy, DYEFontWeightBlack]);
                self.fontSize = dye_parseFloat([fontDict dye_numberForKeyOrNil:@"font-size"], self.fontSize);
            }

            // Dynamic Type
            NSDictionary *dynamicTypeDict = [dictionary dye_dictionaryForKeyOrNil:@"dynamic-type"];
            if (dynamicTypeDict) {
                self.dynamicTypeEnabled = dye_parseBool([dynamicTypeDict dye_numberForKeyOrNil:@"enabled"], self.dynamicTypeEnabled);
                self.dynamicTypeAccessibilityEnabled = dye_parseBool([dynamicTypeDict dye_numberForKeyOrNil:@"accessibility-enabled"], self.dynamicTypeAccessibilityEnabled);

                self.dynamicTypeFontSizeXS = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-xs"], self.dynamicTypeFontSizeXS);
                self.dynamicTypeFontSizeS = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-s"], self.dynamicTypeFontSizeS);
                self.dynamicTypeFontSizeM = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-m"], self.dynamicTypeFontSizeM);
                self.dynamicTypeFontSizeL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-l"], self.dynamicTypeFontSizeL);
                self.dynamicTypeFontSizeXL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-xl"], self.dynamicTypeFontSizeXL);
                self.dynamicTypeFontSizeXXL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-xxl"], self.dynamicTypeFontSizeXXL);
                self.dynamicTypeFontSizeXXXL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-xxxl"], self.dynamicTypeFontSizeXXXL);
                self.dynamicTypeFontSizeAccessibilityM = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-am"], self.dynamicTypeFontSizeAccessibilityM);
                self.dynamicTypeFontSizeAccessibilityL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-al"], self.dynamicTypeFontSizeAccessibilityL);
                self.dynamicTypeFontSizeAccessibilityXL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-axl"], self.dynamicTypeFontSizeAccessibilityXL);
                self.dynamicTypeFontSizeAccessibilityXXL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-axxl"], self.dynamicTypeFontSizeAccessibilityXXL);
                self.dynamicTypeFontSizeAccessibilityXXXL = dye_parseFloat([dynamicTypeDict dye_numberForKeyOrNil:@"font-size-axxxl"], self.dynamicTypeFontSizeAccessibilityXXXL);
            }

            // Text Stroke
            NSDictionary *textStrokeDict = [dictionary dye_dictionaryForKeyOrNil:@"text-stroke"];
            if (textStrokeDict) {
                self.textStrokeWidth = dye_parseFloat([textStrokeDict dye_numberForKeyOrNil:@"width"], self.textStrokeWidth);
                self.textStrokeColor = dye_parseColor([DYEColors colorFromObject:[textStrokeDict objectForKey:@"color"]], self.textStrokeColor);
            }

            // Text Shadow
            NSDictionary *textShadowDict = [dictionary dye_dictionaryForKeyOrNil:@"text-shadow"];
            if (textShadowDict) {
                if ([textShadowDict dye_numberForKeyOrNil:@"blur"]) {
                    self.textShadowBlur = dye_parseFloat([textShadowDict dye_numberForKeyOrNil:@"blur"], self.textShadowBlur);
                } else {
                    self.textShadowRadius = dye_parseFloat([textShadowDict dye_numberForKeyOrNil:@"radius"], self.textShadowRadius);
                }
                self.textShadowColor = dye_parseColor([DYEColors colorFromObject:[textShadowDict objectForKey:@"color"]], self.textShadowColor);
                self.textShadowOffset = dye_parseSize([textShadowDict dye_dictionaryForKeyOrNil:@"offset"], self.textShadowOffset);
            }
            
            // Text Transform
            BOOL textUppercase = dye_parseBool([dictionary dye_numberForKeyOrNil:@"text-uppercase"], NO);
            BOOL textLowercase = dye_parseBool([dictionary dye_numberForKeyOrNil:@"text-lowercase"], NO);
            BOOL textCapitalize = dye_parseBool([dictionary dye_numberForKeyOrNil:@"text-capitalize"], NO);
        
            if (textUppercase) {
                self.textTransform = DYETextTransformUppercase;
            } else if (textLowercase) {
                self.textTransform = DYETextTransformLowercase;
            } else if (textCapitalize) {
                self.textTransform = DYETextTransformCapitalize;
            } else {
                self.textTransform = DYETextTransformNone;
            }
            
            // Additional text styling
            self.textUnderline = dye_parseBool([dictionary dye_numberForKeyOrNil:@"text-underline"], self.textUnderline);
            self.textStrikethrough = dye_parseBool([dictionary dye_numberForKeyOrNil:@"text-strikethrough"], self.textStrikethrough);

            // Text Character Spacing
            self.textCharacterSpacing = dye_parseFloat([dictionary dye_numberForKeyOrNil:@"text-character-spacing"], self.textCharacterSpacing);

            // Paragraph style
            self.textLineHeightMultiple = dye_parseFloat([dictionary dye_numberForKeyOrNil:@"text-line-height"], self.textLineHeightMultiple);
            self.textLineHeight = dye_parseFloat([dictionary dye_numberForKeyOrNil:@"text-fixed-line-height"], self.textLineHeight);

            // Debugging
            self.info = [dictionary dye_stringForKeyOrNil:@"info"];
        }
    }

    return self;
}



#pragma mark JSON Representation

- (NSDictionary *)JSONDictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    dictionary[@"name"] = self.dyeStyleName ? : @"(null)";
    dictionary[@"inherits"] = self.parentStyle.dyeStyleName;

    // Background Color
    dictionary[@"background-color"] = dye_colorJSONValue(self.backgroundColor);

    // Background Gradient
    NSMutableDictionary *backgroundGradientDict = [NSMutableDictionary new];
    NSMutableArray *backgroundGradientColors = [NSMutableArray new];
    for (DYEColor *color in self.backgroundGradientColors) {
        [backgroundGradientColors addObject:dye_colorJSONValue(color)];
    }
    backgroundGradientDict[@"colors"] = backgroundGradientColors;
    backgroundGradientDict[@"locations"] = self.backgroundGradientPositions;
    backgroundGradientDict[@"from"] = @{ @"x": @(self.backgroundGradientStartPoint.x), @"y": @(self.backgroundGradientStartPoint.y) };
    backgroundGradientDict[@"to"] = @{ @"x": @(self.backgroundGradientEndPoint.x), @"y": @(self.backgroundGradientEndPoint.y) };
    dictionary[@"background-gradient"] = backgroundGradientDict;

    // Background Shadow
    NSMutableDictionary *backgroundShadowDict = [NSMutableDictionary new];
    backgroundShadowDict[@"radius"] = @(self.backgroundShadowRadius);
    backgroundShadowDict[@"color"] = dye_colorJSONValue(self.backgroundShadowColor);
    backgroundShadowDict[@"offset"] = dye_sizeJSONValue(self.backgroundShadowOffset);
    backgroundShadowDict[@"spread"] = @(self.backgroundShadowSpread);
    dictionary[@"background-shadow"] = backgroundShadowDict;
    
    // Tint
    dictionary[@"tint-color"] = dye_colorJSONValue(self.tintColor);

    // Corner Radius
    dictionary[@"corner-radius"] = @(self.cornerRadius);

    // Border
    NSMutableDictionary *backgroundBorderDict = [NSMutableDictionary new];
    backgroundBorderDict[@"width"] = @(self.borderWidth);
    backgroundBorderDict[@"color"] = dye_colorJSONValue(self.borderColor);
    dictionary[@"background-border"] = backgroundBorderDict;

    // Transform
    NSMutableDictionary *transformDict = [NSMutableDictionary new];
    transformDict[@"translation"] = dye_pointJSONValue(self.transformTranslation);
    transformDict[@"rotation"] = @(self.transformRotation);
    transformDict[@"scale"] = dye_pointJSONValue(self.transformScale);
    dictionary[@"transform"] = transformDict;

    // Font
    NSMutableDictionary *fontDict = [NSMutableDictionary new];
    fontDict[@"font-name"] = self.fontName ? : NSNull.null;
    fontDict[@"font-weight"] = self.fontWeight ? : NSNull.null;
    fontDict[@"font-size"] = @(self.fontSize);
    dictionary[@"font"] = fontDict;

    // Dynamic Type
    NSMutableDictionary *dynamicTypeDict = [NSMutableDictionary new];
    dynamicTypeDict[@"enabled"] = @(self.dynamicTypeEnabled);
    dynamicTypeDict[@"accessibility-enabled"] = @(self.dynamicTypeAccessibilityEnabled);
    dynamicTypeDict[@"font-size-xs"] = self.dynamicTypeFontSizeXS != NSNotFound ? @(self.dynamicTypeFontSizeXS) : NSNull.null;
    dynamicTypeDict[@"font-size-s"] = self.dynamicTypeFontSizeS != NSNotFound ? @(self.dynamicTypeFontSizeS) : NSNull.null;
    dynamicTypeDict[@"font-size-m"] = self.dynamicTypeFontSizeM != NSNotFound ? @(self.dynamicTypeFontSizeM) : NSNull.null;
    dynamicTypeDict[@"font-size-l"] = self.dynamicTypeFontSizeL != NSNotFound ? @(self.dynamicTypeFontSizeL) : NSNull.null;
    dynamicTypeDict[@"font-size-xl"] = self.dynamicTypeFontSizeXL != NSNotFound ? @(self.dynamicTypeFontSizeXL) : NSNull.null;
    dynamicTypeDict[@"font-size-xxl"] = self.dynamicTypeFontSizeXXL != NSNotFound ? @(self.dynamicTypeFontSizeXXL) : NSNull.null;
    dynamicTypeDict[@"font-size-xxxl"] = self.dynamicTypeFontSizeXXXL != NSNotFound ? @(self.dynamicTypeFontSizeXXXL) : NSNull.null;
    dynamicTypeDict[@"font-size-am"] = self.dynamicTypeFontSizeAccessibilityM != NSNotFound ? @(self.dynamicTypeFontSizeAccessibilityM) : NSNull.null;
    dynamicTypeDict[@"font-size-al"] = self.dynamicTypeFontSizeAccessibilityL != NSNotFound ? @(self.dynamicTypeFontSizeAccessibilityL) : NSNull.null;
    dynamicTypeDict[@"font-size-axl"] = self.dynamicTypeFontSizeAccessibilityXL != NSNotFound ? @(self.dynamicTypeFontSizeAccessibilityXL) : NSNull.null;
    dynamicTypeDict[@"font-size-axxl"] = self.dynamicTypeFontSizeAccessibilityXXL != NSNotFound ? @(self.dynamicTypeFontSizeAccessibilityXXL) : NSNull.null;
    dynamicTypeDict[@"font-size-axxxl"] = self.dynamicTypeFontSizeAccessibilityXXXL != NSNotFound ? @(self.dynamicTypeFontSizeAccessibilityXXXL) : NSNull.null;
    dictionary[@"dynamic-type"] = dynamicTypeDict;

    // Colors
    dictionary[@"primary-color"] = dye_colorJSONValue(self.primaryColor);
    dictionary[@"secondary-color"] = dye_colorJSONValue(self.secondaryColor);

    // Text Stroke
    NSMutableDictionary *textStrokeDict = [NSMutableDictionary new];
    textStrokeDict[@"width"] = @(self.textStrokeWidth);
    textStrokeDict[@"color"] = dye_colorJSONValue(self.textStrokeColor);
    dictionary[@"text-stroke"] = textStrokeDict;

    // Text Shadow
    NSMutableDictionary *textShadowDict = [NSMutableDictionary new];
    textShadowDict[@"radius"] = @(self.textShadowRadius);
    textShadowDict[@"color"] = dye_colorJSONValue(self.textShadowColor);
    textShadowDict[@"offset"] = dye_sizeJSONValue(self.textShadowOffset);
    dictionary[@"text-shadow"] = textShadowDict;

    // Additional text styling
    dictionary[@"text-strikethrough"] = @(self.textStrikethrough);
    dictionary[@"text-underline"] = @(self.textUnderline);
    
    // Text Transform
    switch (self.textTransform) {
        case DYETextTransformUppercase:
            dictionary[@"text-uppercase"] = @YES;
            break;
        case DYETextTransformLowercase:
            dictionary[@"text-lowercase"] = @YES;
            break;
        case DYETextTransformCapitalize:
            dictionary[@"text-capitalize"] = @YES;
            break;
        default:
            break;
    }
    
    // Text Character Spacing
    dictionary[@"text-character-spacing"] = @(self.textCharacterSpacing);

    // Paragraph Style
    dictionary[@"text-line-height"] = @(self.textLineHeightMultiple);
    dictionary[@"text-fixed-line-height"] = @(self.textLineHeight);

    // Debugging
    dictionary[@"info"] = self.info ? : NSNull.null;

    return dictionary;
}

- (NSString *)JSONStringRepresentation {

    NSData *data = [NSJSONSerialization dataWithJSONObject:self.JSONDictionaryRepresentation options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}



#pragma mark Helper Methods

static inline CGFloat dye_parseBool(NSNumber *number, BOOL defaultValue){
    return (number != nil && ![number isEqual:NSNull.null]) ? [number boolValue] : defaultValue;
}

static inline CGFloat dye_parseFloat(NSNumber *number, CGFloat defaultValue){
    return (number != nil && ![number isEqual:NSNull.null]) ? [number floatValue] : defaultValue;
}

static inline DYEColor *dye_parseColor(DYEColor *color, DYEColor *defaultColor){
    return (color != nil && ![color isEqual:NSNull.null]) ? color : defaultColor;
}

static inline NSString *dye_parseString(NSString *string, NSString *defaultString, NSArray *options){
    if (string && ![string isEqual:NSNull.null]) {
        if (!options) {
            return string;
        }

        if (options && [options containsObject:string]) {
            return string;
        }
    }

    return defaultString;
}

static inline CGPoint dye_parsePoint(id object, CGPoint defaultValue){
    CGPoint point = defaultValue;
    if (object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSNumber *xValue = [((NSDictionary *)object) dye_numberForKeyOrNil:@"x"];
            NSNumber *yValue = [((NSDictionary *)object) dye_numberForKeyOrNil:@"y"];

            if (xValue && yValue) {
                point = CGPointMake([xValue floatValue], [yValue floatValue]);
            }
        } else if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *value = (NSNumber *)object;
            point = CGPointMake([value floatValue], [value floatValue]);
        }
    }

    return point;
}

static inline CGSize dye_parseSize(id object, CGSize defaultValue){
    CGSize size = defaultValue;
    if (object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSNumber *xValue = [((NSDictionary *)object) dye_numberForKeyOrNil:@"x"];
            NSNumber *yValue = [((NSDictionary *)object) dye_numberForKeyOrNil:@"y"];

            if (xValue && yValue) {
                size = CGSizeMake([xValue floatValue], [yValue floatValue]);
            }
        } else if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *value = (NSNumber *)object;
            size = CGSizeMake([value floatValue], [value floatValue]);
        }
    }

    return size;
}

static inline id dye_colorJSONValue(DYEColor *color) {
    NSDictionary *colorJSONDict = color.JSONDictionaryRepresentation;
    return ((![colorJSONDict[@"name"] isEqual:NSNull.null]) ? colorJSONDict[@"name"] : colorJSONDict[@"value"]) ? : NSNull.null;
}

static inline NSDictionary *dye_pointJSONValue(CGPoint point) {
    return @{ @"x": @(point.x),
              @"y": @(point.y) };
}

static inline NSDictionary *dye_sizeJSONValue(CGSize size) {
    return @{ @"x": @(size.width),
              @"y": @(size.height) };
}

@end


