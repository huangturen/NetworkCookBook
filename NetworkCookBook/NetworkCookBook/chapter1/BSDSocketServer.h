//
//  BSDSocketServer.h
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LISTENQ 1024
#define MAXLINE 4096

typedef NS_ENUM(NSUInteger, BSDServerErrorCode){
    NOERROR,
    SOCKETERROR,
    BINDERROR,
    LISTENERROR,
    ACCEPTINGERROR
};

@interface BSDSocketServer : NSObject

@property(nonatomic) int errorCode, listenfd;
- (instancetype)initOnPort:(int)port;
- (void)echoServerListenWithDescriptor:(int)lfd;
- (void)dataServerListenWithDescriptor:(int)lfd;

@end

NS_ASSUME_NONNULL_END
