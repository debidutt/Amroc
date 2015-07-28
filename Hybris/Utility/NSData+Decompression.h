//
//  NSData+Decompression.h
//  Hybris
//
//  Created by TCS INFINITI on 30/06/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Decompression)

// gzip compression utilities
- (NSData *)gzipInflate: (NSData*) nsData;
- (NSData *)zlibInflate: (NSData*) nsData;
- (NSData *)gzipDeflate: (NSData*) nsData;
- (NSData *)base64DataFromString: (NSString *)string;

@end
