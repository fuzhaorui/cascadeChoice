//
//  TimeChoose.h
//  FZR_Date
//
//  Created by IOS-开发机 on 15/11/9.
//  Copyright © 2015年 IOS-开发机. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FZRTeturnTimeType) {
    /** 返回时间样式 2015-11-11 */
    FZRTeturnTimeOne,
    /** 返回时间样式 2015-11 */
    FZRTeturnTimeTwo,
    /** 返回时间样式 11-11 */
    FZRTeturnTimeThree,
    /** 返回时间样式 2015年11月11日 */
    FZRTeturnTimeFour,
    /** 返回时间样式 2015年11月 */
    FZRTeturnTimeFive,
    /** 返回时间样式 11月11日 */
    FZRTeturnTimeSix,
    /** 返回时间样式 11月11日 星期一 */
    FZRTeturnTimeSeven
    
} __TVOS_PROHIBITED;

@interface TimeChoose : NSObject

+(NSMutableArray *)timeChoose:(int)number andType:(FZRTeturnTimeType)type;
@end
