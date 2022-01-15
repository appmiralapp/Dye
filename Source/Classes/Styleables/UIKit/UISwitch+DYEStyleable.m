//
//  UISwitch+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 22/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "UISwitch+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEPrivateHeader.h"
#import "UIControl+DYEPrivateHeader.h"



#pragma mark - UISwitch DYEStyleable Category -

@implementation UISwitch (DYEStyleable)

#pragma mark Update Styling

- (void)dye_updateStyling {
    [super dye_updateStyling];
}

- (void)dye_updateControlForStyle:(DYEStyle *)style state:(UIControlState)state {
    if (style) {
        self.onTintColor = style.primaryColor;
    }
}

@end
