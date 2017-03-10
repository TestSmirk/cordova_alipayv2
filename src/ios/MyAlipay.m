#import "Order.h"
#import "MyAlipay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation MyAlipay

- (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
        (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );

    return encodedString;
}

- (void) pay:(CDVInvokedUrlCommand*)command
{
    self.currentCallbackId = command.callbackId;
    //从API请求获取支付信息
    NSMutableDictionary *args = [command argumentAtIndex:0];
    NSString   *orderString    = [args objectForKey:@"orderInfo"];
    self.appId    = [args objectForKey:@"appId"];


    NSString *appId1 = @"2017010904938641";
   // NSLog(@"isEqual--%d",[self.appId isEqual: appId1]);
    if ([self.appId isEqual: appId1]) {
     NSString *appScheme = @"alipayCordova";
        //NSLog(@"传的参数");
       // NSLog(@"orderString = %@",orderString);

        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
                [self successWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
                 NSLog(@"成功");
                 NSLog(@"reslut = %@",resultDic);
            } else {
                [self failWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
                NSLog(@"失败");
                NSLog(@"reslut = %@",resultDic);
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
