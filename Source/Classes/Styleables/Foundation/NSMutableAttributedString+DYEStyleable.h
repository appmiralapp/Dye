//
//  NSMutableAttributedString+DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 05/03/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Foundation/Foundation.h>


#import "DYEStyleable.h"



#pragma mark - NSMutableAttributedString DYEStyleable Category -
/**
 NSMutableAttributedString supports the following style properties:
 
 Styleable properties contain:
 * Font
 * Dynamic type
 * Text color
 * Text stroke
 * Text shadow
 * Text underlined
 * Text transform
 * Text lineheight
 
 */
@interface NSMutableAttributedString (DYEStyleable) <DYEStyleable>

/**
 *  Get or set the name of the style to apply to the styleable object.
 */
@property (nonatomic, copy) NSString* _Nullable dyeStyleName;

/**
 *  Get or set the line break mode.
 */
@property (nonatomic, assign) NSLineBreakMode dyeLineBreakMode;

@end
