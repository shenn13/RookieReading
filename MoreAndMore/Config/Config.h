//
//  Config.h
//  ProductDemo
//
//  Created by huangwenlong on 15/8/28.
//  Copyright (c) 2015年 huang. All rights reserved.
//

#pragma mark - Redefine

// 应用版本
#define APP_VERSION                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_UPDATE_VERSION                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// 主资源包MainBundle
#define MAINBUNDLE [NSBundle mainBundle]

// 应用标识
#define APP_IDENTIFIER                       [[NSBundle mainBundle] bundleIdentifier]

// 当前系统按本
#define SYSTEM_VERSION                       [[UIDevice currentDevice] systemVersion]

// Appdelegate
#define APPLICATION_DELEGATE                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// 网络状态
#define NETWORKSTATUS                        ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus)

// 系统UserDefault
#define USER_DEFAULT                         [NSUserDefaults standardUserDefaults]

// 屏幕高、宽
#define SCREEN_HEIGHT                        [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                         [UIScreen mainScreen].bounds.size.width

// 系统相关控件高度
#define STATUSBAR_HEIGHT                      20.0
#define NAVIGATIONBAR_HEIGHT                  44.0
#define NAVIGATIONANDSTATUSBAR_HEIGHT         64.0
#define TOOLBAR_HEIGHT                        49.0
#define FIX_NAV_HEIGHT                        113.0

// Frame And Size 相关
#define VIEW_WIDTH(v)                        v.frame.size.width
#define VIEW_HEIGHT(v)                       v.frame.size.height

#define VIEW_X(v)                            v.frame.origin.x
#define VIEW_Y(v)                            v.frame.origin.y

#define VIEW_CENTER_X(v)                     v.center.x
#define VIEW_CENTER_Y(v)                     v.center.y

#define SIZE_WIDTH(v)                        v.size.width
#define SIZE_HEIGHT(v)                       v.size.height

#define ORIGIN_X(v)                          v.origin.x
#define ORIGIN_Y(v)                          v.origin.y

// 窗口
#define WINDOW                               ((UIWindow *)[[[UIApplication sharedApplication] windows] lastObject])
#define KEY_WINDOW                           ([[UIApplication sharedApplication] keyWindow])

// 系统版本判断
#define IOS7                                 [[[UIDevice currentDevice] systemVersion] floatValue]<8
#define IOS8                                 [[[UIDevice currentDevice] systemVersion] floatValue]>=8
#define IOS9                                 [[[UIDevice currentDevice] systemVersion] floatValue]>=9

// 弱引用self
#define kSelfWeak __weak typeof(self) weakSelf = self

// 百分比
#define IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCALE   (IPhone6 ? 1.1718 : (IPhone6p ? 1.2937 : 1.0000))
#define HSCALE  (IPhone6 ? 1.1743 : (IPhone6p ? 1.2957 : 1.0000))

#define High(a)     HSCALE * a
#define Width(a)    SCALE * a

// 跳转管理器
#define JUMP_MANAGER [ZXJumpToControllerManager sharedZXJumpToControllerManager]

// 从sb获取vc
#define BoardVC(name)     ([[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewController])
#define BoardVCWithID(name,ID)     ([[UIStoryboard storyboardWithName:name bundle:nil]  instantiateViewControllerWithIdentifier:ID])

// RGB颜色获取
#define RGB(r, g, b)        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

// 图片获取
#define IMAGE(name)     [UIImage imageNamed:name]

// 字体名称
#define ARIAL               @"Arial"
#define BOLD_ARIAL          @"Arial-BoldMT"

// 字体
#define FONT(s)             [UIFont fontWithName:ARIAL size:(s)]
#define FONT_BOLD(s)        [UIFont fontWithName:BOLD_ARIAL size:(s)]
#define zFONT(name,size)    [UIFont fontWithName:name size:(size)]

// 请求提示文本
#define REQUESTTIPING       @"请稍等!\n正在努力加载中！"
#define REQUESTTIPSUC       @"加载成功！"
#define REQUESTTIPFAI       @"很抱歉!\n数据加载失败！"

// 美元符号（中文）
#define DOLARR              @"￥"

#define PAGESIZE10          @10
#define PAGESIZE20          @20

// 请求URL相关
#define SERVERURL_KUAIKAN           @"http://api.kuaikanmanhua.com/v1"

#define SERVERURL_ZHUISHU           @"http://api.zhuishushenqi.com"
#define SERVERURL_ZHUISHU_CHALPTER  @"http://chapter2.zhuishushenqi.com"


// 追书神器图片存储地址
#define ZHUISHU_IMAGE               @"http://statics.zhuishushenqi.com"

#define ZHUISHU_IMG(img)            [NSString stringWithFormat:@"%@%@",ZHUISHU_IMAGE,img]

#define PIC_EXTENSION               @"-w640"

//默认图片
#define DEFAULT_BG     [UIImage imageNamed:@"placeholder"]

#define DEFAULT_IMAGE  [UIImage imageNamed:@"default_image_bg"]

#define DEFAULT_ICON   [UIImage imageNamed:@"default_avater"]

#define URLIMAGE(url)       [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,url]]
#define URLSTRING(url)      [NSString stringWithFormat:@"%@%@",SERVERURL,url]

