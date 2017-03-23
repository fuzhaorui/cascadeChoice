//
//  CityCascadeView.h
//  CityCascade
//
//  Created by IOS-开发机 on 15/11/25.
//  Copyright © 2015年 IOS-开发机. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCascadeView : UIView


///MARK: - 创建共享实例
+ (instancetype)shareInstance;

///MARK: - textField显示选择控件   viewController将显示选择控件的视图控制器
-(void)chooseCity:(UITextField *)textField delegate:(UIViewController *)viewController;
@end
