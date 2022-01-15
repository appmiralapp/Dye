//
//  DYEStyle.h
//  Dye
//
//  Created by David De Bels on 21/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "DYEStyleable.h"
#import "DYEConstants.h"

extern NSString * _Nonnull DYEStyleWillUpdateStyleableNotification;
extern NSString * _Nonnull DYEStyleDidUpdateStyleableNotification;

extern NSString * _Nonnull DYEFontWeightUltraLight;
extern NSString * _Nonnull DYEFontWeightThin;
extern NSString * _Nonnull DYEFontWeightLight;
extern NSString * _Nonnull DYEFontWeightRegular;
extern NSString * _Nonnull DYEFontWeightMedium;
extern NSString * _Nonnull DYEFontWeightSemiBold;
extern NSString * _Nonnull DYEFontWeightBold;
extern NSString * _Nonnull DYEFontWeightHeavy;
extern NSString * _Nonnull DYEFontWeightBlack;



#pragma mark - DYEStyle Interface -

@interface DYEStyle : NSObject

#pragma mark Get Defined Styles
/**---------------------------------------------------------------------------------------
 * @name Get Defined Styles
 *  ---------------------------------------------------------------------------------------
 */

/**
 Returns an existing color from the global styles cache.

 @param name The name of the style.

 @return A Dye style or nil if no style with this name exists.
 */
+ (nullable DYEStyle *)styleNamed:(nonnull NSString *)name;

/**
 Returns a dictionary containing all available styles in the global styles cache with their name as key.

 @return A dictionary containing all available styles with their name as key.
 */
+ (nonnull NSDictionary<NSString *, DYEStyle *> *)availableStyles;



#pragma mark Manage the Styles Cache
/**---------------------------------------------------------------------------------------
 * @name Manage the Styles Cache
 *  ---------------------------------------------------------------------------------------
 */

/**
 Adds a style to the global styles cache. If a style with this name already exists it will be overwritten.

 @param style     The style to add.
 @param styleName The name of the style.
 */
+ (void)addStyle:(nonnull DYEStyle *)style withName:(nonnull NSString *)styleName;

/**
 Removes a style from the global styles cache.

 @param styleName The name of the style.
 */
+ (void)removeStyleWithName:(nonnull NSString *)styleName;

/**
 Removes all styles from the global styles cache.
 */
+ (void)removeAllStyles;



#pragma mark Initialize Styles
/**---------------------------------------------------------------------------------------
 * @name Initialize Styles
 *  ---------------------------------------------------------------------------------------
 */

- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 Initialize a new style with all the default values.

 @param dyeStyleName The name of the style.

 @return An initialized DYEStyle object.
 */
- (nonnull instancetype)initWithName:(nonnull NSString *)dyeStyleName;

/**
 Initialize a new style with all the values of a parent style. If the parent style does not exist, the default values will be used.

 @param dyeStyleName The name of the style.
 @param parentStyleName The name of the parent of the style.

 @return An initialized DYEStyle object.
 */
- (nonnull instancetype)initWithName:(nonnull NSString *)dyeStyleName parentStyleName:(nullable NSString *)parentStyleName NS_DESIGNATED_INITIALIZER;



#pragma mark Style Information
/**---------------------------------------------------------------------------------------
 * @name Style Information
 *  ---------------------------------------------------------------------------------------
 */

/**
 The name of the style. This value is unique.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *dyeStyleName;

/**
 The parent style or nil if there is none.
 */
@property (nonatomic, strong, readonly, nullable) DYEStyle *parentStyle;

/**
 Returns a darker version of the style, all colors have a darker color.
 */
@property (nonatomic, strong, readonly, nonnull) DYEStyle *darkerStyle;

/**
 Returns a lighter version of the style, all colors have a lighter color.
 */
@property (nonatomic, strong, readonly, nonnull) DYEStyle *lighterStyle;



#pragma mark Background Color Properties
/**---------------------------------------------------------------------------------------
 * @name Background Color Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the background color. Default is nil.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *backgroundColor;



#pragma mark Background Gradient Properties
/**---------------------------------------------------------------------------------------
 * @name Background Gradient Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the background gradient colors. This is an array of at least 2 DYEColor objects. Default is nil.
 */
@property (nonatomic, strong, readwrite, nullable) NSArray<DYEColor *> *backgroundGradientColors;

/**
 Get or set the background gradient positions. This is an array of NSNumber objects with values between 0.0 and 1.0. This array should contain the same amount of objects as the backgroundGradientColors array. If it doesn't the gradient positions will be spread equally between 0.0 and 1.0. Default is nil.
 */
@property (nonatomic, strong, readwrite, nullable) NSArray<NSNumber *> *backgroundGradientPositions;

