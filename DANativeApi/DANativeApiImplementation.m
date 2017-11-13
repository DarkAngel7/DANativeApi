//
//  DANativeApiImplementation.m
//  DANativeApi
//
//  Created by DarkAngel on 2017/6/6.
//  Copyright © 2017年 暗の天使. All rights reserved.
//

#import "DANativeApiImplementation.h"

@implementation DANativeApiImplementation
/**
 分享
 
 @param data 分享的数据，格式为
                             {title: document.title,
                             desc: "",
                             url: location.href,
                             imgUrl: ""}
 @param completionHandler 分享完成的回调，返回@YES or @NO
 */
+ (void)nativeShareWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    NSDictionary *shareInfo = data;
    NSLog(@"%@", shareInfo);
    
}
/**
 选择联系人
 
 @param data 一般为@{}
 @param completionHandler 选择完成的回调，返回@{@"name": @"DarkAngel", @"phone": @"10086"}
 */
+ (void)nativeChoosePhoneContactWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    //模拟异步回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionHandler(@{@"name": @"DarkAngel", @"phone": @"10086"});
    });
}
/**
 支付
 
 @param data 一般为支付需要的参数，格式为@{@"paymentInfo": @"fadsfas", @"paymentNum": @"", @"payWay": @1}
 @param completionHandler 选择完成的回调，返回@YES or @NO
 */
+ (void)nativePaymentWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 跳转到某页
 
 @param data 跳转页面的url，一般为@{@"url": @"http://www.baidu.com"}，当然也可以是urwork://
 @param completionHandler 跳转完成回调，默认无失败，返回@YES
 */
+ (void)nativeNavigateToWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 重定向到某页，其实就是先pop后push
 
 @param data 跳转页面的url，一般为@{@"url": @"http://www.baidu.com"}，当然也可以是urwork://
 @param completionHandler 跳转完成回调，默认无失败，返回@YES
 */
+ (void)nativeRedirectToWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 关闭当前页，其实就是pop
 
 @param data 一般为@{}
 @param completionHandler 关闭完成回调，不可能失败，返回@YES
 */
+ (void)nativeNavigateBackWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 显示软提示
 
 @param data 软提示的信息，格式为@{@"message": @"登录成功"}
 @param completionHandler 显示完成的回调，不可能失败，返回@YES
 */
+ (void)nativeShowMessageWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 显示加载中
 
 @param data 加载的信息，格式为@{@"message": @"跳转中..."}，可以为@{}，默认为"加载中..."
 @param completionHandler 显示加载中完成的回调，返回@YES
 */
+ (void)nativeShowLoadingWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 隐藏加载中
 
 @param data 一般为@{}
 @param completionHandler 隐藏加载中完成的回调，返回@YES
 */
+ (void)nativeHideLoadingWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 是否显示navigationBar
 
 @param data 是否显示，格式为@{@"isShow": @YES}
 @param completionHandler 回调，返回@YES
 */
+ (void)nativeShowNavigationBarWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 是否显示WebView的分享按钮
 
 @param data 是否显示，格式为@{@"isShow": @YES}
 @param completionHandler 回调，返回@YES
 */
+ (void)nativeShowShareButtonWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}
/**
 原生输入框，输入文本
 
 @param data 默认为@{}，如果不为@{}，格式为@{@"content": @"哈哈", @"placeHolder": @"说点什么吧~"};
 @param completionHandler 输入完成的回调，返回@"这是输入完毕的内容"
 */
+ (void)nativeInputTextContentWithData:(nonnull NSDictionary *)data completionHandler:(DANativeApiCompletionHandler)completionHandler
{
    
}


@end
