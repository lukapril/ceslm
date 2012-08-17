//
//  NSString+Additions.m
//  Cardinal
//
//  Created by Cory Smith on 10-03-28.
//  Copyright 2010 Assn. All rights reserved.
//

#import "NSString+Additions.h"


#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

+ (NSString *) md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}

@end

@implementation NSString (Assn)

- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty {
	return [[self trim] isEqualToString:@""];
}

- (BOOL)endsWith:(NSString *)ending {
	
	int indexToCheck = [self length] - [ending length];
	
	if(indexToCheck >= 0)
		return [[self substringFromIndex:indexToCheck] isEqualToString:ending];
	
	return NO;
}

- (BOOL)startsWith:(NSString *)starting {
	if([starting isEmpty] || [starting length] > self.length)
		return NO;
	
	return [[self substringToIndex:[starting length]] isEqualToString:starting];
}

- (NSString *)replace:(NSString *)find with:(NSString *)replacement {
	return [self stringByReplacingOccurrencesOfString:find withString:replacement];
}


- (NSString *)replaceAll:(NSArray *)keys with:(NSArray *)values {
    
    NSMutableString *s = [NSMutableString stringWithString:self];
    
    for (int i = 0; i < keys.count; i++) {
        [s replaceOccurrencesOfString:[keys objectAtIndex:i] 
                           withString:[values objectAtIndex:i]
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [s length])];
    }
    
    return s;
}

- (BOOL)isValidEmail {
    NSString *emailRegEx = @"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?";
    NSPredicate *regExPredicate =
            [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:self];

}


- (BOOL)contains:(NSString *)text {
	NSRange range = [[self lowercaseString] rangeOfString:[text lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString *)urlEncode
{
	NSString *result = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return result;
}

@end
