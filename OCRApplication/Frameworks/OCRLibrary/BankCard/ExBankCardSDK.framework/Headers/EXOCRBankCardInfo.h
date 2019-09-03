//
//  EXOCRBankCardInfo.h
//  ExBankCardSDK
//
//  Created by kubo on 16/9/2.
//  Copyright © 2015年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *	@brief 银行卡识别回调状态码
 *
 *	@discussion 识别回调中获取状态码
 */
#define BANK_CODE_SUCCESS           (0)
#define BANK_CODE_CANCEL            (1)
#define BANK_CODE_FAIL              (-1)
#define BANK_CODE_FAIL_TIMEOUT      (-2)

/**
 *	@brief 银行卡数据模型类
 */
@interface EXOCRBankCardInfo : NSObject

@property (nonatomic, strong) NSString *bankName;   //银行名称
@property (nonatomic, strong) NSString *cardName;   //卡名称
@property (nonatomic, strong) NSString *cardType;   //卡类型
@property (nonatomic, strong) NSString *cardNum;    //卡号
@property (nonatomic, strong) NSString *validDate;  //有限期

@property (nonatomic, strong) UIImage *fullImg;     //银行卡全图
@property (nonatomic, strong) UIImage *cardNumImg;  //银行卡号截图

-(NSString *)toString;

@end
