//
//  CFNetworkUtilities.h
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CFNetWorkingErrorCode) {
    CFNetWorkingErrorCodeNOERROR,
    CFNetWorkingErrorCodeHOSTRESOLUTIONERROR,
    CFNetWorkingErrorCodeADDRESSRESOLUTIONERROR
};

@interface CFNetworkUtilities : NSObject

@property(nonatomic) int errorCode;
- (NSArray *)addressesForHostname:(NSString *)hostName;
- (NSArray *)hostnamesForAddress:(NSString *)address;


@end

NS_ASSUME_NONNULL_END
