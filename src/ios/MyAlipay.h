#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>

@interface MyAlipay : CDVPlugin

@property(nonatomic,strong)NSString *appId;
@property(nonatomic,strong)NSString *currentCallbackId;

- (void) pay:(CDVInvokedUrlCommand*)command;
@end

