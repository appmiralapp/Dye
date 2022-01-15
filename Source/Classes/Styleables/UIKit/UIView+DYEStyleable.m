//
//  UIView+DYEStyleable.m
//  Dye
//
//  Created by David De Bels on 21/02/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "UIView+DYEStyleable.h"

#import "DYELinearGradientLayer.h"
#import "UIView+DYEPrivateHeader.h"
#import "DYEStyle+DYEPrivateHeader.h"

static void *kDYEStyleNamePropertyKey = &kDYEStyleNamePropertyKey;
static void *kDYEStyleFocusedNamePropertyKey = &kDYEStyleFocusedNamePropertyKey;
static void *kDYEBackgroundGradientPropertyKey = &kDYEBackgroundGradientPropertyKey;

static NSString * const DYEAnimationKey = @"dye.animation";



#pragma mark - UIView DYEStyleable Category Implementation -

@implementation UIView (DYEStyleable)

#pragma mark Load Class

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self dye_extendsLayoutSubviews];
        [self dye_extendsSetBounds];
        [self dye_extendsDidUpdateFocusInContextWithAnimationCoordinator];
    });
}



#pragma mark Method Swizzling

+ (void)dye_extendsLayoutSubviews {
    SEL layoutSubviewsSEL = @selector(layoutSubviews);
    Method layoutSubviewsMethod = class_getInstanceMethod(self, layoutSubviewsSEL);
    
    SEL dye_layoutSubviewsSEL = @selector(dye_layoutSubviews);
    Method dye_layoutSubviewsMethod = class_getInstanceMethod(self, dye_layoutSubviewsSEL);
    
    method_exchangeImplementations(layoutSubviewsMethod, dye_layoutSubviewsMethod);
}

+ (void)dye_extendsSetBounds {
    SEL setBoundsSEL = @selector(setBounds:);
    Method setBoundsMethod = class_getInstanceMethod(self, setBoundsSEL);
    
    SEL dye_setBoundsSEL = @selector(dye_setBounds:);
    Method dye_setBoundsMethod = class_getInstanceMethod(self, dye_setBoundsSEL);
    
    method_exchangeImplementations(setBoundsMethod, dye_setBoundsMethod);
}

+ (void)dye_extendsDidUpdateFocusInContextWithAnimationCoordinator {
    if ([self instancesRespondToSelector:@selector(didUpdateFocusInContext:withAnimationCoordinator:)]) {
        SEL didUpdateFocusSEL = @selector(didUpdateFocusInContext:withAnimationCoordinator:);
        Method didUpdateFocusMethod = class_getInstanceMethod(self, didUpdateFocusSEL);
        
        SEL dye_didUpdateFocusSEL = @selector(dye_didUpdateFocusInContext:withAnimationCoordinator:);
        Method dye_didUpdateFocusMethod = class_getInstanceMethod(self, dye_didUpdateFocusSEL);
        
        method_exchangeImplementations(didUpdateFocusMethod, dye_didUpdateFocusMethod);
    }
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
    } else {
        [self.dyeBackgroundGradientLayer removeFromSuperlayer];
        self.dyeBackgroundGradientLayer = nil;
    }
}

- (NSString *)dyeFocusedStyleName {
    NSString *dyeStyleName = objc_getAssociatedObject(self, kDYEStyleFocusedNamePropertyKey);
    return dyeStyleName;
}

- (void)setDyeFocusedStyleName:(NSString *)dyeFocusedStyleName {
    // Temporarily remove self as a styleable to avoid any auto updates
    [DYEStyle removeStyleable:self];
    
    // Set the style name and update styling
    objc_setAssociatedObject(self, kDYEStyleFocusedNamePropertyKey, dyeFocusedStyleName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self dye_updateStyling];
    
    // Add to styleables if required
    if (dyeFocusedStyleName) {
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

- (BOOL)dye_isFocused {
    BOOL isFocused = NO;
    if ([self respondsToSelector:@selector(isFocused)]) {
        isFocused = [self isFocused];
    }
    
    return isFocused;
}

- (CGRect)dye_backgroundShadowBoundsForStyle:(DYEStyle *)style {
    CGRect shadowBounds = self.bounds;
    shadowBounds.origin.x -= style.backgroundShadowSpread;
    shadowBounds.origin.y -= style.backgroundShadowSpread;
    shadowBounds.size.width += style.backgroundShadowSpread * 2;
    shadowBounds.size.height += style.backgroundShadowSpread * 2;
    return shadowBounds;
}



#pragma mark Update Styling

- (void)dye_updateStyling {
    NSString *styleName = [self dye_isFocused] ? self.dyeFocusedStyleName : self.dyeStyleName;
    DYEStyle *style = [DYEStyle styleNamed:styleName];
    
    [self dye_updateViewForStyle:style];
}

- (void)dye_updateViewForStyle:(DYEStyle *)style {
    if (style) {
        // Background
        self.backgroundColor = style.backgroundColor;
        
        // Tint
        self.tintColor = style.tintColor;
        
        // Corners
        self.layer.cornerRadius = style.cornerRadius;
        self.dyeBackgroundGradientLayer.cornerRadius = style.cornerRadius + 0.05;
        
        // Border
        self.layer.borderWidth = style.borderWidth;
        self.layer.borderColor = [style.borderColor CGColor];
        
        // Apply background shadow
        if (style.backgroundShadowColor && (!CGSizeEqualToSize(style.backgroundShadowOffset, CGSizeZero) || style.backgroundShadowRadius > 0) && ![style.backgroundShadowColor isEqual:[UIColor clearColor]]) {
            self.layer.shadowRadius = style.backgroundShadowRadius;
            self.layer.shadowOffset = style.backgroundShadowOffset;
            self.layer.shadowOpacity = 1;
            self.layer.shadowColor = [style.backgroundShadowColor CGColor];
            self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self dye_backgroundShadowBoundsForStyle:style] cornerRadius:style.cornerRadius] CGPath];
        } else {
            self.layer.shadowRadius = 3;
            self.layer.shadowOffset = CGSizeMake(0, -3);
            self.layer.shadowOpacity = 0;
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowPath = nil;
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
        self.transform = transform;
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
        backgroundGradient.zPosition = -10;
        
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
            [backgroundGradient setNeedsDisplay];
        }
    } else {
        backgroundGradient.hidden = YES;
    }
}



