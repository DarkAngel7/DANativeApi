//
//  DANativeApi.h
//  DANativeApi
//
//  Created by DarkAngel on 2017/5/22.
//  Copyright © 2017年 暗の天使. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DANativeApiCompletionHandler)(_Nullable id data);
typedef void(^DANativeApiCallback)(NSDictionary * _Nonnull data, _Nonnull DANativeApiCompletionHandler completionHandler);

@class WKWebView;
/**
 为js提供NativeApi的对象
 */
@interface DANativeApi : NSObject
/**
 构造方法

 @param webView WKWebView对象，DANativeApi会weak引用，所以不用担心循环引用
 @return DANativeApi对象
 */
- (instancetype)initWithWebView:(nonnull WKWebView *)webView NS_DESIGNATED_INITIALIZER;
/**
 不可用，请使用initWithWebView:
 */
- (instancetype)init NS_UNAVAILABLE;
/**
 不可用，请使用alloc initWithWebView:
 */
+ (instancetype)new NS_UNAVAILABLE;
/**
 添加一个Api
 
 @param name api名称
 @param callback 回调，可以拿到参数data，在执行完毕的时候调用DANativeApiCompletionHandler回传执行结果
 */
- (void)addNativeApi:(nonnull NSString *)name callback:(nullable DANativeApiCallback)callback;
/**
 移除一个Api

 @param name api名称
 */
- (void)removeNativeApi:(nonnull NSString *)name;

@end

NS_ASSUME_NONNULL_END
