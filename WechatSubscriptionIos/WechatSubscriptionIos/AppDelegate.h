//
//  AppDelegate.h
//  WechatSubscriptionIos
//
//  Created by ZEROwolf Hwang on 2019/5/28.
//  Copyright © 2019 ZEROwolf Hwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,sendMsgToWeChatViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;


@end

