//
//  UIView+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 21/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

#import "DYEStyleable.h"



#pragma mark - UIView DYEStyleable Category Interface -
/**
 This category, conforming to the DYEStyleable protocol, allows for a UIView (and its subclasses) to be styled with a Dye Style.
 
 A UIView can receive two Dye Styles, one for its normal state and one for the focused state (tvOS only).
 The following Dye Style properties can be used on UIView:
 - Background Color
 - Background Gradient
 - Background Shadow
 - Tint
 - Corner
 - Border
 - Transform
 */
@interface UIView (DYEStyleable) <DYEStyleable>

/**
 Get or set the name of the style to apply to the styleable object.
 */
@property (nonatomic, copy, readwrite, nullable) IBInspectable NSString *dyeStyleName;

/**
 Get or set the name of the style to apply to the styleable object for the focused state.
 */
@property (nonatomic, copy, readwrite, nullable) IBInspectable NSString *dyeFocusedStyleName;

@end


