//
//  FZRChooseHeight.m
//  CityCascade
//
//  Created by fuzhaurui on 16/10/12.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//

#import "FZRChooseHeight.h"

@interface FZRChooseHeight ()<UIPickerViewDelegate,UIPickerViewDataSource>
@end

typedef NS_ENUM(NSInteger, FZRAnimationType) {
    /** 动画类型 修改frame */
    FZRAnimationTypeFrame,
    /** 动画类型 修改alpha */
    FZRAnimationTypeAlpha
    
} __TVOS_PROHIBITED;


static  UIView              *_heightCoverView;
static  UIView              *_heightView;
static  UIPickerView        *_heightPickerView;
static  UIButton            *_heightSubmitButton;
static  UIButton            *_heightCancelButton;
static  NSMutableArray      *_showTime;

static  UIViewController    *_viewController;

@implementation FZRChooseHeight

///MARK: - 创建共享实例
+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static FZRChooseHeight *_cityCascadeView;
    dispatch_once(&once, ^{
        _cityCascadeView = [FZRChooseHeight new];
    });
    return _cityCascadeView;
}

///MARK: - textField显示选择控件
-(void)chooseHeightDelegate:(id<FZRChooseHeightDelegate>)delegate;
{
    _viewController = (UIViewController *)delegate;
    self.delegate = delegate;
    
    
    if (!_heightCoverView) {
        [self createDateView];
    }
    
    [_viewController.view addSubview:_heightCoverView];
    [_viewController.view addSubview:_heightView];
    [_heightView setHidden:NO];
    [_heightCoverView setHidden:NO];
    
    [self addAnimation:_heightView andDuration:0.3 andDelay:0.1 andRect:CGRectMake( 0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 200) andAlpha:0 andAnimationType:FZRAnimationTypeFrame];
    
    [self addAnimation:_heightCoverView andDuration:0.4 andDelay:0 andRect:CGRectNull andAlpha:0.6 andAnimationType:FZRAnimationTypeAlpha];
}

///MARK: - 创建视图
-(void)createDateView
{
    
    _heightCoverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _heightCoverView.backgroundColor = [UIColor grayColor];
    _heightCoverView.alpha = 0;
    [_viewController.view addSubview:_heightCoverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelAction:)];
    [_heightCoverView addGestureRecognizer:tap];
    
    _heightView = [[UIView alloc]initWithFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    _heightView.backgroundColor = [UIColor whiteColor];
    [_heightView setHidden:YES];
    [_viewController.view addSubview:_heightView];
    
    
    
    _heightPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake( 0, 40, [UIScreen mainScreen].bounds.size.width, 160)];
    _heightPickerView.delegate = self;
    _heightPickerView.dataSource  = self;
    _heightPickerView.showsSelectionIndicator = YES;
    [_heightPickerView selectRow:110 inComponent:0 animated:YES];
    [_heightView addSubview:_heightPickerView];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2+30, _heightPickerView.frame.size.height/2-10, 100, 20)];
    label.userInteractionEnabled = NO;
    label.text = @"cm";
    [_heightPickerView addSubview:label];
    
    
    _heightCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2+0.6, 40)];
    [_heightCancelButton  setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
    [_heightCancelButton  setTitle:@"取消"   forState:UIControlStateNormal];
    _heightCancelButton.layer.borderColor = [UIColor blackColor]  .CGColor;
    _heightCancelButton.layer.borderWidth = 0.6;
    [_heightCancelButton addTarget:self action:@selector(dateCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    _heightCancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_heightView addSubview:_heightCancelButton];
    
    _heightSubmitButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
    [_heightSubmitButton  setTitleColor:[UIColor blackColor]     forState:UIControlStateNormal];
    [_heightSubmitButton  setTitle:@"确定"   forState:UIControlStateNormal];
    _heightSubmitButton.layer.borderColor = [UIColor blackColor]  .CGColor;
    _heightSubmitButton.layer.borderWidth = 0.6;
    [_heightSubmitButton addTarget:self action:@selector(dateSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    _heightSubmitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_heightView addSubview:_heightSubmitButton];
    
    
}







///MARK: - 确定选择
- (void)dateSubmitAction:(UIButton *)sender
{
    
    NSInteger row = [_heightPickerView selectedRowInComponent:0];
    
    [self dateCancelAction:_heightCancelButton];

    ///MARK: - 代理传值
    [self.delegate chooseHeight: [NSString stringWithFormat:@"%ld",(long)row + 50]];
    
}




///MARK: - 取消选择
- (void)dateCancelAction:(UIButton *)sender
{
    
    
    [self addAnimation:_heightView andDuration:0.3 andDelay:0.1 andRect:CGRectMake( 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) andAlpha:0 andAnimationType:FZRAnimationTypeFrame];
    
    [self addAnimation:_heightCoverView andDuration:0.4 andDelay:0 andRect:CGRectNull andAlpha:0 andAnimationType:FZRAnimationTypeAlpha];
    
    [self performSelector:@selector(hidden) withObject:self afterDelay:0.41];
    
}





///MARK: - 隐藏选择
-(void)hidden
{
    [_heightCoverView setHidden:YES];
    [_heightView setHidden:YES];
}





///MARK: - UIPickerView代理
//返回列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回行数
//component  是列数序号
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return 171;
    
}


//显示级联的信息

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label  =[[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%ld",(long)row + 50];
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
