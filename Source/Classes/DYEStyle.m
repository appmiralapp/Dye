//
//  DYEStyle.m
//  Dye
//
//  Created by David De Bels on 21/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEStyle.h"

#import "DYEColors.h"

NSString * _Nonnull DYEStyleDarkerStyleNameSuffix = @"-DYEStyleDarkerVersion";
NSString * _Nonnull DYEStyleLighterStyleNameSuffix = @"-DYEStyleLighterVersion";

NSString * _Nonnull DYEStyleWillUpdateStyleableNotification = @"DYEStyleWillUpdateStyleableNotification";
NSString * _Nonnull DYEStyleDidUpdateStyleableNotification = @"DYEStyleDidUpdateStyleableNotification";

NSString * _Nonnull DYEFontWeightUltraLight = @"UltraLight";
NSString * _Nonnull DYEFontWeightThin = @"Thin";
NSString * _Nonnull DYEFontWeightLight = @"Light";
NSString * _Nonnull DYEFontWeightRegular = @"Regular";
NSString * _Nonnull DYEFontWeightMedium = @"Medium";
NSString * _Nonnull DYEFontWeightSemiBold = @"SemiBold";
NSString * _Nonnull DYEFontWeightBold = @"Bold";
NSString * _Nonnull DYEFontWeightHeavy = @"Heavy";
NSString * _Nonnull DYEFontWeightBlack = @"Black";



#pragma mark - DYEStyle Class Extension -

@interface DYEStyle ()

@end



#pragma mark - DYEStyle Implementation -

@implementation DYEStyle

@synthesize backgroundGradientColors = _backgroundGradientColors;
@synthesize backgroundGradientPositions = _backgroundGradientPositions;
@synthesize darkerStyle = _darkerStyle;
@synthesize lighterStyle = _lighterStyle;

#pragma mark Manage Styles Cache

+ (NSMutableDictionary *)dye_definedStyles {
    static NSMutableDictionary *_dye_definedStyles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dye_definedStyles = [[NSMutableDictionary alloc] init];
    });

    return _dye_definedStyles;
}

+ (NSDictionary *)availableStyles {
    return [[DYEStyle dye_definedStyles] copy];
}

+ (DYEStyle *)styleNamed:(NSString *)name {
    DYEStyle *style = nil;
    if (name) {
        style = [[DYEStyle dye_definedStyles] objectForKey:name];
    }

    return style;
}

+ (void)addStyle:(DYEStyle *)style withName:(NSString *)styleName {
    if (styleName && [style isKindOfClass:[DYEStyle class]]) {
        [[DYEStyle dye_definedStyles] setObject:style forKey:styleName];
        [style update];
    }
}

+ (void)removeStyleWithName:(NSString *)styleName {
    if (styleName) {
        [[DYEStyle dye_definedStyles] removeObjectForKey:styleName];
    }
}

+ (void)removeAllStyles {
    [[DYEStyle dye_definedStyles] removeAllObjects];
}



#pragma mark Initialize & Destroy

- (instancetype)init {
    self = [self initWithName:@""];
    if (self) {
    }

    return self;
}

- (instancetype)initWithName:(NSString *)dyeStyleName {
    return [self initWithName:dyeStyleName parentStyleName:nil];
}

