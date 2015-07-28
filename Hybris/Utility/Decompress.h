//
//  Decompress.h
//  Hybris
//
//  Created by TCS INFINITI on 30/06/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Decompress (DDData)

// gzip compression utilities
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;

@end
