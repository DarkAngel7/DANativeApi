//
//  DANativeApi.m
//  DANativeApi
//
//  Created by DarkAngel on 2017/5/22.
//  Copyright © 2017年 暗の天使. All rights reserved.
//

#import "DANativeApi.h"
#import "DANativeApiImplementation.h"
#import <WebKit/WebKit.h>

static NSString *const kNativeShareApi = @"share";
static NSString *const kNativeChoosePhoneContactApi = @"choosePhoneContact";
static NSString *const kNativePaymentApi = @"payment";
static NSString *const kNativeNavigateToApi = @"navigateTo";
static NSString *const kNativeRedirectToApi = @"redirectTo";
static NSString *const kNativeNavigateBackApi = @"navigateBack";
static NSString *const kNativeShowMessageApi = @"showMessage";
static NSString *const kNativeShowLoadingApi = @"showLoading";
static NSString *const kNativeHideLoadingApi = @"hideLoading";
static NSString *const kNativeShowNavigationBarApi = @"showNavigationBar";
static NSString *const kNativeShowShareButtonApi = @"showShareButton";
static NSString *const kNativeInputTextContentApi = @"inputTextContent";

@interface DANativeApi () <WKScriptMessageHandler>
/**
 弱引用webView对象
 */
@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, strong) NSMutableDictionary *scriptMessageMap;

@end

@implementation DANativeApi

#pragma mark - Public Methods
/**
 构造方法
 
 @param webView WKWebView对象
 @return DANativeApi对象
 */
- (instancetype)initWithWebView:(nonnull WKWebView *)webView
{
    if (self = [super init]) {
        self.webView = webView;
        [self initialize];
    }
    return self;
}

/**
 添加一个Api

 @param name 名称
 @param callback 回调
 */
- (void)addNativeApi:(nonnull NSString *)name callback:(nullable DANativeApiCallback)callback
{
    NSAssert([name isKindOfClass:[NSString class]] && name.length, @"name 参数 不能为空，且 name 必须是字符串格式");
    if (![name isKindOfClass:[NSString class]] || !name.length) {
        return;
    }
    __weak typeof(self) wself = self;
    if (!callback) {
        callback = ^(NSDictionary *data, DANativeApiCompletionHandler completionHandler){
            completionHandler([wself resultDataForData:nil]);
        };
    }
    self.scriptMessageMap[name] = callback;
    //调用js脚本
    NSString *nativejs = [NSString stringWithFormat:@"if (typeof DANativeApi != 'undefined') { DANativeApi.generateApi('%@'); }", name];
    if (self.webView.URL) {
        [self.webView evaluateJavaScript:nativejs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"添加api：%@成功！", name);
            } else {
                NSLog(@"添加api：%@失败，错误为：%@", name, error);
            }
        }];
    }
    WKUserScript *js = [[WKUserScript alloc] initWithSource:nativejs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:js];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:name];
}

/**
 移除一个Api
 
 @param name api名称
 */
- (void)removeNativeApi:(nonnull NSString *)name
{
    NSAssert([name isKindOfClass:[NSString class]] && name.length, @"name 参数 不能为空，且 name 必须是字符串格式");
    if (![name isKindOfClass:[NSString class]] || !name.length) {
        return;
    }
    //调用js脚本
    NSString *nativejs = [NSString stringWithFormat:@"if (typeof DANativeApi != 'undefined'){ DANativeApi.deleteApi('%@'); }", name];
    if (self.webView.URL) {
        [self.webView evaluateJavaScript:nativejs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"删除api：%@成功！", name);
            } else {
                NSLog(@"删除api：%@失败，错误为：%@", name, error);
            }
        }];
    }
    WKUserScript *js = [[WKUserScript alloc] initWithSource:nativejs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:js];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    [self.scriptMessageMap removeObjectForKey:name];
}

#pragma mark - Initialize
/**
 初始化
 */
- (void)initialize
{
    //初始化scriptMessageMap
    self.scriptMessageMap = @{}.mutableCopy;
    //此方法可能无需调用，取决于前端，是否会引用此js
    //[self injectNativeApiJs];
    [self addNativeApis];
}