- (instancetype)initWithName:(NSString *)dyeStyleName parentStyleName:(NSString *)parentStyleName {
    self = [super init];
    if (self) {
        _dyeStyleName = dyeStyleName;

        if ([parentStyleName length] > 0) {
            DYEStyle *parentStyle = [DYEStyle styleNamed:parentStyleName];
            if (parentStyle) {
                _parentStyle = parentStyle;
                [self initializeParentStyleValues];
            } else {
                NSLog(@"[Dye]: Attempting to initialize style \"%@\" with parent style \"%@\", but the parent style does not exist.", dyeStyleName, parentStyleName);
            }
        }

        if (!self.parentStyle) {
            [self initializeDefaultValues];
        }
    }


    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (DYEStyle *)lighterStyleForStyle:(DYEStyle *)style {
    NSString *styleName = [NSString stringWithFormat:@"%@%@", style.dyeStyleName, DYEStyleLighterStyleNameSuffix];
    DYEStyle *lighterStyle = [[DYEStyle alloc] initWithName:styleName parentStyleName:style.dyeStyleName];

    // Background Color Properties
    lighterStyle.backgroundColor = [DYEColors lighterColorForColor:style.backgroundColor];

    // Background Gradient Properties
    if (style.backgroundGradientColors) {
        NSMutableArray *backgroundGradientColors = [NSMutableArray new];
        for (DYEColor *color in style.backgroundGradientColors) {
            DYEColor *lighterColor = [DYEColors lighterColorForColor:color];
            if (lighterColor) {
                [backgroundGradientColors addObject:lighterColor];
            }
        }
        lighterStyle.backgroundGradientColors = backgroundGradientColors;
    }

    // Background Shadow Properties
    lighterStyle.backgroundShadowColor = [DYEColors lighterColorForColor:style.backgroundShadowColor];

    // Border Properties
    lighterStyle.borderColor = [DYEColors lighterColorForColor:style.borderColor];

    // Color Properties
    lighterStyle.primaryColor = [DYEColors lighterColorForColor:style.primaryColor];
    lighterStyle.secondaryColor = [DYEColors lighterColorForColor:style.secondaryColor];

    // Text Properties
    lighterStyle.textStrokeColor = [DYEColors lighterColorForColor:style.textStrokeColor];
    lighterStyle.textShadowColor = [DYEColors lighterColorForColor:style.textShadowColor];

    // Tint Properties
    lighterStyle.tintColor = [DYEColors lighterColorForColor:style.tintColor];

    return lighterStyle;
}

+ (DYEStyle *)darkerStyleForStyle:(DYEStyle *)style {
    NSString *styleName = [NSString stringWithFormat:@"%@%@", style.dyeStyleName, DYEStyleDarkerStyleNameSuffix];
    DYEStyle *darkerStyle = [[DYEStyle alloc] initWithName:styleName parentStyleName:style.dyeStyleName];

    // Background Color Properties
    darkerStyle.backgroundColor = [DYEColors darkerColorForColor:style.backgroundColor];

    // Background Gradient Properties
    if (style.backgroundGradientColors) {
        NSMutableArray *backgroundGradientColors = [NSMutableArray new];
        for (DYEColor *color in style.backgroundGradientColors) {
            DYEColor *lighterColor = [DYEColors darkerColorForColor:color];
            if (lighterColor) {
                [backgroundGradientColors addObject:lighterColor];
            }
        }
        darkerStyle.backgroundGradientColors = backgroundGradientColors;
    }

    // Background Shadow Properties
    darkerStyle.backgroundShadowColor = [DYEColors darkerColorForColor:style.backgroundShadowColor];

    // Border Properties
    darkerStyle.borderColor = [DYEColors darkerColorForColor:style.borderColor];

    // Color Properties
    darkerStyle.primaryColor = [DYEColors darkerColorForColor:style.primaryColor];
    darkerStyle.secondaryColor = [DYEColors darkerColorForColor:style.secondaryColor];

    // Text Properties
    darkerStyle.textStrokeColor = [DYEColors darkerColorForColor:style.textStrokeColor];
    darkerStyle.textShadowColor = [DYEColors darkerColorForColor:style.textShadowColor];

    // Tint Properties
    darkerStyle.tintColor = [DYEColors darkerColorForColor:style.tintColor];

    return darkerStyle;
}



#pragma mark Initialize Values

- (void)initializeDefaultValues {
    // Background Color Properties
    self.backgroundColor = nil;

    // Background Gradient Properties
    self.backgroundGradientColors = nil;
    self.backgroundGradientPositions = nil;
    self.backgroundGradientStartPoint = CGPointMake(0.5, 0.0);
    self.backgroundGradientEndPoint = CGPointMake(0.5, 1.0);

    // Background Shadow Properties
    self.backgroundShadowRadius = 3;
    self.backgroundShadowOffset = CGSizeMake(0, -3);
    self.backgroundShadowColor = [DYEColor colorWithWhite:0 alpha:0];
    self.backgroundShadowSpread = 0;

    // Corner Radius Properties
    self.cornerRadius = 0.0;

    // Border Properties
    self.borderWidth = 0;
    self.borderColor = nil;

    // Transform Properties
    self.transformTranslation = CGPointZero;
    self.transformRotation = 0.0;
    self.transformScale = CGPointMake(1, 1);

    // Font Properties
#if TARGET_OS_IOS
    self.fontSize = [DYEFont systemFontSize];
#elif TARGET_OS_TV
    self.fontSize = 17.0;
#endif
    self.fontName = [DYEFont systemFontOfSize:self.fontSize].fontName;

    // Dynamic Type
    self.dynamicTypeEnabled = NO;
    self.dynamicTypeAccessibilityEnabled = NO;
    self.dynamicTypeFontSizeXS = NSNotFound;
    self.dynamicTypeFontSizeS = NSNotFound;
    self.dynamicTypeFontSizeM = NSNotFound;
    self.dynamicTypeFontSizeL = NSNotFound;
    self.dynamicTypeFontSizeXL = NSNotFound;
    self.dynamicTypeFontSizeXXL = NSNotFound;
    self.dynamicTypeFontSizeXXXL = NSNotFound;
    self.dynamicTypeFontSizeAccessibilityM = NSNotFound;
    self.dynamicTypeFontSizeAccessibilityL = NSNotFound;
    self.dynamicTypeFontSizeAccessibilityXL = NSNotFound;
    self.dynamicTypeFontSizeAccessibilityXXL = NSNotFound;
    self.dynamicTypeFontSizeAccessibilityXXXL = NSNotFound;

    // Color Properties
    self.primaryColor = nil;
    self.secondaryColor = nil;

    // Stroke & Shadow Properties
    self.textStrokeWidth = 0;
    self.textStrokeColor = nil;
    self.textShadowRadius = 0;
    self.textShadowOffset = CGSizeZero;
    self.textShadowColor = [DYEColor colorWithWhite:0 alpha:0.33];
    
    // Text Properties
    self.textUnderline = NO;
    self.textStrikethrough = NO;
    self.textTransform = DYETextTransformNone;

    // Paragraph Properties
    self.textLineHeightMultiple = 1.0;
    self.textLineHeight = 0.0;
}

- (void)initializeParentStyleValues {
    // Background Color Properties
    self.backgroundColor = self.parentStyle.backgroundColor;

    // Background Gradient Properties
    self.backgroundGradientColors = self.parentStyle.backgroundGradientColors;
    self.backgroundGradientPositions = self.parentStyle.backgroundGradientPositions;
    self.backgroundGradientStartPoint = self.parentStyle.backgroundGradientStartPoint;
    self.backgroundGradientEndPoint = self.parentStyle.backgroundGradientEndPoint;

    // Background Shadow Properties
    self.backgroundShadowRadius = self.parentStyle.backgroundShadowRadius;
    self.backgroundShadowOffset = self.parentStyle.backgroundShadowOffset;
    self.backgroundShadowColor = self.parentStyle.backgroundShadowColor;

    // Corner Radius Properties
    self.cornerRadius = self.parentStyle.cornerRadius;

    // Border Properties
    self.borderWidth = self.parentStyle.borderWidth;
    self.borderColor = self.parentStyle.borderColor;

    // Transform Properties
    self.transformTranslation = self.parentStyle.transformTranslation;
    self.transformRotation = self.parentStyle.transformRotation;
    self.transformScale = self.parentStyle.transformScale;

    // Font Properties
    self.fontSize = self.parentStyle.fontSize;
    self.fontName = self.parentStyle.fontName;
    self.fontWeight = self.parentStyle.fontWeight;

    // Dynamic Type
    self.dynamicTypeEnabled = self.parentStyle.dynamicTypeEnabled;
    self.dynamicTypeAccessibilityEnabled = self.parentStyle.dynamicTypeAccessibilityEnabled;
    self.dynamicTypeFontSizeXS = self.parentStyle.dynamicTypeFontSizeXS;
    self.dynamicTypeFontSizeS = self.parentStyle.dynamicTypeFontSizeS;
    self.dynamicTypeFontSizeM = self.parentStyle.dynamicTypeFontSizeM;
    self.dynamicTypeFontSizeL = self.parentStyle.dynamicTypeFontSizeL;
    self.dynamicTypeFontSizeXL = self.parentStyle.dynamicTypeFontSizeXL;
    self.dynamicTypeFontSizeXXL = self.parentStyle.dynamicTypeFontSizeXXL;
    self.dynamicTypeFontSizeXXXL = self.parentStyle.dynamicTypeFontSizeXXXL;
    self.dynamicTypeFontSizeAccessibilityM = self.parentStyle.dynamicTypeFontSizeAccessibilityM;
    self.dynamicTypeFontSizeAccessibilityL = self.parentStyle.dynamicTypeFontSizeAccessibilityL;
    self.dynamicTypeFontSizeAccessibilityXL = self.parentStyle.dynamicTypeFontSizeAccessibilityXL;
    self.dynamicTypeFontSizeAccessibilityXXL = self.parentStyle.dynamicTypeFontSizeAccessibilityXXL;
    self.dynamicTypeFontSizeAccessibilityXXXL = self.parentStyle.dynamicTypeFontSizeAccessibilityXXXL;

    // Color Properties
    self.primaryColor = self.parentStyle.primaryColor;
    self.secondaryColor = self.parentStyle.secondaryColor;
    self.tintColor = self.parentStyle.tintColor;

    // Text Properties
    self.textStrokeWidth = self.parentStyle.textStrokeWidth;
    self.textStrokeColor = self.parentStyle.textStrokeColor;
    self.textShadowRadius = self.parentStyle.textShadowRadius;
    self.textShadowOffset = self.parentStyle.textShadowOffset;
    self.textShadowColor = self.parentStyle.textShadowColor;

    // Text Transforms
    self.textUnderline = self.parentStyle.textUnderline;
    self.textTransform = self.parentStyle.textTransform;
    self.textCharacterSpacing = self.parentStyle.textCharacterSpacing;
    self.textStrikethrough = self.parentStyle.textStrikethrough;

    // Paragraph Properties
    self.textLineHeightMultiple = self.parentStyle.textLineHeightMultiple;
    self.textLineHeight = self.parentStyle.textLineHeight;
}



#pragma mark Custom Getters & Setters

- (DYEStyle *)darkerStyle {
    if (!_darkerStyle) {
        _darkerStyle = [DYEStyle darkerStyleForStyle:self];
        [DYEStyle addStyle:_darkerStyle withName:_darkerStyle.dyeStyleName];
    }

    return _darkerStyle;
}

- (DYEStyle *)lighterStyle {
    if (!_lighterStyle) {
        _lighterStyle = [DYEStyle lighterStyleForStyle:self];
        [DYEStyle addStyle:_lighterStyle withName:_lighterStyle.dyeStyleName];
    }

    return _lighterStyle;
}



#pragma mark Background Color Properties

- (void)setBackgroundColor:(DYEColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self update];
}



