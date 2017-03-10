#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>

@interface Alipay : CDVPlugin

@property(nonatomic,strong)NSString *partner;
@property(nonatomic,strong)NSString *currentCallbackId;

- (void) pay:(CDVInvokedUrlCommand*)command;
@end

