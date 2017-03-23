//
//  ViewController.m
//  CityCascade
//
//  Created by IOS-开发机 on 15/11/24.
//  Copyright © 2015年 IOS-开发机. All rights reserved.
//

#import "ViewController.h"
#import "CityCascadeView.h"
#import "SelectedDateView.h"
#import "FZRChooseHeight.h"

@interface ViewController ()<FZRChooseHeightDelegate>
{
    UITextField *_textField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag ==1000) {
        [[SelectedDateView shareInstance] chooseTime:textField delegate:self];
    }
    else if (textField.tag ==1001)
    {
        [[CityCascadeView shareInstance] chooseCity:textField delegate:self];
    }
    else
    {
//        [[ChooseHeight shareInstance] chooseHeight:textField delegate:self];
        [[FZRChooseHeight shareInstance] chooseHeightDelegate:self];
        _textField = textField;
    }
    
    return NO;
}


///MARK: - 接受传值
-(void)chooseHeight:(NSString *)heightString
{
    _textField.text = heightString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