/*
- (void)injectNativeApiJs
{
    //防止频繁IO操作，造成性能影响
    static NSString *nativejs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativejs = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DANativeApi" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    });
    //添加js
    WKUserScript *js = [[WKUserScript alloc] initWithSource:nativejs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:js];
}
*/

- (void)addNativeApis
{
    //添加分享
    [self addNativeApi:kNativeShareApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler _Nonnull completionHandler) {
        [DANativeApiImplementation nativeShareWithData:data completionHandler:completionHandler];
    }];
    //添加选择联系人
    [self addNativeApi:kNativeChoosePhoneContactApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeChoosePhoneContactWithData:data completionHandler:completionHandler];
    }];
    //支付
    [self addNativeApi:kNativePaymentApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativePaymentWithData:data completionHandler:completionHandler];
    }];
    //跳转到某页
    [self addNativeApi:kNativeNavigateToApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeNavigateToWithData:data completionHandler:completionHandler];
    }];
    //重定向到某页
    [self addNativeApi:kNativeRedirectToApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeRedirectToWithData:data completionHandler:completionHandler];
    }];
    //返回上页
    [self addNativeApi:kNativeNavigateBackApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeNavigateBackWithData:data completionHandler:completionHandler];
    }];
    //显示软提示
    [self addNativeApi:kNativeShowMessageApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeShowMessageWithData:data completionHandler:completionHandler];
    }];
    //显示加载中
    [self addNativeApi:kNativeShowLoadingApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeShowLoadingWithData:data completionHandler:completionHandler];
    }];
    //隐藏加载中
    [self addNativeApi:kNativeHideLoadingApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeHideLoadingWithData:data completionHandler:completionHandler];
    }];
    //显示NavigationBar与否
    [self addNativeApi:kNativeShowNavigationBarApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeShowNavigationBarWithData:data completionHandler:completionHandler];
    }];
    //显示默认的分享按钮与否
    [self addNativeApi:kNativeShowShareButtonApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeShowShareButtonWithData:data completionHandler:completionHandler];
    }];
    //输入纯文本
    [self addNativeApi:kNativeInputTextContentApi callback:^(NSDictionary * _Nonnull data, DANativeApiCompletionHandler  _Nonnull completionHandler) {
        [DANativeApiImplementation nativeInputTextContentWithData:data completionHandler:completionHandler];
    }];
}

- (void)removeScriptMessageHandlers
{
    [self.scriptMessageMap.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:key];
    }];
}

- (void)dealloc
{
    [self removeScriptMessageHandlers];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    id body = message.body;
    if (!body || ![body isKindOfClass:[NSDictionary class]]) {
        NSLog(@"回调参数有误");
        return;
    }
    DANativeApiCallback callback = self.scriptMessageMap[message.name];
    if (!callback) {
        return;
    }
    NSDictionary *data = body;
    __weak typeof(self) wself = self;
    DANativeApiCompletionHandler completionHandler = ^(_Nullable id completionData) {
        NSString *completionJsFunctionString = data[@"completion"];
        if (!completionJsFunctionString) {
            return;
        }
        //拼接回调js
        id resultData = [wself resultDataForData:completionData];
        NSString *completionJs = [NSString stringWithFormat:@"DANativeApi.callback(%@, JSON.parse('%@'));", data[@"callbackId"] ? : @"", [wself jsonStringForObject:resultData]];
        [wself.webView evaluateJavaScript:completionJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"回调失败，error：%@", error);
            } else {
                NSLog(@"回调成功");
            }
        }];
    };
    NSMutableDictionary *callbackData = data.mutableCopy;
    [callbackData removeObjectForKey:@"completion"];
    callback(callbackData.copy, completionHandler);
}

#pragma mark - Helpers

- (NSDictionary *)resultDataForData:(nullable id)data
{
    if (data) {
        return @{@"data": data};
    } else {
        return @{};
    }
}

- (NSString *)jsonStringForObject:(id)obj
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    if (!data) {
        return @"";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
