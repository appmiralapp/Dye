//
//  DYEStyle+DYEStyleablePrivate.h
//  Dye
//
//  Created by David De Bels on 20/07/16.
//  (c) 2016 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEStyle.h"



#pragma mark - DYEStyle DYEPrivateHeader Category Interface -
/**
 A category defining private methods & properties for DYEStyle.
 */
@interface DYEStyle (DYEPrivateHeader)

+ (void)addStyleable:(nonnull id<DYEStyleable>)styleableObject;

+ (void)removeStyleable:(nonnull id<DYEStyleable>)styleableObject;

@end
