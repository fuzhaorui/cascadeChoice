//
//  SelectedDateView.m
//  CityCascade
//
//  Created by IOS-开发机 on 15/11/25.
//  Copyright © 2015年 IOS-开发机. All rights reserved.
//

#import "SelectedDateView.h"
#import "TimeChoose.h"



@interface SelectedDateView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@end

typedef NS_ENUM(NSInteger, FZRAnimationType) {
    /** 动画类型 修改frame */
    FZRAnimationTypeFrame,
    /** 动画类型 修改alpha */
    FZRAnimationTypeAlpha
    
} __TVOS_PROHIBITED;


 static  UIView              *_deteCoverView;
 static  UIView              *_dateView;
 static  UIPickerView        *_datePickerView;
 static  UIButton            *_dateSubmitButton;
 static  UIButton            *_dateCancelButton;
 static  NSMutableArray      *_showTime;
 static  UITextField         *_timeTextField;
 static  UIViewController    *_viewController;

@implementation SelectedDateView


///MARK: - 创建共享实例
+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static SelectedDateView *_cityCascadeView;
    dispatch_once(&once, ^{
        _cityCascadeView = [SelectedDateView new];
    });
    return _cityCascadeView;
}


///MARK: - textField显示选择控件   viewController将显示选择控件的视图控制器
-(void)chooseTime:(UITextField *)textField delegate:(UIViewController *)viewController
{
    _viewController = viewController;
    _timeTextField = textField;
    
    
    if (!_deteCoverView) {
        [self createDateView];
    }
    
    [_viewController.view addSubview:_deteCoverView];
    [_viewController.view addSubview:_dateView];
    [_dateView setHidden:NO];
    [_deteCoverView setHidden:NO];
    
    [self addAnimation:_dateView andDuration:0.3 andDelay:0.1 andRect:CGRectMake( 0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 200) andAlpha:0 andAnimationType:FZRAnimationTypeFrame];
    
    [self addAnimation:_deteCoverView andDuration:0.4 andDelay:0 andRect:CGRectNull andAlpha:0.6 andAnimationType:FZRAnimationTypeAlpha];
}

