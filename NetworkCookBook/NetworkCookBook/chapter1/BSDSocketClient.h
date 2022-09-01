//
//  BSDSocketClient.h
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LISTENQ 1024
#define MAXLINE 4096

typedef NS_ENUM(NSUInteger, BSDClientErrorCode){
    ClientNOERROR,
    ClientSOCKETERROR,
    ClientCONNECTRROR,
    ClientREADERROR,
    ClientWRITEERROR
};

@interface BSDSocketClient : NSObject

@property(nonatomic) int errorCode, sockfd;
- (instancetype)initWithAddress:(NSString *)addr andPort:(int)port;
- (ssize_t)writtenToSocket:(int)sockfdNum withChar:(NSString *)vptr;
- (NSString *)recvFromSocket:(int)lsockfd withMaxChar:(int)max;

@end

NS_ASSUME_NONNULL_END
