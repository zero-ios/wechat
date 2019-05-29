//
//  AppDelegate.m
//  WechatSubscriptionIos
//
//  Created by ZEROwolf Hwang on 2019/5/28.
//  Copyright © 2019 ZEROwolf Hwang. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApiObject.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

      [WXApi registerApp:@"wxf6e73d6ac18bdf08"];
    [self performSelector:@selector(testLog) withObject:nil afterDelay:3];

    return YES;
}


- (void) testLog
{
    NSLog(@"startstart");
    for (int i = 0; i < 1; i++)
    {
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"wxf6e73d6ac18bdf08%d://",i]]];
    }
    NSLog(@"endend");
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;

        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;

        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    if([resp isKindOfClass:[WXSubscribeMsgResp class]])
    {
        WXSubscribeMsgResp *sendAuthResp = (WXSubscribeMsgResp *) resp;

        NSString *openId = [@"openId: " stringByAppendingFormat:sendAuthResp.openId];
        NSString *templateId = [@"    templateId: " stringByAppendingFormat:sendAuthResp.templateId];
        NSString *action = sendAuthResp.action;
        NSString *reserved = sendAuthResp.reserved;

        NSLog(@"openId----------%@", openId);
        NSLog(@"templateId----------%@", templateId);

        templateId;

        NSLog(@"sendAuth----------%@", @"属于WXSubscribeMsgResp回调");
        NSLog(@"sendAuth----------%d", resp.errCode);
        NSLog(@"sendAuth----------%@", resp.errStr);
//        NSLog(@"sendAuth----------%@", resp.template_id);

        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];

        NSString *string = [openId stringByAppendingFormat:templateId];

        NSLog(@"string----------%@", string);


        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

//        NSString *string = [NSString initWithFormat:@"%@,%@",openId, templateId];
        [defaults setObject: sendAuthResp.openId forKey:@"openId"];
        [defaults synchronize];//立即保存

    }

    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 微信登陆的返回信息
        SendAuthResp *sendAuthResp = (SendAuthResp *) resp;
        NSLog(@"sendAuth----------%@", sendAuthResp.code);

    }

    NSLog(@"sendAuth----------%@", resp);

}


- (void) sendTextContent
{

    NSLog(@"走了回调");
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    req.scene = WXSceneSession;

    [WXApi sendReq:req];
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
