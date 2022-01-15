//
//  UITextField+DYEStyleable.h
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

#import "UIControl+DYEStyleable.h"



#pragma mark - UITextField DYEStyleable Category -
/**
 A UITextField can be styled using a Dye Style for all UIControl states.
 
 The following Dye Style properties can be used on UITextField and its subclasses:
 * Background Color
 * Background Gradient
 * Background Shadow
 * Tint (tintColor is also the minimumTrackTintColor, this is default behavior)
 * Corner
 * Border
 * Transform
 * Color (primaryColor as textColor, secondaryColor as the placeholder text color)
 
 */
@interface UITextField (DYEStyleable) <DYEStyleable>

@end
