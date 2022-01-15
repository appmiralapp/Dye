//
//  UIImageView+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 17/09/20.
//  (c) 2020 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

#import "DYEStyleable.h"



#pragma mark - UIImageView DYEStyleable Category -
/**
 A UIImageView can be styled using a Dye Style for its normal state and a Dye Style for the focused state (if available).
 
 The following Dye Style properties can be used on UIImageView and its subclasses:
 * Background Color
 * Background Gradient
 * Background Shadow
 * Tint
 * Corner
 * Border
 * Transform
 */
@interface UIImageView (DYEStyleable) <DYEStyleable>

@end
