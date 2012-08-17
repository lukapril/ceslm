//
//  NSString+Additions.h
//  Cardinal
//
//  Created by Cory Smith on 10-03-28.
//  Copyright 2010 Assn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5)

+ (NSString *) md5:(NSString *)str;

@end

@interface NSString (Assn)
- (NSString *)trim;
- (BOOL)isEmpty;
- (BOOL)startsWith:(NSString *)starting;
- (BOOL)endsWith:(NSString *)ending;
- (BOOL)contains:(NSString *)text;
- (NSString *)urlEncode;
- (NSString *)replace:(NSString *)find with:(NSString *)replacement;
- (NSString *)replaceAll:(NSArray *)keys with:(NSArray *)values;
- (BOOL)isValidEmail;
@end

