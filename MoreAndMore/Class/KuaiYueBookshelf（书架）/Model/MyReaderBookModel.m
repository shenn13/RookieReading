//
//  MyReaderBookModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MyReaderBookModel.h"

@implementation MyReaderBookModel

+(MyReaderBookModel *)readerBookModel:(Magic_Topic *)topic
{
    MyReaderBookModel *readerModel = [[MyReaderBookModel alloc] init];
    readerModel.showUrl = topic.cover_image_url;
    if (topic.cover_image_url.length > 0) {
        readerModel.showUrl = topic.cover_image_url;
    }else{
        readerModel.showUrl = topic.pic;
    }
    readerModel.bookName = topic.title;
    readerModel.author = topic.user.nickname;
    
    readerModel.bookType = 0;
    
    return readerModel;
}

+(MyReaderBookModel *)readerBookModel_Text:(Magic_BookText *)bookText
{
    MyReaderBookModel *readerModel = [[MyReaderBookModel alloc] init];
    readerModel.showUrl = ZHUISHU_IMG(bookText.cover);
    readerModel.bookName = bookText.title;
    readerModel.author = bookText.author;
    
    readerModel.bookType = 1;
    
    return readerModel;
}

@end
