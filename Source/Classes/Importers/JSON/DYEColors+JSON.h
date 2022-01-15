//
//  DYEColors+JSON.h
//  Dye
//
//  Created by David De Bels on 03/12/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEColors.h"



#pragma mark - DYEColors JSON Category Interface -
/**
 The JSON category allows creating a DYEColor object from a JSON type dictionary.
 */
@interface DYEColors (JSON)

+ (nullable DYEColor *)addColorFromJSONDictionary:(nonnull NSDictionary *)dictionary;

+ (void)addColorsFromJSONArray:(nonnull NSArray<NSDictionary *> *)array;

@end



#pragma mark - DYEColor JSON Category Interface -

@interface DYEColor (JSON)

@property (nonatomic, copy, readonly, nonnull) NSDictionary *JSONDictionaryRepresentation;

@property (nonatomic, copy, readonly, nonnull) NSString *JSONStringRepresentation;

@end