#pragma mark Background Gradient Properties

- (NSArray<DYEColor *> *)backgroundGradientColors {
    NSArray *backgroundGradientColors = _backgroundGradientColors;

    // If there's no colors, the gradient shouldn't be drawn
    if ([backgroundGradientColors count] == 0) {
        backgroundGradientColors = nil;
    }
    // If there is only 1 color, add the same color as the second color
    else if ([backgroundGradientColors count] == 1) {
        backgroundGradientColors = [backgroundGradientColors arrayByAddingObject:[backgroundGradientColors objectAtIndex:0]];
    }

    return backgroundGradientColors;
}

- (void)setBackgroundGradientColors:(NSArray<DYEColor *> *)backgroundGradientColors {
    _backgroundGradientColors = backgroundGradientColors;
    [self update];
}

- (NSArray<NSNumber *> *)backgroundGradientPositions {
    NSArray *backgroundGradientColors = self.backgroundGradientColors;
    NSArray *backgroundGradientPositions = _backgroundGradientPositions;

    // If the gradient colors count & gradient positions count doesn't match, change the gradient positions
    if ([backgroundGradientColors count] > 1) {
        CGFloat addition = 1.0 / ([backgroundGradientColors count] - 1);

        if ([backgroundGradientColors count] != [backgroundGradientPositions count]) {
            NSMutableArray *newPositions = [NSMutableArray new];
            for (NSInteger i = 0; i < ([backgroundGradientColors count]-1); i++) {
                [newPositions addObject:[NSNumber numberWithFloat:(i*addition)]];
            }
            [newPositions addObject:@1];
            backgroundGradientPositions = [newPositions copy];
        }
    } else {
        backgroundGradientPositions = @[ @0.5 ];
    }

    return backgroundGradientPositions;
}

