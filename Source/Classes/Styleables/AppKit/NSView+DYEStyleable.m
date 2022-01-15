//
//  NSView+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 23/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "NSView+DYEStyleable.h"

#import "DYELinearGradientLayer.h"
#import "NSView+DYEPrivateHeader.h"
#import "DYEStyle+DYEPrivateHeader.h"

static void *kDYEStyleNamePropertyKey = &kDYEStyleNamePropertyKey;
static void *kDYEStyleFocusedNamePropertyKey = &kDYEStyleFocusedNamePropertyKey;
static void *kDYEBackgroundGradientPropertyKey = &kDYEBackgroundGradientPropertyKey;

static NSString * const DYEAnimationKey = @"dye.animation";



#pragma mark - NSView DYEStyleable Category Implementation -

@implementation NSView (DYEStyleable)

#pragma mark Load Class

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //[self dye_extendsLayoutSubviews];
        [self dye_extendsSetBounds];
    });
}



#pragma mark Method Swizzling

+ (void)dye_extendsLayoutSubviews {
    
    SEL layoutSEL = @selector(initWithCoder:);
    Method layoutMethod = class_getInstanceMethod(self, layoutSEL);
    
    SEL dye_layoutSEL = @selector(dye_layout:);
    Method dye_layoutMethod = class_getInstanceMethod(self, dye_layoutSEL);
    
    method_exchangeImplementations(layoutMethod, dye_layoutMethod);
}

+ (void)dye_extendsSetBounds {
    
    SEL setBoundsSEL = @selector(setBounds:);
    Method setBoundsMethod = class_getInstanceMethod(self, setBoundsSEL);
    
    SEL dye_setBoundsSEL = @selector(dye_setBounds:);
    Method dye_setBoundsMethod = class_getInstanceMethod(self, dye_setBoundsSEL);
    
    method_exchangeImplementations(setBoundsMethod, dye_setBoundsMethod);
}



#pragma mark Get & Set Styles

- (NSString *)dyeStyleName {
    
    NSString *dyeStyleName = objc_getAssociatedObject(self, kDYEStyleNamePropertyKey);
    return dyeStyleName;
}

- (void)setDyeStyleName:(NSString *)styleName {
    
    // Temporarily remove self as a styleable to avoid any auto updates
    [DYEStyle removeStyleable:self];
    
    // Set the style name and update styling
    objc_setAssociatedObject(self, kDYEStyleNamePropertyKey, styleName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self dye_updateStyling];
    
    // Add to styleables if required
    if (styleName) {
        [DYEStyle addStyleable:self];
    }
}



#pragma mark Additional Properties

- (DYELinearGradientLayer *)dyeBackgroundGradientLayer {
    
    DYELinearGradientLayer *backgroundGradient = objc_getAssociatedObject(self, kDYEBackgroundGradientPropertyKey);
    return backgroundGradient;
}

