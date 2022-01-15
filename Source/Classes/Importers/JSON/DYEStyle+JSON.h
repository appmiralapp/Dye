//
//  DYEStyle+JSON.h
//  Dye
//
//  Created by David De Bels on 01/03/15.
//  (c) 2015 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEStyle.h"



#pragma mark - DYEStyle JSON Category -
/**
 The JSON category allows creating a DYEStyle object from a JSON type dictionary.
 */
@interface DYEStyle (JSON)

#pragma mark Manage the Styles Cache
/**---------------------------------------------------------------------------------------
 * @name Manage the Styles Cache
 *  ---------------------------------------------------------------------------------------
 */

+ (nullable DYEStyle *)addStyleFromJSONDictionary:(nonnull NSDictionary *)dictionary;

+ (void)addStylesFromJSONArray:(nonnull NSArray<NSDictionary *> *)array;



#pragma mark Initialize Styles
/**---------------------------------------------------------------------------------------
 * @name Initialize Styles
 *  ---------------------------------------------------------------------------------------
 */

- (nullable instancetype)initWithJSONDictionary:(nonnull NSDictionary *)dictionary;



#pragma mark JSON Representation
/**---------------------------------------------------------------------------------------
 * @name JSON Representation
 *  ---------------------------------------------------------------------------------------
 */

@property (nonatomic, copy, readonly, nonnull) NSDictionary *JSONDictionaryRepresentation;

@property (nonatomic, copy, readonly, nonnull) NSString *JSONStringRepresentation;

@end

