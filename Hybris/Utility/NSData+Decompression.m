//
//  NSData+Decompression.m
//  Hybris
//
//  Created by TCS INFINITI on 30/06/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "NSData+Decompression.h"
#import "zlib.h"

@implementation NSData (Decompression)


- (NSData *) gzipInflate : (NSData*) nsData
{
    z_stream strm;
    
    // Initialize input
    strm.next_in = (Bytef *)[nsData bytes];
    NSUInteger left = [nsData length];        // input left to decompress
    if (left == 0)
        return nil;                         // incomplete gzip stream
    
    // Create starting space for output (guess double the input size, will grow
    // if needed -- in an extreme case, could end up needing more than 1000
    // times the input size)
    NSUInteger space = left << 1;
    if (space < left)
        space = NSUIntegerMax;
    NSMutableData *decompressed = [NSMutableData dataWithLength: space];
    space = [decompressed length];
    
    // Initialize output
    strm.next_out = (Bytef *)[decompressed mutableBytes];
    NSUInteger have = 0;                    // output generated so far
    
    // Set up for gzip decoding
    strm.avail_in = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    int status = inflateInit2(&strm, (15+16));
    if (status != Z_OK)
        return nil;                         // out of memory
    
    // Decompress all of self
    do {
        // Allow for concatenated gzip streams (per RFC 1952)
        if (status == Z_STREAM_END)
            (void)inflateReset(&strm);
        
        // Provide input for inflate
        if (strm.avail_in == 0) {
            strm.avail_in = left > UINT_MAX ? UINT_MAX : (unsigned)left;
            left -= strm.avail_in;
        }
        
        // Decompress the available input
        do {
            // Allocate more output space if none left
            if (space == have) {
                // Double space, handle overflow
                space <<= 1;
                if (space < have) {
                    space = NSUIntegerMax;
                    if (space == have) {
                        // space was already maxed out!
                        (void)inflateEnd(&strm);
                        return nil;         // output exceeds integer size
                    }
                }
                
                // Increase space
                [decompressed setLength: space];
                space = [decompressed length];
                
                // Update output pointer (might have moved)
                strm.next_out = (Bytef *)[decompressed mutableBytes] + have;
            }
            
            // Provide output space for inflate
            strm.avail_out = space - have > UINT_MAX ? UINT_MAX :
            (unsigned)(space - have);
            have += strm.avail_out;
            
            // Inflate and update the decompressed size
            status = inflate (&strm, Z_SYNC_FLUSH);
            have -= strm.avail_out;
            
            // Bail out if any errors
            if (status != Z_OK && status != Z_BUF_ERROR &&
                status != Z_STREAM_END) {
                (void)inflateEnd(&strm);
                return nil;                 // invalid gzip stream
            }
            
            // Repeat until all output is generated from provided input (note
            // that even if strm.avail_in is zero, there may still be pending
            // output -- we're not done until the output buffer isn't filled)
        } while (strm.avail_out == 0);
        
        // Continue until all input consumed
    } while (left || strm.avail_in);
    
    // Free the memory allocated by inflateInit2()
    (void)inflateEnd(&strm);
    
    // Verify that the input is a valid gzip stream
//    if (status != Z_STREAM_END)
//        return nil;                         // incomplete gzip stream
    
    // Set the actual length and return the decompressed data
    [decompressed setLength: have];
    return decompressed;
}
- (NSData *)zlibInflate:(NSData*)nsData
{
    if ([nsData length] == 0) return nsData;
    
    unsigned full_length = [nsData length];
    unsigned half_length = [nsData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[nsData bytes];
    strm.avail_in = [nsData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit (&strm) != Z_OK) return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
//        if ((status == Z_STREAM_END) || (status == Z_BUF_ERROR))
            done = YES;
//        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}




//- (NSData *)gzipInflate: (NSData*) nsData
//{
//
//    
//    if ([nsData length] == 0) return nsData;
//    
//    unsigned full_length = [nsData length];
//    unsigned half_length = [nsData length] / 2;
//    
//    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
//    BOOL done = NO;
//    int status;
//    
//    z_stream strm;
//    strm.next_in = (Bytef *)[nsData bytes];
//    strm.avail_in = [nsData length];
//    strm.total_out = 0;
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    
//    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
//    while (!done)
//    {
//        // Make sure we have enough room and reset the lengths.
//        if (strm.total_out >= [decompressed length])
//        [decompressed increaseLengthBy: half_length];
//        strm.next_out = [decompressed mutableBytes] + strm.total_out;
//        strm.avail_out = [decompressed length] - strm.total_out;
//        
//        // Inflate another chunk.
//        status = inflate (&strm, Z_SYNC_FLUSH);
//        if (status == Z_STREAM_END) done = YES;
//        else if (status != Z_OK) break;
//    }
//    if (inflateEnd (&strm) != Z_OK) return nil;
//    
// 
//    
//    // Set real length.
//    if (done)
//    {
//        [decompressed setLength: strm.total_out];
//        return [NSData dataWithData: decompressed];
//    }
//    else return nil;
//}

- (NSData *)gzipDeflate:(NSData *) nsData
{
    if ([nsData length] == 0) return nsData;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[nsData bytes];
    strm.avail_in = [nsData length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
        [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;
        
        deflate(&strm, Z_FINISH);  
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

-(NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

@end
