//
//  DYEColors.h
//  Dye
//
//  Created by David De Bels on 03/12/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Foundation/Foundation.h>

#import "DYEConstants.h"



#pragma mark - DYEColor Dye Category Interface -

@interface DYEColor (Dye)

/**
 The name of the color in Dye.
 */
@property (nonatomic, strong, readonly, nullable) NSString *dyeColorName;

@end



#pragma mark - DYEColors Interface -

@interface DYEColors : NSObject

#pragma mark Get Defined Colors
/**---------------------------------------------------------------------------------------
 * @name Get Defined Colors
 *  ---------------------------------------------------------------------------------------
 */

/**
 Returns an existing color from the global colors cache.

 @param colorName The name of the color.

 @return A color or nil if no color with this name exists.
 */
+ (nullable DYEColor *)colorNamed:(nonnull NSString *)colorName;

/**
 Returns a dictionary containing all available colors in the global colors cache with their name as key.

 @return A dictionary containing all available colors with their name as key.
 */
+ (nonnull NSDictionary<NSString *, DYEColor *> *)availableColors;



#pragma mark Manage the Colors Cache
/**---------------------------------------------------------------------------------------
 * @name Manage the Colors Cache
 *  ---------------------------------------------------------------------------------------
 */

/**
 Adds a color to the global colors cache. If a color with this name already exists it will be overwritten.

 @param color     The color to add.
 @param colorName The name of the color.
 */
+ (void)addColor:(nonnull DYEColor *)color withName:(nonnull NSString *)colorName;

/**
 Removes a color from the global colors cache.

 @param colorName The name of the color.
 */
+ (void)removeColorWithName:(nonnull NSString *)colorName;

/**
 Removes all colors from the global colors cache.
 */
+ (void)removeAllColors;



#pragma mark Create Colors
/**---------------------------------------------------------------------------------------
 * @name Create Colors
 *  ---------------------------------------------------------------------------------------
 */

/**
 Creates a color based on the values in a dictionary. The following color formats are supported: HEX, RGB, HSL and CMYK, in that order. Valid keys are:
  - "alpha" : A float between 0 and 1. The alpha value of the color, used for all color formats.
  - "a" : A float between 0 and 1. The alpha value of the color, used for all color formats. This is the same as "alpha".
  - "hex" : A 6 character string. The hex color code. e.g. "FF0000"
  - "rgb" : A dictionary containing a "r", "g" & "b" key, values being integers between 0 and 255.
  - "hsv" : A dictionary containing a "h", "s" & "v" key, values being an integer between 0 and 360 for "h", a float between 0 and 1 for "s" and "v".
  - "cmyk" : A dictionary containing a "c", "m", "y" & "k" key, values being floats between 0 and 1.

 @param dictionary A dictionary.

 @return A color or nil if the dictionary had invalid or missing values.
 */
+ (nullable DYEColor *)colorFromDictionary:(nonnull NSDictionary *)dictionary;

/**
 Creates a color using the RGB model, based on 0-255 red, green and blue values and a 0-1 alpha value.

 @param red   The red value of the color.
 @param green The green value of the color.
 @param blue  The blue value of the color.
 @param alpha The alpha value of the color.

 @return A color.
 */
+ (nonnull DYEColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 Creates a color using the HSB/HSV model, based on a 0-360 hue value, 0-1 saturation and brightness values and a 0-1 alpha value.

 @param hue The hue value of the color.
 @param saturation The saturation value of the color.
 @param brightness The brightness value of the color.
 @param alpha The alpha value of the color.

 @return A color.
 */
+ (nonnull DYEColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;

/**
 Create a color based on 0-1 CMYK values and a 0-1 alpha value.

 @param cyan The cyan value of the color.
 @param magenta The magenta value of the color.
 @param yellow  The yellow value of the color.
 @param black The key (black) value of the color.
 @param alpha The alpha value of the color.

 @return A color.
 */
+ (nonnull DYEColor *)colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow black:(CGFloat)black alpha:(CGFloat)alpha;

/**
 Create a color based on a 6 (RGB) or 8 (RGBA) character string. If a 6 character string, the alpha will be 1.

 @param hex The hex value of the color. e.g. "FF0000" or "FF0000FF"

 @return A color or nil if the hex string was invalid.
 */
+ (nullable DYEColor *)colorWithHex:(nonnull NSString *)hex;

/**
 Create a color based on a 6 (RGB) character string and a 0-1 alpha value.

 @param hex The hex value of the color. e.g. "FF0000"
 @param alpha The alpha value of the color.

 @return A color or nil if the hex string was invalid.
 */
+ (nullable DYEColor *)colorWithHex:(nonnull NSString *)hex alpha:(CGFloat)alpha;

/**
 Create a slightly darker color based on an existing color. This algorithm will provide a similar result as the one Apple utilises for highlighted states.

 @param color The existing color.

 @return A color slightly darker than the existing color.
 */
+ (nonnull DYEColor *)darkerColorForColor:(nonnull DYEColor *)color;

/**
 Create a slightly lighter color based on an existing color. This algorithm will provide a similar result as the one Apple utilises for disabled states.

 @param color The existing color.

 @return A color slightly lighter than the existing color.
 */
+ (nonnull DYEColor *)lighterColorForColor:(nonnull DYEColor *)color;



#pragma mark Debugging
/**---------------------------------------------------------------------------------------
 * @name Debugging
 *  ---------------------------------------------------------------------------------------
 */

/**
 Returns the preferred color format. This is mainly used for visualizing colors in debug descriptions. Default is RGB.

 @return The preferred color format.
 */
+ (DYEColorFormat)preferredColorFormat;

/**
 Set the preferred color format. This is mainly used for visualizing colors in debug descriptions.

 @param colorFormat The preferred color format.
 */
+ (void)setPreferredColorFormat:(DYEColorFormat)colorFormat;

@end
