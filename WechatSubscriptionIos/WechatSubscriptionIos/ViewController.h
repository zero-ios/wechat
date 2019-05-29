//
//  ViewController.h
//  WechatSubscriptionIos
//
//  Created by ZEROwolf Hwang on 2019/5/28.
//  Copyright © 2019 ZEROwolf Hwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void) changeScene:(NSInteger)scene;
- (void) sendTextContent;
@end


@interface ViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;

@end

