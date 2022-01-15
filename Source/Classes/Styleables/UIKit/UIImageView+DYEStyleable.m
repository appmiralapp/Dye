//
//  UIImageView+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 17/09/20.
//  (c) 2020 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "UIImageView+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEPrivateHeader.h"



#pragma mark - UIImageView DYEStyleable Category -

@implementation UIImageView (DYEStyleable)

- (void)dye_updateStyling {
    [super dye_updateStyling];
    
    NSString* styleName = [self dye_isFocused] ? self.dyeFocusedStyleName : self.dyeStyleName;
    DYEStyle* style = [DYEStyle styleNamed:styleName];
    
    if (style)
    {
        // UIImageView can contain transparent images, so the shadow should always take this into account
        self.layer.shadowPath = nil;
    }
}

@end
