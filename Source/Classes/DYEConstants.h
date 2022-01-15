//
//  DYEConstants.h
//  Dye
//
//  Created by David De Bels on 21/07/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#define DYEColor NSColor
#define DYEFont NSFont
#define DYEFontDescriptor NSFontDescriptor
#else
#import <UIKit/UIKit.h>
#define DYEColor UIColor
#define DYEFont UIFont
#define DYEFontDescriptor UIFontDescriptor
#endif

typedef NS_ENUM (NSUInteger, DYEColorFormat) {
    DYEColorFormatRGB = 0,
    DYEColorFormatHSB = 1,
    DYEColorFormatCMYK = 2,
    DYEColorFormatHex = 3
};

typedef NS_ENUM (NSUInteger, DYEFileFormat) {
    DYEFileFormatJSON = 0
};

typedef NS_ENUM (NSUInteger, DYEGradientType) {
    DYEGradientTypeLinear = 0
};

typedef NS_ENUM (NSUInteger, DYETextTransform) {
    DYETextTransformNone = 0,
    DYETextTransformUppercase = 1,
    DYETextTransformLowercase = 2,
    DYETextTransformCapitalize = 3
};
