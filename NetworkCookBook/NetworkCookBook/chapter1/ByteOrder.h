//
//  EndianType.h
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ENDIAN_UNKNOWN,
    ENDIAN_LITTLE,
    ENDIAN_BIG,
} EndianType;

@interface ByteOrder : NSObject

+ (EndianType)byteOrder;

@end

NS_ASSUME_NONNULL_END