///MARK: - 创建选择控件
-(void)createDateView
{
    
    _showTime = [TimeChoose timeChoose:30 andType:FZRTeturnTimeFour];
    
    _deteCoverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _deteCoverView.backgroundColor = [UIColor grayColor];
    _deteCoverView.alpha = 0;
    [_viewController.view addSubview:_deteCoverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelAction:)];
    [_deteCoverView addGestureRecognizer:tap];
    
    _dateView = [[UIView alloc]initWithFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    _dateView.backgroundColor = [UIColor whiteColor];
    [_dateView setHidden:YES];
    [_viewController.view addSubview:_dateView];
    
    
    
    _datePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 40, [UIScreen mainScreen].bounds.size.width, 160)];
    _datePickerView.delegate = self;
    _datePickerView.dataSource  = self;
    _datePickerView.showsSelectionIndicator = YES;
    [_dateView addSubview:_datePickerView];
    
    _dateCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2+0.6, 40)];
    [_dateCancelButton  setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
    [_dateCancelButton  setTitle:@"取消"   forState:UIControlStateNormal];
    _dateCancelButton.layer.borderColor = [UIColor blackColor]  .CGColor;
    _dateCancelButton.layer.borderWidth = 0.6;
    [_dateCancelButton addTarget:self action:@selector(dateCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    _dateCancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dateView addSubview:_dateCancelButton];
    
    _dateSubmitButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
    [_dateSubmitButton  setTitleColor:[UIColor blackColor]     forState:UIControlStateNormal];
    [_dateSubmitButton  setTitle:@"确定"   forState:UIControlStateNormal];
    _dateSubmitButton.layer.borderColor = [UIColor blackColor]  .CGColor;
    _dateSubmitButton.layer.borderWidth = 0.6;
    [_dateSubmitButton addTarget:self action:@selector(dateSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    _dateSubmitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dateView addSubview:_dateSubmitButton];
    
    
}







///MARK: - 确定选择时间
- (void)dateSubmitAction:(UIButton *)sender
{
    NSInteger row1 = [_datePickerView selectedRowInComponent:0];
    NSInteger row2 = [_datePickerView selectedRowInComponent:1];
    NSInteger row3 = [_datePickerView selectedRowInComponent:2];
    
    
    NSString *hours;
    if (row2<9) {
        hours = [NSString stringWithFormat:@"0%d",(int)row2];
    }
    else
    {
        hours = [NSString stringWithFormat:@"%d",(int)row2];
    }
    NSString  *minutes;
    if (row3<2) {
        minutes = [NSString stringWithFormat:@"0%d",(int)row3*5];
    }
    else
    {
        minutes = [NSString stringWithFormat:@"%d",(int)row3*5];
        
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *timeString = [NSString stringWithFormat:@"%@ %@:%@",_showTime[row1],hours,minutes];
    NSDate *date = [dateFormatter dateFromString:timeString];
    NSDate *chooseDate = [date dateByAddingTimeInterval:28800];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:28800];
    NSDate *earlyDate = [nowDate dateByAddingTimeInterval:1800];
    NSLog(@"%@ %@",earlyDate,date);
    
    NSTimeInterval time = [chooseDate compare:earlyDate];
    if(time==-1)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"到店时间必须大于当前时间30分钟"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }
    else
    {
        [self dateCancelAction:_dateCancelButton];
        _timeTextField.text = timeString;
    }
    
    
}




///MARK: - 取消选择时间
- (void)dateCancelAction:(UIButton *)sender
{
    
    
    [self addAnimation:_dateView andDuration:0.3 andDelay:0.1 andRect:CGRectMake( 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) andAlpha:0 andAnimationType:FZRAnimationTypeFrame];
    
    [self addAnimation:_deteCoverView andDuration:0.4 andDelay:0 andRect:CGRectNull andAlpha:0 andAnimationType:FZRAnimationTypeAlpha];
    [self performSelector:@selector(hidden) withObject:self afterDelay:0.41];
}





///MARK: - 隐藏选择时间
-(void)hidden
{
    [_deteCoverView setHidden:YES];
    [_dateView setHidden:YES];
}





///MARK: - UIPickerView代理
//返回列数

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//返回行数
//component  是列数序号
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    //返回第一列的行数
    if (component == 0) {
        return _showTime.count;
        
    }
    else if(component == 1)
    {
        return 24;
    }
    return 12;
    
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) {
        return 180;
    }
    
    return 60;
}

//显示级联的信息
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label  =[[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    if (component==0) {
        label.frame = CGRectMake(0, 0, 180, 20);
        
        if (row==0) {
            label.text =  @"今天";
        }
        else  if (row==1) {
            label.text = @"明天";
        }
        else
        {
            label.text = _showTime[row];
        }
    }
    else if (component==1) {
        label.frame = CGRectMake(0, 0, 60, 20);
        if (row<10) {
            label.text = [NSString stringWithFormat:@"0%d时",(int)row];
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%d时",(int)row];
        }
    }
    else if (component==2) {
        
        label.frame = CGRectMake(0, 0, 60, 20);
        if (row<2) {
            label.text = [NSString stringWithFormat:@"0%d分",(int)row*5];
        }
        else
        {
            label.text =  [NSString stringWithFormat:@"%d分",(int)row*5];
        }
    }
    return label;
    
}

///MARK: - 视图动画
-(void)addAnimation:(UIView *)view andDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andRect:(CGRect)rect andAlpha:(double)alpha andAnimationType:(FZRAnimationType)type
{
    //创建动画
    [UIView beginAnimations:nil context:nil];
    //动画时间
    [UIView setAnimationDuration:duration];
    //延迟时间
    [UIView setAnimationDelay:delay];
    if (type == FZRAnimationTypeFrame) {
        //移动后的位置
        view.frame = *(&rect);
    }
    else if(type == FZRAnimationTypeAlpha)
    {
        //改变后的alpha
        view.alpha = alpha;
    }
    //开始动画
    [UIView commitAnimations];
}

@end