- (void)setDyeBackgroundGradientLayer:(DYELinearGradientLayer *)gradientLayer {
    
    objc_setAssociatedObject(self, kDYEBackgroundGradientPropertyKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



#pragma mark Update Styling

- (void)dye_updateStyling {
    
    NSString *styleName = self.dyeStyleName;
    DYEStyle *style = [DYEStyle styleNamed:styleName];
    
    [self dye_updateViewForStyle:style];
}

- (void)dye_updateViewForStyle:(DYEStyle *)style {
    
    if (style) {
    
        // Wants layer
        if (!self.layer) {
            self.layer = self.makeBackingLayer;
            [self setWantsLayer:YES];
        }
        self.wantsLayer = YES;
        
        // Background
        self.layer.backgroundColor = style.backgroundColor.CGColor;
        
        // Corners
        self.layer.cornerRadius = style.cornerRadius;
        self.dyeBackgroundGradientLayer.cornerRadius = style.cornerRadius + 0.05;
        
        // Border
        self.layer.borderWidth = style.borderWidth;
        self.layer.borderColor = [style.borderColor CGColor];
        
        // Apply background shadow
        if (style.backgroundShadowColor && (!CGSizeEqualToSize(style.backgroundShadowOffset, CGSizeZero) || style.backgroundShadowRadius > 0) && ![style.backgroundShadowColor isEqual:[NSColor clearColor]]) {
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowOffset = NSMakeSize(style.backgroundShadowOffset.width, style.backgroundShadowOffset.width);
            shadow.shadowBlurRadius = style.backgroundShadowRadius;
            shadow.shadowColor = style.backgroundShadowColor;
            [self setShadow:shadow];
        } else {
            [self setShadow:nil];
        }
        
        // Transform
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (style.transformRotation != 0) {
            transform = CGAffineTransformRotate(transform, ((M_PI * style.transformRotation) / 180.0));
        }
        if (!CGPointEqualToPoint(style.transformScale, CGPointMake(1, 1))) {
            transform = CGAffineTransformScale(transform, style.transformScale.x, style.transformScale.y);
        }
        if (!CGPointEqualToPoint(style.transformTranslation, CGPointZero)) {
            transform = CGAffineTransformTranslate(transform, style.transformTranslation.x, style.transformTranslation.y);
        }
        self.layer.affineTransform = transform;
        
        // Changing the anchor point will also change the position of the layer, this code corrects that
        // From https://gist.github.com/aral/a6f1de2bc48bc0602c9c
        CGPoint anchorPoint = CGPointMake(0.5, 0.5);
        CGPoint newPoint = CGPointMake(self.layer.bounds.size.width * anchorPoint.x, self.layer.bounds.size.height * anchorPoint.y);
        CGPoint oldPoint = CGPointMake(self.layer.bounds.size.width * self.layer.anchorPoint.x, self.layer.bounds.size.height * self.layer.anchorPoint.y);
        newPoint = CGPointApplyAffineTransform(newPoint, transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, transform);
        
        CGPoint position = self.layer.position;
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
    
    // Background gradient
    [self dye_updateBackgroundGradientForStyle:style];
}

- (void)dye_updateBackgroundGradientForStyle:(DYEStyle *)style {
    
    DYELinearGradientLayer *backgroundGradient = self.dyeBackgroundGradientLayer;
    
    NSArray *backgroundGradientColors = style.backgroundGradientColors;
    NSArray *backgroundGradientPositions = style.backgroundGradientPositions;
    
    if ([backgroundGradientColors count] > 1 && [backgroundGradientColors count] == [backgroundGradientPositions count]) {
        BOOL layerExists = (backgroundGradient != nil);
        if (!layerExists) {
            backgroundGradient = [DYELinearGradientLayer layer];
        }
        
        backgroundGradient.anchorPoint = CGPointZero;
        backgroundGradient.frame = self.bounds;
        backgroundGradient.masksToBounds = YES;
        backgroundGradient.cornerRadius = style.cornerRadius + 0.05;
        backgroundGradient.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
        
        // Set gradient properties
        backgroundGradient.startPoint = style.backgroundGradientStartPoint;
        backgroundGradient.endPoint = style.backgroundGradientEndPoint;
        backgroundGradient.colors = backgroundGradientColors;
        backgroundGradient.locations = backgroundGradientPositions;
        
        // If the gradient layer doensn't exist yet, insert it, otherwise unhide it
        if (!layerExists) {
            [self.layer insertSublayer:backgroundGradient atIndex:0];
            self.dyeBackgroundGradientLayer = backgroundGradient;
        } else {
            backgroundGradient.hidden = NO;
        }
    } else {
        backgroundGradient.hidden = YES;
    }
}



#pragma mark Update Layout

- (id)dye_layout:(CGSize)oldSize {
    
    id view = [self dye_layout:oldSize];

    return view;
}

- (void)dye_setBounds:(CGRect)rect {
    
    [self dye_setBounds:rect];
}

@end
