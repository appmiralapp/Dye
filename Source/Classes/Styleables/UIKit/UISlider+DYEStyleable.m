//
//  UISlider+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 22/02/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "UISlider+DYEStyleable.h"

#import "DYEStyle.h"
#import "UIView+DYEPrivateHeader.h"
#import "UIControl+DYEPrivateHeader.h"



#pragma mark - UISlider DYEStyleable Category -

@implementation UISlider (DYEStyleable)

#pragma mark Update Styling

- (void)dye_updateStyling {
    [super dye_updateStyling];
}

- (void)dye_updateControlForStyle:(DYEStyle *)style state:(UIControlState)state {
    if (style) {
        // This is a fix for a known bug where the UISlider bar would be misplaced and throw CGContext errors
        // http://stackoverflow.com/questions/21683348/uislider-setmaximumtracktintcolor
        // http://stackoverflow.com/questions/22345668/uislider-setmaximumtracktintcolor-in-ios-7-1
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            CGRect rect = CGRectMake(0, 0, 2, 2);
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            [style.primaryColor setFill];
            UIRectFill(rect);
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [self setMaximumTrackImage:image forState:self.state];
        } else {
            self.maximumTrackTintColor = style.primaryColor;
        }
    }
}

@end
