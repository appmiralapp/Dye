//
//  UISlider+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 22/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

#import "DYEStyleable.h"



#pragma mark - UISlider DYEStyleable Category -
/**
 A UISlider can be styled using a Dye Style for all UIControl states.
 
 The following Dye Style properties can be used on UISlider and its subclasses:
 * Background Color
 * Background Gradient
 * Background Shadow
 * Tint (tintColor is also the minimumTrackTintColor, this is default behavior)
 * Corner
 * Border
 * Transform
 * Color (primaryColor as maximumTrackTintColor)
 
 Currently changing the thumbTintColor is not supported due to a known Apple bug in iOS8 and below.
 
 */
@interface UISlider (DYEStyleable) <DYEStyleable>

@end
