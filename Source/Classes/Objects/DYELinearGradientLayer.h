//
//  DYELinearGradientLayer.h
//  Dye
//
//  Created by David De Bels on 27/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <QuartzCore/QuartzCore.h>

#import "DYEConstants.h"



#pragma mark - DYELinearGradientLayer Interface -

@interface DYELinearGradientLayer : CALayer

@property (nonatomic, assign, readwrite) CGPoint startPoint;
@property (nonatomic, assign, readwrite) CGPoint endPoint;

@property (nonatomic, strong, readwrite, nullable) NSArray<DYEColor *> *colors;
@property (nonatomic, strong, readwrite, nullable) NSArray<NSNumber *> *locations;

@end