/**
 Get or set the start point for the gradient. Top left being {0.0, 0.0} and bottom right being {1.0, 1.0}. Default is {0.5, 0.0}.
 */
@property (nonatomic, assign, readwrite) CGPoint backgroundGradientStartPoint;

/**
 Get or set the end point for the gradient. Top left being {0.0, 0.0} and bottom right being {1.0, 1.0}. Default is {0.5, 1.0}.
 */
@property (nonatomic, assign, readwrite) CGPoint backgroundGradientEndPoint;



#pragma mark Background Shadow Properties
/**---------------------------------------------------------------------------------------
 * @name Background Shadow Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the background shadow radius. This is always half of the backgroundShadowBlur. Setting this will also modify backgroundShadowBlur. Default is 3.
 */
@property (nonatomic, assign, readwrite) CGFloat backgroundShadowRadius;

/**
 Get or set the background shadow blur. This is always double of the backgroundShadowRadius. Setting this will also modify backgroundShadowRadius. Default is 6.
 */
@property (nonatomic, assign, readwrite) CGFloat backgroundShadowBlur;

/**
 Get or set the background shadow offset. Default is {0.0, -3.0}.
 */
@property (nonatomic, assign, readwrite) CGSize backgroundShadowOffset;

/**
 Get or set the background shadow color. Default is black with alpha of 0.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *backgroundShadowColor;

/**
 Get or set the background shadow spread. Setting this will expand the shadowPath by the amount on each side. Default is 0.
 */
@property (nonatomic, assign, readwrite) CGFloat backgroundShadowSpread;



#pragma mark Tint Properties
/**---------------------------------------------------------------------------------------
 * @name Tint Properties
 *  ---------------------------------------------------------------------------------------
 */

@property (nonatomic, strong, readwrite, nullable) DYEColor *tintColor;



#pragma mark Corner Properties
/**---------------------------------------------------------------------------------------
 * @name Corner Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the corner radius. Default is 0.
 */
@property (nonatomic, assign, readwrite) CGFloat cornerRadius;



#pragma mark Border Properties
/**---------------------------------------------------------------------------------------
 * @name Border Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the border width. Default is 0.
 */
@property (nonatomic, assign, readwrite) CGFloat borderWidth;

/**
 Get or set the border color. Default is nil.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *borderColor;



#pragma mark Transform Properties
/**---------------------------------------------------------------------------------------
 * @name Transform Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the translation transform in points. Default is {0.0, 0.0}.
 */
@property (nonatomic, assign, readwrite) CGPoint transformTranslation;

/**
 Get or set the rotation transform in degrees. Default is 0.
 */
@property (nonatomic, assign, readwrite) CGFloat transformRotation;

/**
 Get or set the scale transform in percentage. Default is {1.0, 1.0}.
 */
@property (nonatomic, assign, readwrite) CGPoint transformScale;



#pragma mark Color Properties
/**---------------------------------------------------------------------------------------
 * @name Color Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the primary color. This can have a different functionality for every styleable object.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *primaryColor;

/**
 Get or set the secondary color. This can have a different functionality for every styleable object.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *secondaryColor;



#pragma mark Font Properties
/**---------------------------------------------------------------------------------------
 * @name Font Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get the font.
 */
@property (nonatomic, strong, readonly, nullable) DYEFont *font;

/**
 Get or set the font name. Default is the name of the system font.
 */
@property (nonatomic, strong, readwrite, nullable) NSString *fontName;

/**
 Get or set the font weight. This should be UltraLight, Thin, Light, Regular, Medium, SemiBold, Bold, Heavy, Black.
 */
@property (nonatomic, strong, readwrite, nullable) NSString *fontWeight;

/**
 Get or set the font size in points. Default is 12.
 */
@property (nonatomic, assign, readwrite) CGFloat fontSize;



#pragma mark Dynamic Type Properties
/**---------------------------------------------------------------------------------------
 * @name Dynamic Type Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set whether or not to support Dynamic Type. Default is NO.
 */
@property (nonatomic, assign, readwrite) BOOL dynamicTypeEnabled;

/**
 Get or set whether or not to support Dynamic Type Accessibility Sizes. Default is NO. The system text styles use this only for body text.
 */
@property (nonatomic, assign, readwrite) BOOL dynamicTypeAccessibilityEnabled;

