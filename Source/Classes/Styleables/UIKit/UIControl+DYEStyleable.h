//
//  UIControl+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 06/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

#import "UIView+DYEStyleable.h"



#pragma mark - UIControl DYEStyleable Category -
/**
 A UIControl can be styled with a Dye Style for most control states. These are the supported control states:
 * Normal (UIControlStateNormal)
 * Highlighted (UIControlStateHighlighted) and (UIControlStateFocused | UIControlStateHighlighted)
 * Selected (UIControlStateSelected)
 * Disabled (UIControlStateDisabled)
 * Focused (UIControlStateFocused)
 * Selected + highlighted (UIControlStateSelected | UIControlStateHighlighted)
 * Selected + disabled (UIControlStateSelected | UIControlStateDisabled)
 * Selected + focused (UIControlStateSelected | UIControlStateFocused)
 
 Styleable properties contain:
 * Background color
 * Background gradient
 * Background shadow
 * Corner radius
 * Border
 
 */
@interface UIControl (DYEStyleable)

/**
 *  Get or set the name of the style to apply to the styleable object for the highlighted state. (UIControlStateHighlighted)
 */
@property (nonatomic, copy, nullable) IBInspectable NSString* dyeHighlightedStyleName;

/**
 *  Get or set the name of the style to apply to the styleable object for the selected state. (UIControlStateSelected)
 */
@property (nonatomic, copy, nullable) IBInspectable NSString* dyeSelectedStyleName;

/**
 *  Get or set the name of the style to apply to the styleable object for the disabled state. (UIControlStateDisabled)
 */
@property (nonatomic, copy, nullable) IBInspectable NSString* dyeDisabledStyleName;

/**
 *  Get or set the name of the style to apply to the styleable object for the selected highlighted state. (UIControlStateSelected | UIControlStateHighlighted)
 */
@property (nonatomic, copy, nullable) IBInspectable NSString* dyeSelectedHighlightedStyleName;

/**
 *  Get or set the name of the style to apply to the styleable object for the selected disabled state. (UIControlStateSelected | UIControlStateDisabled)
 */
@property (nonatomic, copy, nullable) IBInspectable NSString* dyeSelectedDisabledStyleName;

/**
 *  Get or set the name of the style to apply to the styleable object for the selected focused state. (UIControlStateSelected | UIControlStateFocused)
 */
@property (nonatomic, copy, nullable) IBInspectable NSString* dyeSelectedFocusedStyleName;

/**
 *  When set to YES and no style is provided for the highlighted state, a darker version of the current style will be used.
 */
@property (nonatomic, assign) IBInspectable BOOL dyeUseDefaultHighlightedStyle;

/**
 *  When set to YES and no style is provided for the disabled state, a lighter version of the current style will be used.
 */
@property (nonatomic, assign) IBInspectable BOOL dyeUseDefaultDisabledStyle;

/**
 *  Get the name of the style for a specific control state.
 *
 *  @param state A control state.
 *
 *  @return The name of the style for the control state or nil if it doesn't exist.
 */
-(NSString* _Nullable)dyeStyleNameForControlState:(UIControlState)state;

/**
 *  Set the name of the style for a specific control state.
 *
 *  @param dyeStyleName The name of the style for the state.
 *  @param state        The state for which to set the style.
 */
-(void)setDyeStyleName:(NSString* _Nullable)dyeStyleName forState:(UIControlState)state;

@end
