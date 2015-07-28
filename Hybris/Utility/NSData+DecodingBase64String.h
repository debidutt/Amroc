//
//  NSData+DecodingBase64String.h
//  Hybris
//
//  Created by TCS INFINITI on 30/06/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DecodingBase64String)

-(NSData *)base64DataFromString: (NSString *)string;

@end
