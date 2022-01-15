//
//  NSView+DYEStyleablePrivate.h
//  Dye
//
//  Created by David De Bels on 07/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <AppKit/AppKit.h>

#import "NSView+DYEStyleable.h"

@class DYEStyle;
@class DYELinearGradientLayer;



#pragma mark - NSView DYEPrivateHeader Category Interface -
/**
 A category defining private methods & properties for NSView+DYEStyleable.
 */
@interface NSView (DYEPrivateHeader)

@property (nonatomic, strong, readwrite, nullable) DYELinearGradientLayer *dyeBackgroundGradientLayer;



#pragma mark Update Styling

- (void)dye_updateViewForStyle:(nonnull DYEStyle *)style;

- (void)dye_updateBackgroundGradientForStyle:(nonnull DYEStyle *)style;

- (CGRect)dye_backgroundShadowBoundsForStyle:(nonnull DYEStyle *)style;

@end

