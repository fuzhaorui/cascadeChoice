//
//  FZRChooseHeight.h
//  CityCascade
//
//  Created by fuzhaurui on 16/10/12.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FZRChooseHeightDelegate <NSObject>

@optional
- (void)chooseHeight:(NSString *)heightString;

@end

@interface FZRChooseHeight : NSObject
@property (strong ,nonatomic) id<FZRChooseHeightDelegate>delegate;



///MARK: - 创建共享实例
+ (instancetype)shareInstance;


///MARK: - viewController将显示选择控件的视图控制器
-(void)chooseHeightDelegate:(id<FZRChooseHeightDelegate>)delegate;
@end
