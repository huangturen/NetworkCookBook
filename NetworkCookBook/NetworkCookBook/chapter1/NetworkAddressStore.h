//
//  NetworkAddressStore.h
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/31.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfo : NSObject

@property(nonatomic, assign)uint8_t ipversion;
@property(nonatomic, copy)NSString  *name;
@property(nonatomic, copy)NSString  *mask;
@property(nonatomic, copy)NSString  *gateway;
@property(nonatomic, copy)NSString  *address;

+ (AddressInfo *)addressInfoWithIpVersion:(uint8_t)ipversion
                                     name:(NSString *)name
                                  address:(NSString *)address
                                     mask:(NSString *)mask
                                  gateway:(NSString *)gateway;
@end

@interface NetworkAddressStore : NSObject

- (NSMutableArray<AddressInfo *> *)networkInfos;

@end

NS_ASSUME_NONNULL_END
