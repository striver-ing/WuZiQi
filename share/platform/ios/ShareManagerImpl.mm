//
//  ShareManagerImpl.m
//  WuZiQi
//
//  Created by LIUBO on 16/5/31.
//
//

#import <Foundation/Foundation.h>
#import "ShareManager.h"
#import "cocos2d.h"
#import <Social/Social.h>

bool ShareManager::share() {
    // 首先判断新浪分享是否可用
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        return false;
    }
    // 创建控制器，并设置ServiceType
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    // 添加要分享的图片
    [composeVC addImage:[UIImage imageNamed:@"Snip20150429_9"]];
    // 添加要分享的文字
    [composeVC setInitialText:@"share my CSDN Blog"];
    // 添加要分享的url
    [composeVC addURL:[NSURL URLWithString:@"http://blog.csdn.net/u011058732"]];
    // 弹出分享控制器
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:composeVC animated:YES completion:nil];
    // 监听用户点击事件
    composeVC.completionHandler = ^(SLComposeViewControllerResult result) {
      if (result == SLComposeViewControllerResultDone) {
          NSLog(@"点击了发送");
      } else if (result == SLComposeViewControllerResultCancelled) {
          NSLog(@"点击了取消");
      }
    };

    return true;
}