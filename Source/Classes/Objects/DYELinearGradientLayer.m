//
//  DYELinearGradientLayer.m
//  Dye-iOS
//
//  Created by David De Bels on 27/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYELinearGradientLayer.h"



#pragma mark - DYELinearGradientLayer Implementation -

@implementation DYELinearGradientLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.needsDisplayOnBoundsChange = YES;
        self.masksToBounds = YES;
    }
    
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGPoint start = CGPointMake(self.startPoint.x * self.bounds.size.width, self.startPoint.y * self.bounds.size.height);
    CGPoint end = CGPointMake(self.endPoint.x * self.bounds.size.width, self.endPoint.y * self.bounds.size.height);
    
    NSMutableArray *colors = [NSMutableArray new];
    for (DYEColor *color in self.colors) {
        [colors addObject:(id)color.CGColor];
    }
    
    CGFloat locations[self.locations.count];
    for (NSInteger i = 0; i < self.locations.count; i++) {
        locations[i] = self.locations[i].floatValue;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
    CGContextDrawLinearGradient(ctx, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
}

@end
