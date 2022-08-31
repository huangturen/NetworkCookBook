//
//  AddrInfo.h
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/31.
//

#import <Foundation/Foundation.h>
#import <netdb.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddrInfo : NSObject

@property(nonatomic, copy)NSString  *hostname;
@property(nonatomic, copy)NSString  *service;
@property(nonatomic, nullable)struct addrinfo *results;
@property(nonatomic)struct sockaddr *sa;
@property(nonatomic, readonly)int   errorCode;

- (void)addrWithHostname:(NSString *)lHostname Service:(NSString *)lService andHints:(struct addrinfo *)lHints;
- (void)nameWithSockaddr:(struct sockaddr*)saddr;
- (NSString *)errorString;

@end

NS_ASSUME_NONNULL_END
