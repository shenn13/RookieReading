//
//  UserAccount.h
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"

/*
userBankCardList =     (
    private Integer userId;//用户ID
	private BigDecimal totalAmount;//账户资金总额
	private BigDecimal balanceAmount;//账户总余额
	private BigDecimal frozenAmount;//账户冻结资金总额
	private BigDecimal drawAmount;//账户可提现总额
	private Date createTime;//创建时间
	private Date updateTime;//更新时间
);
*/

@interface UserAccount : BaseArchiveModel

//  用户ID
@property (nonatomic,copy)NSString *userId;
//  账户资金总额
@property (nonatomic,assign)double totalAmount;
//  账户总余额
@property (nonatomic,assign)double balanceAmount;
//  账户冻结资金总额
@property (nonatomic,assign)double frozenAmount;
//  账户可提现总额
@property (nonatomic,assign)double drawAmount;
//  创建时间
@property (nonatomic,assign)NSInteger createTime;
//  更新时间
@property (nonatomic,assign)NSInteger updateTime;

@end