- (void)setBackgroundGradientPositions:(NSArray<NSNumber *> *)backgroundGradientPositions {
    _backgroundGradientPositions = backgroundGradientPositions;
    [self update];
}

- (void)setBackgroundGradientStartPoint:(CGPoint)backgroundGradientStartPoint {
    CGPoint point = backgroundGradientStartPoint;
    point.x = MAX(point.x, 0);
    point.x = MIN(point.x, 1);
    point.y = MAX(point.y, 0);
    point.y = MIN(point.y, 1);

    _backgroundGradientStartPoint = point;
    [self update];
}

- (void)setBackgroundGradientEndPoint:(CGPoint)backgroundGradientEndPoint {
    CGPoint point = backgroundGradientEndPoint;
    point.x = MAX(point.x, 0);
    point.x = MIN(point.x, 1);
    point.y = MAX(point.y, 0);
    point.y = MIN(point.y, 1);

    _backgroundGradientEndPoint = point;
    [self update];
}



#pragma mark Background Shadow Properties

- (void)setBackgroundShadowRadius:(CGFloat)backgroundShadowRadius {
    _backgroundShadowRadius = backgroundShadowRadius;
    _backgroundShadowBlur = backgroundShadowRadius * 2.0;
    [self update];
}

- (void)setBackgroundShadowBlur:(CGFloat)backgroundShadowBlur {
    _backgroundShadowBlur = backgroundShadowBlur;
    _backgroundShadowRadius = backgroundShadowBlur / 2.0;
    [self update];
}

