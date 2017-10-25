//
//  BindedBankCard.h
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"

/*
 bindedBankCard =     {
    private Integer id;//主键ID
	private Integer userId;//绑卡用户ID
	private String realName;//真实姓名
	private String idCardNo;//身份证号码
	private String bankCardNo;//银行卡号
	private String bankCode;//开户行代码
	private String bankName;//开户行名称
	private String bankProvince;//开户行所在省
	private String bankCity;//开户行所在城市
	private String branchName;//开户行支行名称
	private Integer isBinded;//是否当前绑定（0：否，1：是）
	private Date bindTime;//绑定时间
	private Integer validStatus;//有效状态（0：无效卡，1：有效卡）
 };
 */

@interface BindedBankCard : BaseArchiveModel

//  主键ID
@property (nonatomic,copy)NSString *idd;
//  绑卡用户ID
@property (nonatomic,copy)NSString *userId;
//  真实姓名
@property (nonatomic,copy)NSString *realName;
//  身份证号码
@property (nonatomic,copy)NSString *idCardNo;
//  银行卡号
@property (nonatomic,copy)NSString *bankCardNo;
//  开户行代码
@property (nonatomic,copy)NSString *bankCode;
//  开户行名称
@property (nonatomic,copy)NSString *bankName;
//  开户行所在省
@property (nonatomic,copy)NSString *bankProvince;
//  开户行所在城市
@property (nonatomic,copy)NSString *bankCity;
//  开户行支行名称
@property (nonatomic,copy)NSString *branchName;
//  是否当前绑定（0：否，1：是）
@property (nonatomic,assign)int isBinded;
//  绑定时间
@property (nonatomic,assign)NSInteger bindTime;
//  有效状态（0：无效卡，1：有效卡）
@property (nonatomic,assign)int validStatus;

@end
