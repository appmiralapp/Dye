//
//  DYEStyleable.h
//  Dye
//
//  Created by David De Bels on 21/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

IB_DESIGNABLE

#import <Foundation/Foundation.h>

#import "DYEConstants.h"

@class DYEStyle;



#pragma mark - DYEStyleable Protocol -

@protocol DYEStyleable <NSObject>

@required

/**
 Get or set the name of the style to apply to the styleable object.
 */
@property (nonatomic, copy, readwrite, nullable) IBInspectable NSString *dyeStyleName;

/**
 The object should update its appearance based on its style in this method. If a style changes, this method will be called automatically on every object that uses the style. Make sure to always call super if the superclass is already implementing the DYEStyleable protocol, e.g. UIView or UIControl.
 */
- (void)dye_updateStyling;

@end

