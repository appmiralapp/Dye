//
//  UILabel+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 27/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

#import "DYEStyleable.h"



#pragma mark - UILabel DYEStyleable Category -
/**
 A UILabel can be styled using a Dye Style for its normal state and a Dye Style for the focused state (if available).
 
 The following Dye Style properties can be used on UILabel and its subclasses:
 * Background Color
 * Background Gradient
 * Background Shadow
 * Tint
 * Corner
 * Border
 * Transform
 * Color (primaryColor as textColor)
 * Font
 * Dynamic Type
 * Text
 
 */
@interface UILabel (DYEStyleable) <DYEStyleable>

@end