- (void)setBackgroundShadowOffset:(CGSize)backgroundShadowOffset {
    _backgroundShadowOffset = backgroundShadowOffset;
    [self update];
}

- (void)setBackgroundShadowColor:(DYEColor *)backgroundShadowColor {
    _backgroundShadowColor = backgroundShadowColor;
    [self update];
}

- (void)setBackgroundShadowSpread:(CGFloat)backgroundShadowSpread {
    _backgroundShadowSpread = backgroundShadowSpread;
    [self update];
}



#pragma mark Tint Properties

- (void)setTintColor:(DYEColor *)tintColor {
    _tintColor = tintColor;
    [self update];
}



#pragma mark Corner Properties

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self update];
}



#pragma mark Border Properties

- (void)setBorderColor:(DYEColor *)borderColor {
    _borderColor = borderColor;
    [self update];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self update];
}



#pragma mark Transform Properties

- (void)setTransformTranslation:(CGPoint)transformTranslation {
    _transformTranslation = transformTranslation;
    [self update];
}

- (void)setTransformRotation:(CGFloat)transformRotation {
    _transformRotation = transformRotation;
    [self update];
}

- (void)setTransformScale:(CGPoint)transformScale {
    _transformScale = transformScale;
    [self update];
}



#pragma mark Color Properties

