//
//  DYEColors+JSON.m
//  Dye
//
//  Created by David De Bels on 03/12/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEColors+JSON.h"

#import "NSDictionary+DyeTypeSafety.h"



#pragma mark - DYEColors JSON Category -

@implementation DYEColors (JSON)

+ (DYEColor *)addColorFromJSONDictionary:(NSDictionary *)dictionary {
    NSString *colorName = [dictionary dye_stringForKeyOrNil:@"name"];
    NSDictionary *valueDict = [dictionary dye_dictionaryForKeyOrNil:@"value"];
    DYEColor *color = nil;

    if (colorName && valueDict) {
        color = [DYEColors colorFromDictionary:valueDict];
        if (color) {
            [DYEColors addColor:color withName:colorName];
        }
    }

    return color;
}

+ (void)addColorsFromJSONArray:(NSArray<NSDictionary *> *)array {
    for (NSDictionary *dictionary in array) {
        [self addColorFromJSONDictionary:dictionary];
    }
}

@end



#pragma mark - DYEColor JSON Category Implementation -

@implementation DYEColor (JSON)

- (NSDictionary *)JSONDictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    dictionary[@"name"] = self.dyeColorName ? : NSNull.null;
    
    // TODO: @david support other color formats
    CGFloat r, g, b, a;
    CGFloat *components = (CGFloat *)CGColorGetComponents(self.CGColor);
    NSInteger numComponents = CGColorGetNumberOfComponents(self.CGColor);
    
    if (numComponents == 2) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    } else {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }

    dictionary[@"value"] = @{ @"r": @((NSInteger)(r * 255)), @"g": @((NSInteger)(g * 255)), @"b": @((NSInteger)(b * 255)) };
    dictionary[@"alpha"] = @(a);

    return dictionary;
}

- (NSString *)JSONStringRepresentation {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.JSONDictionaryRepresentation options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end

