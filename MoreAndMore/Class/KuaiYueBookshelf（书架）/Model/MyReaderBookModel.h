//
//  MyReaderBookModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"

#import "Magic_Topic.h"
#import "Magic_User.h"

#import "Magic_BookText.h"

@interface MyReaderBookModel : BaseArchiveModel

@property (nonatomic,copy)NSString *showUrl;

@property (nonatomic,copy)NSString *bookName;

@property (nonatomic,copy)NSString *author;

/**
 *  0:图书  1：文字书籍
 */
@property (nonatomic,assign)NSInteger bookType;

@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,assign)BOOL isChoose;

+(MyReaderBookModel *)readerBookModel:(Magic_Topic *)topic;

+(MyReaderBookModel *)readerBookModel_Text:(Magic_BookText *)bookText;

@end
