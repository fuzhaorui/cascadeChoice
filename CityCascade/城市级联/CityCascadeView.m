//
//  CityCascadeView.m
//  CityCascade
//
//  Created by IOS-开发机 on 15/11/25.
//  Copyright © 2015年 IOS-开发机. All rights reserved.
//



#import "CityCascadeView.h"

@implementation NSArray (Category)

-(id)returnTerm:(NSInteger)integer
{
    if (integer<self.count) {
        return self[integer];
    }
    return nil;
}
@end

@implementation NSDictionary (Category)

-(NSArray *)returnArray:(NSString *)key
{
    if (self[key] == nil) {
        return [[NSArray alloc]init];
    }
    return self[key];
}
@end

@interface CityCascadeView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@end

typedef NS_ENUM(NSInteger, FZRAnimationType) {
    /** 动画类型 修改frame */
    FZRAnimationTypeFrame,
    /** 动画类型 修改alpha */
    FZRAnimationTypeAlpha
    
} __TVOS_PROHIBITED;

 static  UIView              *_cityCoverView;
 static  UIView              *_cityView;
 static  UIPickerView        *_cityPickerView;
 static  UIButton            *_citySubmitButton;
 static  UIButton            *_cityCancelButton;
 static  NSArray             *_provinceArray;
 static  UITextField         *_textField;
 static  UIViewController    *_viewController;

@implementation CityCascadeView

///MARK: - 创建共享实例
+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static CityCascadeView *_cityCascadeView;
    dispatch_once(&once, ^{
        _cityCascadeView = [CityCascadeView new];
    });
    return _cityCascadeView;
}


///MARK: - textField显示选择控件   viewController将显示选择控件的视图控制器
-(void)chooseCity:(UITextField *)textField delegate:(UIViewController *)viewController
{
    _viewController = viewController;
    _textField = textField;
    
    if (!_cityCoverView) {
        [self createCityView];
    }
    
    [_viewController.view addSubview:_cityCoverView];
    [_viewController.view addSubview:_cityView];
    [_cityView setHidden:NO];
    [_cityCoverView setHidden:NO];
    
    
   
    
    [self addAnimation:_cityView andDuration:0.3 andDelay:0.1 andRect:CGRectMake( 0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 200) andAlpha:0 andAnimationType:FZRAnimationTypeFrame];
    
    [self addAnimation:_cityCoverView andDuration:0.4 andDelay:0 andRect:CGRectNull andAlpha:0.6 andAnimationType:FZRAnimationTypeAlpha];
}


