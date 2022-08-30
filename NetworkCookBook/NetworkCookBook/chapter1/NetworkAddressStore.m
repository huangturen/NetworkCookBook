//
//  NetworkAddressStore.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/31.
//

#import "NetworkAddressStore.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>

#define INET6_ADDRSTRLEN 46
#define INET_ADDRSTRLEN 16

@implementation NetworkAddressStore

- (NSMutableArray *)networkInfos{
    struct ifaddrs *interfaces = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success != 0) {
        return nil;
    }
    
    struct ifaddrs *temp_addr = interfaces;
    while (temp_addr != NULL) {
        uint8_t ipversion;
        NSLog(@"******************************");
        if (temp_addr->ifa_addr->sa_family == AF_INET) {
            NSLog(@"IPv4");
            ipversion = AF_INET;
        }
        else if (temp_addr->ifa_addr->sa_family == AF_INET6){
            NSLog(@"IPv6");
            ipversion = AF_INET6;
        }
        else{
            NSLog(@"%@",@(temp_addr->ifa_addr->sa_family));
            ipversion = temp_addr->ifa_addr->sa_family;
        }
        char naddr[INET6_ADDRSTRLEN];
        char nmask[INET6_ADDRSTRLEN];
        char ngate[INET6_ADDRSTRLEN];

        NSLog(@"Name: %@", [NSString stringWithUTF8String:temp_addr->ifa_name]);
        inet_ntop(ipversion, &((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr, naddr,INET_ADDRSTRLEN);
        NSLog(@"Address: %@", [NSString stringWithUTF8String:naddr]);
        if ((struct sockaddr_in6 *)temp_addr->ifa_netmask != NULL) {
            inet_ntop(ipversion, &((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr, nmask, INET_ADDRSTRLEN);
            NSLog(@"NetMask: %@", [NSString stringWithUTF8String:nmask]);
        }
        
        if ((struct sockaddr_in6 *)temp_addr->ifa_dstaddr != NULL) {
            inet_ntop(ipversion, &((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr, ngate, INET_ADDRSTRLEN);
            NSLog(@"GateWay: %@", [NSString stringWithUTF8String:ngate]);
        }
        temp_addr = temp_addr->ifa_next;
    }
    freeifaddrs(interfaces);
    return nil;
    
}

@end
