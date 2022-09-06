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
#import <objc/message.h>
#import "BSDSocketServer.h"
#import "BSDSocketClient.h"
#import "CFNetworkUtilities.h"

@interface ViewController ()

@property(nonatomic)UIImageView *imageView;

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
    
//    struct addrinfo *res;
//    struct addrinfo hints;
//
//    memset(&hints, 0, sizeof(hints));
//    hints.ai_family = AF_UNSPEC;
//    hints.ai_socktype = SOCK_DGRAM;
//
//    AddrInfo *ai = [AddrInfo new];
//    [ai addrWithHostname:@"www.baidu.com" Service:@"443" andHints:&hints];
//    if (ai.errorCode != 0) {
//        NSLog(@"Error in getaddrinfo():%@", [ai errorString]);
//    }
//
//    struct addrinfo *results = ai.results;
//    for (res = results; res!=NULL; res = res->ai_next) {
//        void *addr;
//        NSString *ipver = @"";
//        char ipstr[INET6_ADDRSTRLEN];
//        if (res->ai_family == AF_INET) {
//            struct sockaddr_in *ipv4 = (struct sockaddr_in *)res->ai_addr;
//            addr = &(ipv4->sin_addr);
//            ipver = @"IPv4";
//        }
//        else if (res->ai_family == AF_INET6){
//            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)res->ai_addr;
//            addr = &(ipv6->sin6_addr);
//            ipver = @"IPv4";
//        }
//        else{
//            continue;
//        }
//
//        inet_ntop(res->ai_family, addr, ipstr, sizeof(ipstr));
//        NSLog(@"%@ %s", ipver, ipstr);
//
//        AddrInfo *ai2 = [AddrInfo new];
//        [ai2 nameWithSockaddr:res->ai_addr];
//        if (ai2.errorCode == 0) {
//            NSLog(@"--%@ %@", ai2.hostname, ai2.service);
//        }
//        freeaddrinfo(results);
//    }
    
//    + (NSHTTPCookie *)_cookieForSetCookieString:(NSString *)setCookieString forURL:(NSURL *)aURL partition:(NSString *) partition;
    
//    id (*cookieConstruct)(id, SEL, NSString *, NSURL *, NSString *) = (id (*)(id, SEL, NSString *,NSURL *,NSString *))objc_msgSend;
//    NSHTTPCookie *ck = cookieConstruct([NSHTTPCookie class], @selector(_cookieForSetCookieString:forURL:partition:), @"a=b", [NSURL URLWithString:@"https://www.baidu.com"], nil);
    
//    BSDSocketServer *bsdServ = [[BSDSocketServer alloc] initOnPort:2004];
//    if (bsdServ.errorCode == NOERROR) {
//        [bsdServ echoServerListenWithDescriptor:bsdServ.listenfd];
//    }
//    else{
//        NSLog(@"%@", [NSString stringWithFormat:@"Error code %d recieved. Server was not started", bsdServ.errorCode]);
//    }
    
//    [self startClient];
//    [self startServer];
    
    CFNetworkUtilities *utils = [CFNetworkUtilities new];
    NSArray *addArray = [utils addressesForHostname:@"www.baidu.com"];
    NSLog(@"%@",addArray);
    NSArray *hostArray = [utils hostnamesForAddress:@"36.152.44.96"];
    NSLog(@"%@",hostArray);
}

- (void)startClient {
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"image"]);
    
    
    BSDSocketClient *bsdClient = [[BSDSocketClient alloc] initWithAddress:@"127.0.0.1" andPort:2006];
    if (bsdClient.errorCode == NOERROR) {
        [bsdClient sendData:data toSocket:bsdClient.sockfd];
    }
    else{
        NSLog(@"%@", [NSString stringWithFormat:@"Error code %d ercived. Server was not started", bsdClient.errorCode]);

    }
}

- (void)startServer {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDataReceived:) name:@"postdata" object:nil];
    BSDSocketServer *server = [[BSDSocketServer alloc] initOnPort:2006];
    if (server.errorCode == NOERROR) {
        [server dataServerListenWithDescriptor:server.listenfd];
    }
    else{
        NSLog(@"%@", [NSString stringWithFormat:@"Error code %d ercived. Server was not started", server.errorCode]);
    }
}

- (void)newDataReceived:(NSNotification *)notification {
    NSData *data = notification.object;
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
    [self.view addSubview:self.imageView];
}


@end
