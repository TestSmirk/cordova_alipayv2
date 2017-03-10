#import "Alipay.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation Alipay

- (void) pay:(CDVInvokedUrlCommand*)command
{
    self.currentCallbackId = command.callbackId;
    //从API请求获取支付信息
    NSMutableDictionary *args = [command argumentAtIndex:0];
    NSString   *orderString    = [args objectForKey:@"orderInfo"];
    self.partner= [args objectForKey:@"parter"];
    //self.appId    = [args objectForKey:@"appId"];


   // NSLog(@"isEqual--%d",[self.appId isEqual: appId1]);
            //NSLog(@"传的参数");
           // NSLog(@"orderString = %@",orderString);
    if (orderString != nil) {
        NSLog(@"开始支付");
        NSString *appScheme = @"alipayCordovaPlugin";
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果返回");
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
                NSLog(@"reslut = %@",resultDic);
                [self successWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
            } else {
                NSLog(@"reslut = %@",resultDic);
                [self failWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
            }
        }];
    }
}

//当调用支付宝客户端的时候使用，否则调用客户端时无返回值，返回app时调用
- (void)handleOpenURL:(NSNotification *)notification
{
    NSURL* url = [notification object];
    NSString *appScheme = @"alipayCordovaPlugin";
    //NSLog(@"isEqual--%d",[url.scheme isEqualToString:appScheme]);

    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:appScheme])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
                [self successWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
            } else {
                [self failWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
            }
        }];
    }
}

- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}
- (void)successWithCallbackID:(NSString *)callbackID messageAsDictionary:(NSDictionary *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID messageAsDictionary:(NSDictionary *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}
@end
