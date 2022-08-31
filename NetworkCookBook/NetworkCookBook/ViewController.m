//
//  ViewController.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/30.
//

#import "ViewController.h"
#import "ByteOrder.h"
#import "NetworkAddressStore.h"
#import "AddrInfo.h"
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    EndianType type = [ByteOrder byteOrder];
//    NSLog(@"%@",@(type));
//
//    NetworkAddressStore *networkAddressStore = [NetworkAddressStore new];
//    NSLog(@"%@",[networkAddressStore networkInfos]);
    
    struct addrinfo *res;
    struct addrinfo hints;
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_DGRAM;
    
    AddrInfo *ai = [AddrInfo new];
    [ai addrWithHostname:@"www.baidu.com" Service:@"443" andHints:&hints];
    if (ai.errorCode != 0) {
        NSLog(@"Error in getaddrinfo():%@", [ai errorString]);
    }
    
    struct addrinfo *results = ai.results;
    for (res = results; res!=NULL; res = res->ai_next) {
        void *addr;
        NSString *ipver = @"";
        char ipstr[INET6_ADDRSTRLEN];
        if (res->ai_family == AF_INET) {
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)res->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = @"IPv4";
        }
        else if (res->ai_family == AF_INET6){
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)res->ai_addr;
            addr = &(ipv6->sin6_addr);
            ipver = @"IPv4";
        }
        else{
            continue;
        }
        
        inet_ntop(res->ai_family, addr, ipstr, sizeof(ipstr));
        NSLog(@"%@ %s", ipver, ipstr);
        
        AddrInfo *ai2 = [AddrInfo new];
        [ai2 nameWithSockaddr:res->ai_addr];
        if (ai2.errorCode == 0) {
            NSLog(@"--%@ %@", ai2.hostname, ai2.service);
        }
        freeaddrinfo(results);
    }
}


@end
