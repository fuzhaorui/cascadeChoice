//
//  TimeChoose.m
//  FZR_Date
//
//  Created by IOS-开发机 on 15/11/9.
//  Copyright © 2015年 IOS-开发机. All rights reserved.
//

#import "TimeChoose.h"

@implementation TimeChoose
+(NSMutableArray *)timeChoose:(int)number andType:(FZRTeturnTimeType)type
{
    NSMutableArray *timeArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<number; i++) {
        NSDate *senddate=[NSDate date];
        senddate = [senddate dateByAddingTimeInterval:86400*i];
        
        NSLog(@"%@",senddate);
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        if (type == FZRTeturnTimeSeven)
        {
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:senddate];
            
            NSInteger weekday = [weekdayComponents weekday];
            NSString *week;
            if (weekday==1) {
                week = @"星期天";
            }
            else if(weekday == 2)
            {
                week = @"星期一";
            }
            else if(weekday == 3)
            {
                week = @"星期二";
            }
            else if(weekday == 4)
            {
                week = @"星期三";
            }
            else if(weekday == 5)
            {
                week = @"星期四";
            }
            else if(weekday == 6)
            {
                week = @"星期五";
            }
            else if(weekday == 7)
            {
                week = @"星期六";
            }
            [dateformatter setDateFormat:@"MM月dd日"];
            
            [timeArray addObject:[NSString stringWithFormat:@"%@ %@",[dateformatter stringFromDate:senddate],week]];
        }
        else
        {
            if (type == FZRTeturnTimeOne) {
                [dateformatter setDateFormat:@"YYYY-MM-dd"];
                
            }
            else if (type == FZRTeturnTimeTwo) {
                [dateformatter setDateFormat:@"YYYY-MM"];
                
            }
            else if (type == FZRTeturnTimeThree) {
                [dateformatter setDateFormat:@"MM-dd"];
                
            }
            else if (type == FZRTeturnTimeFour) {
                [dateformatter setDateFormat:@"YYYY年MM月dd日"];
                
            }
            else if (type == FZRTeturnTimeFive) {
                [dateformatter setDateFormat:@"YYYY年MM月"];
                
            }
            else if (type == FZRTeturnTimeSix) {
                [dateformatter setDateFormat:@"MM月dd日"];
                
            }
            [timeArray addObject:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:senddate]]];
        }
        
        
    }
    return timeArray;
}
@end
