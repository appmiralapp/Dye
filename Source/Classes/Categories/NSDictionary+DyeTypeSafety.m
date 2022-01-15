//
//  NSDictionary+DyeTypeSafety.m
//  Dye
//
//  Created by David De Bels on 28/08/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "NSDictionary+DyeTypeSafety.h"



#pragma mark - NSDictionary DyeTypeSafety Category Implementation -

@implementation NSDictionary (DyeTypeSafety)

- (NSString *)dye_stringForKeyOrNil:(id<NSCopying>)aKey {
    
    id object = [self objectForKey:aKey];
    return [object isKindOfClass:[NSString class]] ? (NSString *)object : nil;
}

- (NSNumber *)dye_numberForKeyOrNil:(id<NSCopying>)aKey {
    
    id object = [self objectForKey:aKey];
    return [object isKindOfClass:[NSNumber class]] ? (NSNumber *)object : nil;
}

- (NSArray *)dye_arrayForKeyOrNil:(id<NSCopying>)aKey {
    
    id object = [self objectForKey:aKey];
    return [object isKindOfClass:[NSArray class]] ? (NSArray *)object : nil;
}

- (NSDictionary *)dye_dictionaryForKeyOrNil:(id<NSCopying>)aKey {
    
    id object = [self objectForKey:aKey];
    return [object isKindOfClass:[NSDictionary class]] ? (NSDictionary *)object : nil;
}

@end

