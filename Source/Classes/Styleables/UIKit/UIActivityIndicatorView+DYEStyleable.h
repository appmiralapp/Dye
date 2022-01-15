//
//  UIActivityIndicatorView+DYEStyleable.h
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



#pragma mark - UIActivityIndicatorView DYEStyleable Category -
/**
 A UIActivityIndicatorView can be styled using a Dye Style for its normal state and a Dye Style for the focused state (if available).
 
 The following Dye Style properties can be used on UIActivityIndicatorView and its subclasses:
 * Background Color
 * Background Gradient
 * Background Shadow
 * Tint
 * Corner
 * Border
 * Transform
 * Color (primaryColor as color)
 
 */
@interface UIActivityIndicatorView (DYEStyleable) <DYEStyleable>

@end
