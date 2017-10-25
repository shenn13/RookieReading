//
//  UserCertify.h
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"
/*
 userCertify =     {
 backICPhoto = "";
 certifyPhoto = "";
 confirmRemark = "";
 confirmStatus = 9;
 confirmTime = 0;
 createTime = 1460961693000;
 frontICPhoto = "";
 idCardNo = "";
 personPhoto = "";
 realName = "";
 updateTime = 0;
 userId = 1001;
 };
 */

@interface UserCertify : BaseArchiveModel

//  审核状态(1:待审核,2:审核通过,3:审核不通过,9:未提交过认证资料)
@property (nonatomic,assign)int confirmStatus;
//  用户ID
@property (nonatomic,assign)NSString *userId;
//  真实姓名
@property (nonatomic,copy)NSString *realName;
//  身份证背面照片
@property (nonatomic,copy)NSString *backICPhoto;
//  证明图片（经营许可证、学校盖章证明等）
@property (nonatomic,copy)NSString *certifyPhoto;
//  审核备注说明
@property (nonatomic,copy)NSString *confirmRemark;
//  身份证正面照片
@property (nonatomic,copy)NSString *frontICPhoto;
//  身份证号码
@property (nonatomic,copy)NSString *idCardNo;
//  个人照片
@property (nonatomic,copy)NSString *personPhoto;
//  更新时间
@property (nonatomic,assign)NSInteger updateTime;
//  审核时间
@property (nonatomic,assign)NSInteger confirmTime;
//  添加时间
@property (nonatomic,assign)NSInteger createTime;

@end
