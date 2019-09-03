//
//  EXOCRCardEngineManager.h
//  ExCardSDK
//
//  Created by kubo on 16/9/6.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXOCRCardEngineManager : NSObject
/**
 *	@brief  初始化识别引擎（常规版本）
 *  @return YES-初始化成功，NO-初始化失败
 *
 *	@discussion 与释放识别引擎方法成对调用
 *              初始化识别引擎后，可反复调用识别（直至释放识别引擎），无需每次识别前调用该方法
 */
+(BOOL)initEngine;

/**
 *	@brief  初始化识别引擎（远程下载字典版本）
 *  @return YES-初始化成功，NO-初始化失败
 *  @param  dictPath - 字典文件路径
 *
 *	@discussion 与释放识别引擎方法成对调用
 *              初始化识别引擎后，可反复调用识别（直至释放识别引擎），无需每次识别前调用该方法
 */
+(BOOL)initEngine:(NSString *)dictPath;

/**
 *	@brief 释放识别引擎
 *
 *	@discussion 与初始化识别引擎方法成对调用
 */
+(void)finishEngine;

/**
 *	@brief  获取sdk版本号
 *  @return sdk版本号
 */
+(NSString *)getSDKVersion;

/**
 *	@brief  获取识别核心版本号
 *  @return 识别核心版本号
 */
+(NSString *)getKernelVersion;
@end
