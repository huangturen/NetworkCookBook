//
//  NetworkAddressStore.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/31.
//

#import "NetworkAddressStore.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

#define INET6_ADDRSTRLEN 46
#define INET_ADDRSTRLEN 16

@implementation AddressInfo

+ (AddressInfo *)addressInfoWithIpVersion:(uint8_t)ipversion
                                     name:(NSString *)name
                                  address:(NSString *)address
                                     mask:(NSString *)mask
                                  gateway:(NSString *)gateway{
    AddressInfo *info = [AddressInfo new];
    info.ipversion = ipversion;
    info.name = name;
    info.address = address;
    info.mask = mask;
    info.gateway = gateway;
    return info;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"ipversion:%@, name:%@, address:%@, mask:%@, gateway:%@", self.ipversion == AF_INET? @"iPv4" : self.ipversion == AF_INET6? @"iPv6" : @(self.ipversion), self.name, self.address, self.mask, self.gateway];
}

@end

@implementation NetworkAddressStore

- (NSMutableArray<AddressInfo *> *)networkInfos{
    struct ifaddrs *interfaces = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success != 0) {
        return nil;
    }
    
    struct ifaddrs *temp_addr = interfaces;
    NSMutableArray<AddressInfo *> *addressInfos = [NSMutableArray array];
    while (temp_addr != NULL) {
        uint8_t ipversion;
        if (temp_addr->ifa_addr->sa_family == AF_INET) {
            ipversion = AF_INET;
        }
        else if (temp_addr->ifa_addr->sa_family == AF_INET6){
            ipversion = AF_INET6;
        }
        else{
            ipversion = temp_addr->ifa_addr->sa_family;
        }
        char naddr[INET6_ADDRSTRLEN];
        char nmask[INET6_ADDRSTRLEN];
        char ngate[INET6_ADDRSTRLEN];

        inet_ntop(ipversion, &((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr, naddr,INET_ADDRSTRLEN);
        if ((struct sockaddr_in6 *)temp_addr->ifa_netmask != NULL) {
            inet_ntop(ipversion, &((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr, nmask, INET_ADDRSTRLEN);
        }
        
        if ((struct sockaddr_in6 *)temp_addr->ifa_dstaddr != NULL) {
            inet_ntop(ipversion, &((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr, ngate, INET_ADDRSTRLEN);
        }
        
        AddressInfo *info = [AddressInfo addressInfoWithIpVersion:ipversion
                                                             name:[NSString stringWithUTF8String:temp_addr->ifa_name]
                                                             address:[NSString stringWithUTF8String:naddr]
                                                             mask:[NSString stringWithUTF8String:nmask]
                                                          gateway:[NSString stringWithUTF8String:ngate]];
        
        [addressInfos addObject:info];
        temp_addr = temp_addr->ifa_next;
    }
    freeifaddrs(interfaces);
    return [addressInfos copy];
    
}

@end
