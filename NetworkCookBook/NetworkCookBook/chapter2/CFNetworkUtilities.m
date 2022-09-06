//
//  CFNetworkUtilities.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/9/5.
//

#import "CFNetworkUtilities.h"
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>

@implementation CFNetworkUtilities

- (NSArray *)addressesForHostname:(NSString *)hostName{
    self.errorCode = CFNetWorkingErrorCodeNOERROR;
    char ipAddr[INET6_ADDRSTRLEN];
    NSMutableArray *addresses = [NSMutableArray array];
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostName);
    BOOL success = CFHostStartInfoResolution(hostRef, kCFHostAddresses, nil);
    if (!success) {
        self.errorCode = CFNetWorkingErrorCodeHOSTRESOLUTIONERROR;
        CFRelease(hostRef);
        return nil;
    }
    CFArrayRef addressesRef = CFHostGetAddressing(hostRef, nil);
    if (!addressesRef) {
        self.errorCode = CFNetWorkingErrorCodeHOSTRESOLUTIONERROR;
        return nil;
    }
    
    CFIndex numAddresses = CFArrayGetCount(addressesRef);
    for (CFIndex currentIndex = 0; currentIndex<numAddresses; currentIndex++) {
        struct sockaddr *address = (struct sockaddr *)CFDataGetBytePtr(CFArrayGetValueAtIndex(addressesRef, currentIndex));
        if (!address) {
            self.errorCode = CFNetWorkingErrorCodeHOSTRESOLUTIONERROR;
            return nil;
        }
        getnameinfo(address, address->sa_len, ipAddr, INET6_ADDRSTRLEN, nil, 0, NI_NUMERICHOST);
        if (!ipAddr) {
            self.errorCode = CFNetWorkingErrorCodeHOSTRESOLUTIONERROR;
            return nil;
        }
        
        [addresses addObject:[NSString stringWithCString:ipAddr encoding:NSASCIIStringEncoding]];
    }
    return addresses;
}

- (NSArray *)hostnamesForAddress:(NSString *)address{
    self.errorCode = CFNetWorkingErrorCodeNOERROR;
    struct addrinfo hints;
    struct addrinfo *result = NULL;
    memset(&hints, 0, sizeof(hints));
    
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = 0;
    
    int error = getaddrinfo([address cStringUsingEncoding:NSASCIIStringEncoding], NULL, &hints, &result);
    if (error != 0) {
        self.errorCode = CFNetWorkingErrorCodeADDRESSRESOLUTIONERROR;
        return nil;
    }
    
    CFDataRef addressRef = CFDataCreate(NULL, (UInt8 *)result->ai_addr, result->ai_addrlen);
    if (!addressRef) {
        self.errorCode = CFNetWorkingErrorCodeADDRESSRESOLUTIONERROR;
        return  nil;
    }
    freeaddrinfo(result);
    
    CFHostRef hostRef = CFHostCreateWithAddress(kCFAllocatorDefault, addressRef);
    if (!hostRef) {
        self.errorCode = CFNetWorkingErrorCodeADDRESSRESOLUTIONERROR;
        return nil;
    }
    
    CFRelease(addressRef);
    BOOL isSuccess = CFHostStartInfoResolution(hostRef, kCFHostNames, NULL);
    if (!isSuccess) {
        self.errorCode = CFNetWorkingErrorCodeADDRESSRESOLUTIONERROR;
        return nil;
    }
    
    CFArrayRef hostnamesRef = CFHostGetNames(hostRef, NULL);
    NSMutableArray *hostnames = [NSMutableArray array];
    for (int currentIndex = 0; currentIndex<[(__bridge NSArray *)hostnamesRef count]; currentIndex++) {
        [hostnames addObject:[(__bridge NSArray *)hostnamesRef objectAtIndex:currentIndex]];
    }
    return hostnames;
}

@end
