//
//  UIControl+DYEStyleablePrivate.h
//  Dye
//
//  Created by David De Bels on 07/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

#import "UIControl+DYEStyleable.h"



#pragma mark - UIControl DYEPrivateHeader Category Interface -
/**
 A category defining private methods & properties for UIControl+DYEStyleable.
 */
@interface UIControl (DYEPrivateHeader)

#pragma mark Responding to State Changes

// This method will be called when the highlighted state has changed.
- (void)dye_didChangeHighlightedState:(BOOL)highlighted;

// This method will be called when the selected state has changed.
- (void)dye_didChangeSelectedState:(BOOL)selected;

// This method will be called when the enabled state has changed.
- (void)dye_didChangeEnabledState:(BOOL)enabled;



#pragma mark Update Styling

// This method will be called whenever settings are applied for a specific state.
- (void)dye_updateControlForStyle:(nonnull DYEStyle *)style state:(UIControlState)state;

// Helper method to return the style for a specific state, including default styles
- (nullable DYEStyle *)dye_styleForState:(UIControlState)state;

@end

