//
//  UIProgressView+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 22/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "UIProgressView+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEPrivateHeader.h"



#pragma mark - UIProgressView DYEStyleable Category -

@implementation UIProgressView (DYEStyleable)

#pragma mark Update Styling

- (void)dye_updateStyling {
    [super dye_updateStyling];
    
    NSString *styleName = [self dye_isFocused] ? self.dyeFocusedStyleName : self.dyeStyleName;
    DYEStyle *style = [DYEStyle styleNamed:styleName];
    
    if (style) {
        self.trackTintColor = style.primaryColor;
    }
}

@end
