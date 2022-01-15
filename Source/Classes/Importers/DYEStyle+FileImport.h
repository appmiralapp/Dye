//
//  DYEStyle+FileImport.h
//  Dye
//
//  Created by David De Bels on 24/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEStyle.h"



#pragma mark - DYEStyle FileImport Category Interface -

@interface DYEStyle (FileImport)

/**
 Import styles from a file and add them to the global DYEStyle cache. The URL can point to a local file in which case this method will be synchronous or to an online file in which case this method will be asynchronous.

 @param URL The URL to the file.
 @param fileFormat The format of the file, has to be supported by Dye.
 @param completionHandler Called when the styles have been added to the global DYEStyle cache. Returns the data of the file, returns an error if something went wrong.
 */
+ (void)importStylesFromURL:(nonnull NSURL *)URL fileFormat:(DYEFileFormat)fileFormat completionHandler:(nullable void (^)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;

/**
 Import styles from data and add them to the global DYEStyle cache. This method is synchronous.

 @param data The data.
 @param fileFormat The format of the data, has to be supported by Dye.
 @param completionHandler Called when the styles have been added to the global DYEStyle cache. Returns an error if something went wrong.
 */
+ (void)importStylesFromData:(nonnull NSData *)data fileFormat:(DYEFileFormat)fileFormat completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;

@end