///MARK: - 创建选择控件
-(void)createCityView
{
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    _provinceArray = [[NSArray alloc]initWithContentsOfFile:filename];
    
    
    _cityCoverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _cityCoverView.backgroundColor = [UIColor grayColor];
    _cityCoverView.alpha = 0;
    [_viewController.view addSubview:_cityCoverView];
    
    _cityView = [[UIView alloc]initWithFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    _cityView.backgroundColor = [UIColor whiteColor];
    [_cityView setHidden:YES];
    [_viewController.view addSubview:_cityView];
    
    _cityPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 40, [UIScreen mainScreen].bounds.size.width, 160)];
    _cityPickerView.delegate = self;
    _cityPickerView.dataSource  = self;
    _cityPickerView.showsSelectionIndicator = YES;
    [_cityView addSubview:_cityPickerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityCancelAction:)];
    [_cityCoverView addGestureRecognizer:tap];
    
    _cityCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2+0.6, 40)];
    [_cityCancelButton  setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
    [_cityCancelButton  setTitle:@"取消"   forState:UIControlStateNormal];
    _cityCancelButton.layer.borderColor = [UIColor blackColor]  .CGColor;
    _cityCancelButton.layer.borderWidth = 0.6;
    [_cityCancelButton addTarget:self action:@selector(cityCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    _cityCancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cityView addSubview:_cityCancelButton];
    
    _citySubmitButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
    [_citySubmitButton  setTitleColor:[UIColor blackColor]     forState:UIControlStateNormal];
    [_citySubmitButton  setTitle:@"确定"   forState:UIControlStateNormal];
    _citySubmitButton.layer.borderColor = [UIColor blackColor]  .CGColor;
    _citySubmitButton.layer.borderWidth = 0.6;
    [_citySubmitButton addTarget:self action:@selector(citySubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    _citySubmitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cityView addSubview:_citySubmitButton];
    
    
}



///MARK: - 确定选择
- (void)citySubmitAction:(UIButton *)sender
{
    
    NSInteger row1 = [_cityPickerView selectedRowInComponent:0];
    NSInteger row2 = [_cityPickerView selectedRowInComponent:1];
    NSInteger row3 = [_cityPickerView selectedRowInComponent:2];
    
    NSString *string =  _provinceArray[row1][@"provinceName"];
    NSArray *cityArray = _provinceArray[row1][@"cityArray"];
    if (row1<32) {
        
        string = [NSString stringWithFormat:@"%@ %@",string,cityArray[row2][@"cityName"]];
    }
    
     NSArray *areaArray = cityArray[row2][@"areaArray"];
    if (row1<31) {
       
        string = [NSString stringWithFormat:@"%@ %@",string,areaArray[row3][@"areaName"]];
    }
    
    
    _textField.text = string;
    [self cityCancelAction:_cityCancelButton];
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component==0) {
        
        [_cityPickerView reloadComponent:1];
        [_cityPickerView reloadComponent:2];
        
        [_cityPickerView selectRow:0 inComponent:1 animated:YES];
        [_cityPickerView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    else if (component==1)
    {
       
        [_cityPickerView reloadComponent:2];
        
        [_cityPickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    
    
}


///MARK: - 取消选择
- (void)cityCancelAction:(UIButton *)sender
{
    
    
    [self addAnimation:_cityView andDuration:0.3 andDelay:0.1 andRect:CGRectMake( 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) andAlpha:0 andAnimationType:FZRAnimationTypeFrame];
    
    [self addAnimation:_cityCoverView andDuration:0.4 andDelay:0 andRect:CGRectNull andAlpha:0 andAnimationType:FZRAnimationTypeAlpha];
    [self performSelector:@selector(hidden) withObject:self afterDelay:0.41];
}



///MARK: - 隐藏选择时间
-(void)hidden
{
    [_cityCoverView setHidden:YES];
    [_cityView setHidden:YES];
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
        return _provinceArray.count;
    }
    else
    {
        NSInteger row = [pickerView selectedRowInComponent:0];
        NSArray *cityArray = _provinceArray[row][@"cityArray"];
        if(component == 1)
        {
            return cityArray.count;
        }
        else if(component == 2)
        {
            NSInteger row1 = [pickerView selectedRowInComponent:1];
            NSArray *areaArray = cityArray[row1][@"areaArray"];
            return areaArray.count;
        }
    }
    return 0;
    
}



// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return [UIScreen mainScreen].bounds.size.width/3;
}



//显示级联的信息
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    
    
    UILabel *label  =[[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3, 20);
    
    
    //返回第一列的行数
    if (component == 0) {
        
        label.text = [_provinceArray returnTerm:row][@"provinceName"];
    }
    else
    {
        NSInteger row1 = [pickerView selectedRowInComponent:0];
        NSArray *cityArray = [_provinceArray[row1] returnArray:@"cityArray"];
        if(component == 1)
        {
            label.text = [cityArray returnTerm:row][@"cityName"];
            
        }
        else if(component == 2)
        {
            NSInteger row2 = [pickerView selectedRowInComponent:1];
            if (row2<cityArray.count) {
                NSArray *areaArray = [cityArray[row2] returnArray:@"areaArray"];
                label.text = [areaArray returnTerm:row][@"areaName"];
            }
            
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


