//
//  ViewController.m
//  NetworkCookBook
//
//  Created by mabaoyan on 2022/8/30.
//

#import "ViewController.h"
#import "ByteOrder.h"
#import "NetworkAddressStore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    EndianType type = [ByteOrder byteOrder];
//    NSLog(@"%@",@(type));
    
    NetworkAddressStore *networkAddressStore = [NetworkAddressStore new];
    NSLog(@"%@",[networkAddressStore networkInfos]);
}


@end