/**
 Get or set the font size for UIContentSizeCategoryExtraSmall. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategoryExtraSmall will be equal to fontSize - 3.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeXS;

/**
 Get or set the font size for UIContentSizeCategorySmall. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategorySmall will be equal to fontSize - 2.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeS;

/**
 Get or set the font size for UIContentSizeCategoryMedium. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategoryMedium will be equal to fontSize - 1.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeM;

/**
 Get or set the font size for UIContentSizeCategoryLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategoryLarge will be equal to fontSize.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeL;

/**
 Get or set the font size for UIContentSizeCategoryExtraLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategoryExtraLarge will be equal to fontSize + 1.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeXL;

/**
 Get or set the font size for UIContentSizeCategoryExtraExtraLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategoryExtraExtraLarge will be equal to fontSize + 2.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeXXL;

/**
 Get or set the font size for UIContentSizeCategoryExtraExtraExtraLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled is YES then the font size for UIContentSizeCategoryExtraExtraExtraLarge will be equal to fontSize + 3.
 @see fontSize
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeXXXL;

/**
 Get or set the font size for UIContentSizeCategoryAccessibilityMedium. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled and dynamicTypeAccessibilityEnabled are YES then the font size for UIContentSizeCategoryAccessibilityMedium will be equal to dynamicTypeFontSizeXXXL * 1.4.
 @see dynamicTypeFontSizeXXXL
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeAccessibilityM;

/**
 Get or set the font size for UIContentSizeCategoryAccessibilityLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled and dynamicTypeAccessibilityEnabled are YES then the font size for UIContentSizeCategoryAccessibilityLarge will be equal to dynamicTypeFontSizeXXXL * 1.65.
 @see dynamicTypeFontSizeXXXL
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeAccessibilityL;

/**
 Get or set the font size for UIContentSizeCategoryAccessibilityExtraLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled and dynamicTypeAccessibilityEnabled are YES then the font size for UIContentSizeCategoryAccessibilityExtraLarge will be equal to dynamicTypeFontSizeXXXL * 2.
 @see dynamicTypeFontSizeXXXL
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeAccessibilityXL;

/**
 Get or set the font size for UIContentSizeCategoryAccessibilityExtraExtraLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled and dynamicTypeAccessibilityEnabled are YES then the font size for UIContentSizeCategoryAccessibilityExtraExtraLarge will be equal to dynamicTypeFontSizeXXXL * 2.35.
 @see dynamicTypeFontSizeXXXL
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeAccessibilityXXL;

/**
 Get or set the font size for UIContentSizeCategoryAccessibilityExtraExtraExtraLarge. Default is NSNotFound. If this is NSNotFound and dynamicTypeEnabled and dynamicTypeAccessibilityEnabled are YES then the font size for UIContentSizeCategoryAccessibilityExtraExtraExtraLarge will be equal to dynamicTypeFontSizeXXXL * 2.65.
 @see dynamicTypeFontSizeXXXL
 */
@property (nonatomic, assign, readwrite) CGFloat dynamicTypeFontSizeAccessibilityXXXL;



#pragma mark Text Properties
/**---------------------------------------------------------------------------------------
 * @name Text Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the text stroke width.
 */
@property (nonatomic, assign, readwrite) CGFloat textStrokeWidth;

/**
 Get or set the text stroke color.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *textStrokeColor;

/**
 Get or set the text shadow radius. This is always double of the textShadowBlur. Setting this will also modify textShadowBlur. Default is 0.
 */
@property (nonatomic, assign, readwrite) CGFloat textShadowRadius;

/**
 Get or set the text shadow blue. This is always double of the textShadowRadius. Setting this will also modify textShadowRadius. Default is 0.
 */
@property (nonatomic, assign, readwrite) CGFloat textShadowBlur;

/**
 Get or set the text shadow offset.
 */
@property (nonatomic, assign, readwrite) CGSize textShadowOffset;

/**
 Get or set the text shadow color.
 */
@property (nonatomic, strong, readwrite, nullable) DYEColor *textShadowColor;

/*
 *  Get or set the text tranform.
 */
@property (nonatomic, assign, readwrite) DYETextTransform textTransform;

/*
 *  Get or set whether or not the text should be underlined.
 */
@property (nonatomic, assign, readwrite) BOOL textUnderline;

/*
 *  Get or set whether or not the text should be underlined.
 */
@property (nonatomic, assign) BOOL textStrikethrough;

/*
 *  Get or set the text character spacing.
 */
@property (nonatomic, assign, readwrite) CGFloat textCharacterSpacing;



#pragma mark Paragraph Properties
/**---------------------------------------------------------------------------------------
 * @name Paragraph Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set the text line height multiplier.
 */
@property (nonatomic, assign, readwrite) CGFloat textLineHeightMultiple;

/**
 Get or set the text line height.
 */
@property (nonatomic, assign, readwrite) CGFloat textLineHeight;


#pragma mark Debugging Properties
/**---------------------------------------------------------------------------------------
 * @name Debugging Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 Get or set additional info about this style. This should not be used by any styleable object!! This property exists to give the developer additional information about this style.
 */
@property (nonatomic, strong, readwrite, nullable) NSString *info;

@end