- (void)setPrimaryColor:(DYEColor *)primaryColor {
    _primaryColor = primaryColor;
    [self update];
}

- (void)setSecondaryColor:(DYEColor *)secondaryColor {
    _secondaryColor = secondaryColor;
    [self update];
}



#pragma mark Font Properties

- (DYEFont *)font {
    CGFloat fontSize = self.fontSize;
    
#if !TARGET_OS_OSX
    if (self.dynamicTypeEnabled) {
        UITraitCollection *traitCollection = [UIScreen mainScreen].traitCollection;
        if (@available(iOS 10.0, tvOS 10.0, *)) {
            NSString *preferredContentSize = traitCollection.preferredContentSizeCategory;
            CGFloat preferredFontSize = [self fontSizeForPreferredContentSize:preferredContentSize];
            fontSize = preferredFontSize;
        } else {
            // This way of getting UIApplication is a bit in a grey zone, but required to support dynamic type in Extensions
            UIApplication *application = [UIApplication valueForKey:@"sharedApplication"];
            if (application.delegate) {
                NSString *preferredContentSize = [application preferredContentSizeCategory];
                CGFloat preferredFontSize = [self fontSizeForPreferredContentSize:preferredContentSize];
                fontSize = preferredFontSize;
            }
        }
    }
#endif
    
    DYEFont *font = nil;
    if (self.fontName) {
        font = [DYEFont fontWithName:self.fontName size:fontSize];
    }
    if (!font) {
        font = [DYEFont systemFontOfSize:fontSize];
    }

    return font;
}

- (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    [self update];
}

- (void)setFontWeight:(NSString *)fontWeight {
    _fontWeight = fontWeight;
    [self update];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self update];
}

#if !TARGET_OS_OSX



#pragma mark Dynamic Type

- (void)setDynamicTypeEnabled:(BOOL)dynamicTypeEnabled {
    _dynamicTypeEnabled = dynamicTypeEnabled;

    if ([DYEFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
        if (_dynamicTypeEnabled) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangePreferredContentSize:) name:UIContentSizeCategoryDidChangeNotification object:nil];
            [self update];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
        }
    }
}

