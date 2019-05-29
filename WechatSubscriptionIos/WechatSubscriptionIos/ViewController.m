//
//  ViewController.m
//  WechatSubscriptionIos
//
//  Created by ZEROwolf Hwang on 2019/5/28.
//  Copyright © 2019 ZEROwolf Hwang. All rights reserved.
//

#import "ViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <AFNetworking.h>
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) NSString *access_token;


@end

@implementation ViewController

@synthesize delegate = _delegate;

- (AFHTTPSessionManager *)sharedManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;

    // 请求格式
    // AFHTTPRequestSerializer            二进制格式
    // AFJSONRequestSerializer            JSON
    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)

    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式

    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/json", @"text/plain", nil];

    // 返回格式
    // AFHTTPResponseSerializer           二进制格式
    // AFJSONResponseSerializer           JSON
    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    // AFXMLDocumentResponseSerializer (Mac OS X)
    // AFPropertyListResponseSerializer   PList
    // AFImageResponseSerializer          Image
    // AFCompoundResponseSerializer       组合
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/json", @"text/plain", nil];

    return manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 180, 80)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"点击跳转微信" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendTextContent) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];

    UIButton *postBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 180, 80)];
    postBtn.backgroundColor = [UIColor blueColor];
    [postBtn setTitle:@"Post请求" forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postHttp) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:postBtn];

    UIButton *subsBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 180, 80)];
    subsBtn.backgroundColor = [UIColor blueColor];
    [subsBtn setTitle:@"一次性订阅" forState:UIControlStateNormal];
    [subsBtn addTarget:self action:@selector(subsClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:subsBtn];

    UIButton *access_tokenBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 180, 80)];
    access_tokenBtn.backgroundColor = [UIColor blueColor];
    [access_tokenBtn setTitle:@"获取access_token" forState:UIControlStateNormal];
    [access_tokenBtn addTarget:self action:@selector(tokenClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:access_tokenBtn];


    _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 200, 300)];
    _label.backgroundColor = [UIColor purpleColor];
    _label.textColor = [UIColor whiteColor];
    _label.text = @"一次性订阅返回内容";
    [self.view addSubview:_label];

}

- (void)tokenClick {
    NSString *url = @"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxf6e73d6ac18bdf08&secret=8eafb3f03f9106a8c9c7faf7da27a091";
//    url = [url stringByAppendingString:title];
    [[self sharedManager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        _access_token = [responseObject valueForKey:@"access_token"];
        NSLog(@"_access_token   %@", _access_token);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"返回的access_token" message:_access_token delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];


    }                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)subsClick {
    WXSubscribeMsgReq *req = [[WXSubscribeMsgReq alloc] init];
    req.scene = WXSceneSession;
    req.templateId = @"NwsSyD7WaCfQhjg0yyKsuvABKH5Gn3tpDeYHHR167tQ";
//    req.reserved = reserved;
    [WXApi sendReq:req];
}

- (void)postHttp {
    NSLog(@"postHttp -------------------------");

////    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    NSString *url = @"https://suggest.taobao.com/sug?code=utf-8&q=weiyi";
////    url = [url stringByAppendingString:title];
//    [[self sharedManager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         NSLog(@"%@",error);
//    }];


//{
//“touser”:”OPENID”,
//“template_id”:”TEMPLATE_ID”,
//“url”:”URL”,
//“scene”:”SCENE”,
//“title”:”TITLE”,
//“data”:{
//“content”:{
//“value”:”VALUE”,
//“color”:”COLOR”
//}
//}
//}

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

//        NSString *string = [NSString initWithFormat:@"%@,%@",openId, templateId];
    NSString *openId = [defaults objectForKey:@"openId"];
    NSLog(@"openId------%@", openId);
    NSLog(@"_access_token   %@", _access_token);

    NSString *url1 = @"https://api.weixin.qq.com/cgi-bin/message/template/subscribe?access_token=";

    NSString *urlString = [url1 stringByAppendingFormat:_access_token];;
    NSLog(@"urlString   %@", urlString);

    //初始化一个AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求体数据为json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置响应体数据为json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *content = @{
            @"value": @"这是第三方传过来的数据Data",
            @"color": @"blue",
    };

    //请求体，参数（NSDictionary 类型）
    NSDictionary *data = @{
            @"content": content,
    };

    NSDictionary *parameters = @{@"touser": openId,
            @"template_id": @"NwsSyD7WaCfQhjg0yyKsuvABKH5Gn3tpDeYHHR167tQ",
            @"scene": @"0",
            @"url": @"https://sgxq.qq.com/m/",
            @"title": @"微信一次性订阅",
            @"data": data,

    };
    [manager POST:urlString parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress) {
    }     success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString *code = [responseObject objectForKey:@"errcode"];
        NSString *msg= [responseObject objectForKey:@"errmsg"];

//        NSString *errCode1 = [@"errCode: " stringByAppendingFormat:code];
//        NSString *errMsg1 = [@"errMsg: " stringByAppendingFormat:msg];
//
//        NSString *allStr = [errCode1 stringByAppendingFormat:errMsg1];

        NSLog(@"allStr   %@", msg);
        NSData *data= [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *strhh = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微信一次性订阅回调" message:strhh delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          [alert show];

    }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"%@", error);
    }];
//
}


- (void)sendTextContent {
    NSLog(@"dianji -------------------------");

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    req.scene = WXSceneSession;

    [WXApi sendReq:req];

    if (_delegate) {
        NSLog(@"_delegate ------------------------- is true");

        [_delegate sendTextContent];
    }
}


@end
