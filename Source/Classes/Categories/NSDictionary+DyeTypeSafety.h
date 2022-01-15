//
//  NSDictionary+DyeTypeSafety.h
//  Dye
//
//  Created by David De Bels on 28/08/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Foundation/Foundation.h>



#pragma mark - NSDictionary DyeTypeSafety Category Interface -

@interface NSDictionary (DyeTypeSafety)

- (nullable NSString *)dye_stringForKeyOrNil:(nonnull id<NSCopying>)aKey;

- (nullable NSNumber *)dye_numberForKeyOrNil:(nonnull id<NSCopying>)aKey;

- (nullable NSArray *)dye_arrayForKeyOrNil:(nonnull id<NSCopying>)aKey;

- (nullable NSDictionary *)dye_dictionaryForKeyOrNil:(nonnull id<NSCopying>)aKey;

@end

