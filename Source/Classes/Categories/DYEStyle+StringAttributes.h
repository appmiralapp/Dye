//
//  DYEStyle+StringAttributes.h
//  Dye
//
//  Created by David De Bels on 17/09/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <Foundation/Foundation.h>

#import "DYEStyle.h"



#pragma mark - DYEStyle StringAttributes Category Interface -

@interface DYEStyle (StringAttributes)

@property (nonatomic, copy, readonly, nonnull) NSDictionary<NSAttributedStringKey, id> *stringAttributes;

@end