#pragma mark Update Layout

- (void)dye_layoutSubviews {
    [self dye_layoutSubviews];
    [self dye_updateBackgroundGradientAndShadowPathIfNeeded];
}

- (void)dye_setBounds:(CGRect)rect {
    [self dye_setBounds:rect];
    [self dye_updateBackgroundGradientAndShadowPathIfNeeded];
}

- (void)dye_updateBackgroundGradientAndShadowPathIfNeeded {
    DYEStyle *style = [DYEStyle styleNamed:self.dyeStyleName];
    if (style) {
        DYELinearGradientLayer *backgroundGradientLayer = self.dyeBackgroundGradientLayer;
        
        // Only do this if we have a background gradient or a shadow path
        if (backgroundGradientLayer != nil || self.layer.shadowPath != NULL) {
            // Check if we have a size or position change animation
            CABasicAnimation *layerAnimation = nil;
            for (NSString *animationKey in [self.layer animationKeys]) {
                if ([animationKey isEqualToString:@"position"] || [animationKey isEqualToString:@"bounds.origin"] || [animationKey isEqualToString:@"bounds.size"]) {
                    layerAnimation = (CABasicAnimation *)[self.layer animationForKey:animationKey];
                    break;
                }
            }
            
            [CATransaction begin];
            
            if (layerAnimation) {
                // Background gradient animation
                DYELinearGradientLayer *backgroundGradientLayer = self.dyeBackgroundGradientLayer;
                if (backgroundGradientLayer) {
                    // Set the new value
                    backgroundGradientLayer.bounds = self.layer.bounds;
                    
                    // Create the animation
                    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
                    boundsAnimation.timingFunction = layerAnimation.timingFunction;
                    boundsAnimation.duration = layerAnimation.duration;
                    boundsAnimation.fromValue = [NSValue valueWithCGRect:backgroundGradientLayer.presentationLayer.bounds];
                    boundsAnimation.toValue = [NSValue valueWithCGRect:self.layer.bounds];
                    
                    // Add the animation to the layer
                    [backgroundGradientLayer addAnimation:boundsAnimation forKey:@"bounds"];
                }
                
                // Shadow path animation
                if (self.layer.shadowPath != NULL) {
                    // Check if there is already a shadow path animation in progress started by Dye
                    CAAnimation *existingAnimation = [self.layer animationForKey:@"shadowPath"];
                    CABasicAnimation *shadowPathAnimation = ([existingAnimation isKindOfClass:[CABasicAnimation class]] && [[existingAnimation valueForKey:DYEAnimationKey] boolValue]) ? (CABasicAnimation *)existingAnimation : nil;
                    
                    // Only continue if there is no shadow path animation or the existing one was started by Dye, we don't want to override an animation created by the developer
                    if (!existingAnimation || shadowPathAnimation) {
                        
                        // Set the new value
                        UIBezierPath *newBezierPath = [UIBezierPath bezierPathWithRoundedRect:[self dye_backgroundShadowBoundsForStyle:style] cornerRadius:style.cornerRadius];
                        self.layer.shadowPath = (CGPathRef)newBezierPath.CGPath;
                        
                        // Create the animation
                        shadowPathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
                        shadowPathAnimation.timingFunction = layerAnimation.timingFunction;
                        shadowPathAnimation.duration = layerAnimation.duration;
                        shadowPathAnimation.fromValue = (id)self.layer.presentationLayer.shadowPath;
                        shadowPathAnimation.toValue = (id)newBezierPath.CGPath;
                        
                        // Indicate that the animation was started by Dye and add it to the layer
                        [shadowPathAnimation setValue:@YES forKey:DYEAnimationKey];
                        [self.layer addAnimation:shadowPathAnimation forKey:@"shadowPath"];
                    }
                }
            } else {
                // Not animating, disable implicit animations
                [CATransaction disableActions];
                
                // Set the correct position & bounds for the background gradient
                if (backgroundGradientLayer) {
                    backgroundGradientLayer.position = CGPointZero;
                    backgroundGradientLayer.bounds = self.bounds;
                }
                
                // Set the correct shadow path
                if (self.layer.shadowPath != NULL) {
                    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self dye_backgroundShadowBoundsForStyle:style] cornerRadius:style.cornerRadius] CGPath];
                }
            }
            
            [CATransaction commit];
        }
    }
}



#pragma mark Update Focus

- (void)dye_didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    // Call super
    [self dye_didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    
    // View changed focus state, update styling
    if (([context.previouslyFocusedView isEqual:self] && ![context.nextFocusedView isEqual:self]) || (![context.previouslyFocusedView isEqual:self] && [context.nextFocusedView isEqual:self])) {
        [coordinator addCoordinatedAnimations:^{
            
            [self dye_updateStyling];
            
        } completion:nil];
    }
}

@end
