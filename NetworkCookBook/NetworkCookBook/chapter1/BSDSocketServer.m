//
//  BSDSocketServer.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/9/1.
//

#import "BSDSocketServer.h"
#import <sys/types.h>
#import <arpa/inet.h>

@implementation BSDSocketServer

- (instancetype)initOnPort:(int)port{
    self = [super init];
    if (self) {
        struct sockaddr_in servaddr;
        self.errorCode = NOERROR;
        if ((self.listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
            self.errorCode = SOCKETERROR;
        }
        else{
            memset(&servaddr, 0, sizeof(servaddr));
            servaddr.sin_family = AF_INET;
            servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
            servaddr.sin_port = htons(port);
            
            if (bind(self.listenfd, (struct sockaddr *)&servaddr, sizeof(servaddr))<0) {
                self.errorCode = BINDERROR;
            }
            else{
                if (listen(self.listenfd, LISTENQ)<0) {
                    self.errorCode = LISTENERROR;
                }
            }
        }
        
    }
    return self;
}

- (void)echoServerListenWithDescriptor:(int)lfd{
    int connfd;
    socklen_t clilen;
    struct sockaddr_in cliaddr;
    char buf[MAXLINE];
    
    for (;;) {
        clilen = sizeof(cliaddr);
        if ((connfd = accept(lfd, (struct sockaddr *)&cliaddr, &clilen))<0) {
            if (errno != EINTR) {
                self.errorCode = ACCEPTINGERROR;
                NSLog(@"Error accepting connection");
            }
        }
        else{
            self.errorCode = NOERROR;
            NSString *connStr = [NSString stringWithFormat:@"Connection from %s, port %d", inet_ntop(AF_INET, &cliaddr.sin_addr, buf, sizeof(buf)), ntohs(cliaddr.sin_port)];
            NSLog(@"%@", connStr);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self strEchoServer:@(connfd)];
            });
        }
    }
}

- (void)strEchoServer:(NSNumber *)sockfdNum{
    ssize_t n;
    char buf[MAXLINE];
    
    int sockfd = [sockfdNum intValue];
    while ((n = recv(sockfd, buf, MAXLINE -1, 0)) > 0) {
        [self written:sockfd msg:buf size:n];
        buf[n] = '\0';
        NSString *ret = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
        NSString *newData = [NSString stringWithFormat:@"xxxxxx：%@",ret];
        NSLog(@"我是服务端，我收到的数据为:%@, 我产出的数据为：%@", ret, newData);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"posttext" object:newData];
    }
    NSLog(@"closing socket");
    close(sockfd);
}

- (size_t)written:(int)sockfd msg:(const char *)vptr size:(ssize_t)len{
    size_t nleft;
    ssize_t nwritten;
    const char *ptr;
    
    ptr = vptr;
    nleft = len;
    
    while (nleft > 0) {
        if ((nwritten = write(sockfd, ptr, nleft)) <= 0) {
            if (nwritten < 0 && errno == EINTR) {
                nwritten = 0;
            }
            else{
                return -1;
            }
        }
        nleft -= nwritten;
        ptr += nwritten;
    }
    return (len);
}

@end
