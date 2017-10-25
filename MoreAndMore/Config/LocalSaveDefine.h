//
//  LocalSaveDefine.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#ifndef LocalSaveDefine_h
#define LocalSaveDefine_h

// 本地化CoreData数据库名字
#define  KUAI_YUE           @"kuai_yue.sqlite"

// 书籍（图片）刷新通知
#define IMAGE_BOOK_REFRESH  @"image_book_refresh"
#define IMAGE_BOOK_ID       @"image_book_id"
// 书籍（文字）刷新通知
#define TEXT_BOOK_REFRESH   @"text_book_refresh"
#define TEXT_BOOK_ID        @"text_book_id"

// 通知(登陆相关)
#define NEEDLOGIN_NOTNAME   @"NEED_LOGIN"

#define LOGIN_SUCCESS       @"LOGIN_SUCCESS"

// 切换到:精选选项卡
#define CHANGE_JINGXUAN_MENU @"CHANGE_JINGXUAN_MENU"

#define LOGINNEED_ACTION if(![SingletonUser sharedSingletonUser].sessionKey || ![SingletonUser sharedSingletonUser].userInfo.userId)\
{\
[[NSNotificationCenter defaultCenter] postNotificationName:NEEDLOGIN_NOTNAME object:nil];\
return;\
}

#endif /* LocalSaveDefine_h */
