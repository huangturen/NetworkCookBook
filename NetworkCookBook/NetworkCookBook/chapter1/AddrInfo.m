//
//  AddrInfo.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/31.
//

#import "AddrInfo.h"

@implementation AddrInfo

- (instancetype)init{
    if (self = [super init]) {
        [self setVars];
    }
    return self;
}

- (void)setVars{
    self.hostname = @"";
    self.service = @"";
    self.results = NULL;
    _errorCode = 0;
}

- (void)addrWithHostname:(NSString *)lHostname Service:(NSString *)lService andHints:(struct addrinfo *)lHints{
    [self setVars];
    self.hostname = lHostname;
    self.service = lService;
    struct addrinfo *res;
    _errorCode = getaddrinfo([_hostname UTF8String], [_service UTF8String], lHints, &res);
    self.results = res;
}

- (void)nameWithSockaddr:(struct sockaddr*)saddr{
    [self setVars];
    char host[1024];
    char serv[20];
    
    _errorCode = getnameinfo(saddr, sizeof(saddr), host, sizeof(host), serv, sizeof(serv), 0);
    self.hostname = [NSString stringWithUTF8String:host];
    self.service = [NSString stringWithUTF8String:serv];
}

- (NSString *)errorString{
    return [NSString stringWithCString:gai_strerror(self.errorCode) encoding:NSASCIIStringEncoding];;
}

- (void)setResults:(struct addrinfo *)result{
    freeaddrinfo(self.results);
    _results = result;
}
@end
