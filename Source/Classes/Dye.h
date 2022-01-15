//
//  Dye.h
//  Dye
//
//  Created by David De Bels on 03/07/17.
//  (c) 2017 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Foundation/Foundation.h>

//! Project version number for Dye.
FOUNDATION_EXPORT double DyeVersionNumber;

//! Project version string for Dye.
FOUNDATION_EXPORT const unsigned char DyeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Dye/PublicHeader.h>

#ifndef _DYE_
#define _DYE_

// Dye
#import <Dye/DYEStyle.h>
#import <Dye/DYEStyleable.h>
 
// Dye Colors
#import <Dye/DYEColors.h>

// Importers
#import <Dye/DYEColors+FileImport.h>
#import <Dye/DYEStyle+FileImport.h>
#import <Dye/DYEStyle+JSON.h>
#import <Dye/DYEColors+JSON.h>

// Categories
#import <Dye/DYEStyle+StringAttributes.h>

// Styleables
#import <Dye/NSMutableAttributedString+DYEStyleable.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <Dye/UIView+DYEStyleable.h>
#import <Dye/UIControl+DYEStyleable.h>
#import <Dye/UIImageView+DYEStyleable.h>
#import <Dye/UILabel+DYEStyleable.h>
#import <Dye/UIButton+DYEStyleable.h>
#import <Dye/UITextField+DYEStyleable.h>
#import <Dye/UIActivityIndicatorView+DYEStyleable.h>
#import <Dye/UIPageControl+DYEStyleable.h>
#import <Dye/UIProgressView+DYEStyleable.h>
#endif

#if TARGET_OS_IOS
#import <Dye/UISwitch+DYEStyleable.h>
#import <Dye/UISlider+DYEStyleable.h>
#endif

#if TARGET_OS_OSX
#import <Dye/NSView+DYEStyleable.h>
#endif

#endif
