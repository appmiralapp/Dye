//
//  DYEColors+colorFromObjectPrivate.h
//  Dye
//
//  Created by David De Bels on 26/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEColors.h"



#pragma mark - DYEColors DYEPrivateHeader Category Interface -
/**
 A category defining private methods & properties for DYEColors.
 */
@interface DYEColors (DYEPrivateHeader)

+ (nullable DYEColor *)colorFromObject:(nonnull id)object;

@end