- (void)setDynamicTypeAccessibilityEnabled:(BOOL)dynamicTypeAccessibilityEnabled {
    _dynamicTypeAccessibilityEnabled = dynamicTypeAccessibilityEnabled;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeXS:(CGFloat)dynamicTypeFontSizeXS {
    _dynamicTypeFontSizeXS = dynamicTypeFontSizeXS;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeS:(CGFloat)dynamicTypeFontSizeS {
    _dynamicTypeFontSizeS = dynamicTypeFontSizeS;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeM:(CGFloat)dynamicTypeFontSizeM {
    _dynamicTypeFontSizeM = dynamicTypeFontSizeM;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeL:(CGFloat)dynamicTypeFontSizeL {
    _dynamicTypeFontSizeL = dynamicTypeFontSizeL;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeXL:(CGFloat)dynamicTypeFontSizeXL {
    _dynamicTypeFontSizeXL = dynamicTypeFontSizeXL;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeXXL:(CGFloat)dynamicTypeFontSizeXXL {
    _dynamicTypeFontSizeXXL = dynamicTypeFontSizeXXL;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (void)setDynamicTypeFontSizeXXXL:(CGFloat)dynamicTypeFontSizeXXXL {
    _dynamicTypeFontSizeXXXL = dynamicTypeFontSizeXXXL;
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

- (CGFloat)fontSizeForPreferredContentSize:(NSString *)sizeCategory {
    CGFloat regularFontSize = self.fontSize;
    CGFloat dynamicTypeFontSize = regularFontSize;

    if ([sizeCategory isEqualToString:UIContentSizeCategoryExtraSmall]) {
        if (self.dynamicTypeFontSizeXS != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeXS;
        } else {
            dynamicTypeFontSize = regularFontSize - 3;
        }
    } else if ([sizeCategory isEqualToString:UIContentSizeCategorySmall]) {
        if (self.dynamicTypeFontSizeS != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeS;
        } else {
            dynamicTypeFontSize = regularFontSize - 2;
        }
    } else if ([sizeCategory isEqualToString:UIContentSizeCategoryMedium]) {
        if (self.dynamicTypeFontSizeM != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeM;
        } else {
            dynamicTypeFontSize = regularFontSize - 1;
        }
    } else if ([sizeCategory isEqualToString:UIContentSizeCategoryLarge]) {
        if (self.dynamicTypeFontSizeL != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeL;
        } else {
            dynamicTypeFontSize = regularFontSize;
        }
    } else if ([sizeCategory isEqualToString:UIContentSizeCategoryExtraLarge]) {
        if (self.dynamicTypeFontSizeXL != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeXL;
        } else {
            dynamicTypeFontSize = regularFontSize + 1;
        }
    } else if ([sizeCategory isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        if (self.dynamicTypeFontSizeXXL != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeXXL;
        } else {
            dynamicTypeFontSize = regularFontSize + 2;
        }
    } else if ([sizeCategory isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        if (self.dynamicTypeFontSizeXXXL != NSNotFound) {
            dynamicTypeFontSize = self.dynamicTypeFontSizeXXXL;
        } else {
            dynamicTypeFontSize = regularFontSize + 3;
        }
    } else {
        dynamicTypeFontSize = [self fontSizeForPreferredContentSize:UIContentSizeCategoryExtraExtraExtraLarge];

        if (self.dynamicTypeAccessibilityEnabled) {
            if ([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
                if (self.dynamicTypeFontSizeAccessibilityM != NSNotFound) {
                    dynamicTypeFontSize = self.dynamicTypeFontSizeAccessibilityM;
                } else {
                    dynamicTypeFontSize = dynamicTypeFontSize * 1.4;
                }
            } else if ([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
                if (self.dynamicTypeFontSizeAccessibilityL != NSNotFound) {
                    dynamicTypeFontSize = self.dynamicTypeFontSizeAccessibilityL;
                } else {
                    dynamicTypeFontSize = dynamicTypeFontSize * 1.65;
                }
            } else if ([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
                if (self.dynamicTypeFontSizeAccessibilityXL != NSNotFound) {
                    dynamicTypeFontSize = self.dynamicTypeFontSizeAccessibilityXL;
                } else {
                    dynamicTypeFontSize = dynamicTypeFontSize * 2;
                }
            } else if ([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
                if (self.dynamicTypeFontSizeAccessibilityXXL != NSNotFound) {
                    dynamicTypeFontSize = self.dynamicTypeFontSizeAccessibilityXXL;
                } else {
                    dynamicTypeFontSize = dynamicTypeFontSize * 2.35;
                }
            } else if ([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
                if (self.dynamicTypeFontSizeAccessibilityXXXL != NSNotFound) {
                    dynamicTypeFontSize = self.dynamicTypeFontSizeAccessibilityXXXL;
                } else {
                    dynamicTypeFontSize = dynamicTypeFontSize * 2.65;
                }
            }
        }
    }

    return dynamicTypeFontSize;
}

- (void)didChangePreferredContentSize:(NSNotification *)notification {
    if (self.dynamicTypeEnabled) {
        [self update];
    }
}

#endif



#pragma mark Text Properties

- (void)setTextStrokeWidth:(CGFloat)textStrokeWidth {
    _textStrokeWidth = textStrokeWidth;
    [self update];
}

- (void)setTextStrokeColor:(DYEColor *)textStrokeColor {
    _textStrokeColor = textStrokeColor;
    [self update];
}

- (void)setTextShadowRadius:(CGFloat)textShadowRadius {
    _textShadowRadius = textShadowRadius;
    _textShadowBlur = textShadowRadius * 2.0;
    [self update];
}

- (void)setTextShadowBlur:(CGFloat)textShadowBlur {
    _textShadowBlur = textShadowBlur;
    _textShadowRadius = textShadowBlur / 2.0;
    [self update];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
    _textShadowOffset = textShadowOffset;
    [self update];
}

- (void)setTextShadowColor:(DYEColor *)textShadowColor {
    _textShadowColor = textShadowColor;
    [self update];
}

- (void)setTextTransform:(DYETextTransform)textTransform {
    _textTransform = textTransform;
    [self update];
}

- (void)setTextUnderline:(BOOL)textUnderline {
    _textUnderline = textUnderline;
    [self update];
}

- (void)setTextStrikethrough:(BOOL)textStrikethrough {
    _textStrikethrough = textStrikethrough;
    [self update];
}

- (void)setTextCharacterSpacing:(CGFloat)textCharacterSpacing {
    _textCharacterSpacing = textCharacterSpacing;
    [self update];
}



#pragma mark Paragraph Properties

- (void)setTextLineHeightMultiple:(CGFloat)textLineHeightMultiple {
    _textLineHeightMultiple = textLineHeightMultiple;
    [self update];
}

- (void)setTextLineHeight:(CGFloat)textLineHeight {
    _textLineHeight = textLineHeight;
    [self update];
}



#pragma mark Update

- (void)update {
    _darkerStyle = nil;
    _lighterStyle = nil;

    if ([[[DYEStyle dye_styleablesTables] objectForKey:self.dyeStyleName] count] > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateStyleables) object:nil];
        [self performSelector:@selector(updateStyleables) withObject:nil afterDelay:0];
    }
}

- (void)updateStyleables {
    NSLog(@"[Dye]: Update styleables for style \"%@\"", self.dyeStyleName);

    NSHashTable *styleablesTable = [[[DYEStyle dye_styleablesTables] objectForKey:self.dyeStyleName] copy];
    for (id<DYEStyleable> styleableObject in styleablesTable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DYEStyleWillUpdateStyleableNotification object:self userInfo:@{ @"styleable": styleableObject, @"style": self }];

        [styleableObject dye_updateStyling];

        [[NSNotificationCenter defaultCenter] postNotificationName:DYEStyleDidUpdateStyleableNotification object:self userInfo:@{ @"styleable": styleableObject, @"style": self }];
    }
}



#pragma mark Weak DYEStyleable Storage

+ (NSMutableDictionary *)dye_styleablesTables {
    static NSMutableDictionary *_dye_styleablesTables;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dye_styleablesTables = [[NSMutableDictionary alloc] init];
    });

    return _dye_styleablesTables;
}

+ (void)addStyleable:(id<DYEStyleable>)styleableObject {
    NSString *styleName = [styleableObject dyeStyleName];
    DYEStyle *style = [DYEStyle styleNamed:styleName];

    if (style) {
        NSHashTable *hashTable = [[self dye_styleablesTables] objectForKey:style.dyeStyleName];
        if (!hashTable) {
            hashTable = [NSHashTable weakObjectsHashTable];
        }

        [hashTable addObject:styleableObject];
        [[self dye_styleablesTables] setObject:hashTable forKey:style.dyeStyleName];
    }
}

+ (void)removeStyleable:(id<DYEStyleable>)styleableObject {
    NSString *styleName = [styleableObject dyeStyleName];
    DYEStyle *style = [DYEStyle styleNamed:styleName];

    if (style) {
        NSHashTable *hashTable = [[self dye_styleablesTables] objectForKey:style.dyeStyleName];
        [hashTable removeObject:styleableObject];

        if ([hashTable count] == 0) {
            [[self dye_styleablesTables] removeObjectForKey:style.dyeStyleName];
        }
    }
}



#pragma mark Debug

- (void)setInfo:(NSString *)info {
    _info = info;
}

- (NSString *)debugDescription {
    NSMutableString *description = [[super description] mutableCopy];
    if ([description length] > 1) {
        [description insertString:[NSString stringWithFormat:@"; name = \"%@\"", self.dyeStyleName] atIndex:[description length]-1];
    }

    return description;
}

@end


