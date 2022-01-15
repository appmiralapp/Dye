//
//  NSView+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 23/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

#import "DYEStyleable.h"



#pragma mark - NSView DYEStyleable Category Interface -
/**
 This category, conforming to the DYEStyleable protocol, allows for an NSView (and its subclasses) to be styled with a Dye Style.
 
 An NSView can receive one Dye Style.
 The following Dye Style properties can be used on UIView:
 - Background Color
 - Background Gradient
 - Background Shadow
 - Tint
 - Corner
 - Border
 - Transform
 */
@interface NSView (DYEStyleable) <DYEStyleable>

/**
 Get or set the name of the style to apply to the styleable object.
 */
@property (nonatomic, copy, readwrite, nullable) IBInspectable NSString *dyeStyleName;

@end
