//
//  DYEColors+FileImport.m
//  Dye
//
//  Created by David De Bels on 24/02/2018.
//  (c) 2018 November Five BVBA
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import "DYEColors+FileImport.h"

#import "DYEConstants.h"
#import "DYEColors+JSON.h"



#pragma mark - DYEColors FileImport Category Implementation -

@implementation DYEColors (FileImport)

+ (void)importColorsFromURL:(NSURL *)URL fileFormat:(DYEFileFormat)fileFormat completionHandler:(void (^)(NSData *data, NSError *error))completionHandler {
    if (URL.isFileURL || URL.scheme == nil) {
        NSData *data = [NSData dataWithContentsOfURL:URL];
        if (!data && completionHandler) {
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
            completionHandler(nil, error);
        } else {
            [self importColorsFromData:data fileFormat:fileFormat completionHandler:^(NSError * _Nullable error) {
                if (completionHandler) {
                    completionHandler(data, error);
                }
            }];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error && completionHandler) {
                completionHandler(nil, error);
            } else {
                [weakSelf importColorsFromData:data fileFormat:fileFormat completionHandler:^(NSError * _Nullable error) {
                    if (completionHandler) {
                        completionHandler(data, error);
                    }
                }];
            }
        }] resume];
    }
}

+ (void)importColorsFromData:(NSData *)data fileFormat:(DYEFileFormat)fileFormat completionHandler:(void (^)(NSError *error))completionHandler {
    NSError *error = nil;
    
    if (fileFormat == DYEFileFormatJSON) {
        id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            if ([JSONObject isKindOfClass:[NSDictionary class]]) {
                [DYEColors addColorFromJSONDictionary:(NSDictionary *)JSONObject];
            } else if ([JSONObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dictionary in (NSArray *)JSONObject) {
                    if ([dictionary isKindOfClass:[NSDictionary class]]) {
                        [DYEColors addColorFromJSONDictionary:dictionary];
                    }
                }
            }
        }
    }
    
    if (completionHandler) {
        completionHandler(error);
    }
}

@end
