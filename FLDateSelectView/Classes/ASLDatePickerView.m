//
//  ASLDatePickerView.m
//  Headache
//
//  Created by liweiwei on 2022/4/22.
//

#import "ASLDatePickerView.h"
#import "ASWriteDateView.h"
@interface ASLDatePickerView ()<UIPickerViewDelegate>
{
    UILabel *dateLab;
    UIPickerView *picker;
    UIButton *cancelBtn;
    UIButton *sureBtn;
    NSMutableArray *dateArr;
}
@property (nonatomic, strong)UIView *dateContentView;
@property (nonatomic, strong)ASWriteDateView *writeDateView;
@end

@implementation ASLDatePickerView

-(void)initData{

    dateArr = [NSMutableArray arrayWithArray:@[@"7天内",@"30天内",@"60天内",@"90天内",@"其他"]];
}

- (void)initViews{
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=kRGBColor(0, 0, 0, 0.3);
    self.dateContentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-362, SCREENWIDTH, 362)];
    _dateContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_dateContentView];
    _dateContentView.layer.masksToBounds=YES;
    
    dateLab=[[UILabel alloc]initWithFrame:CGRectMake(24, 0, 100, 56)];
    dateLab.text = @"请选择时间";
    dateLab.font = Font(17);
    dateLab.textColor = [UIColor blackColor];
    [_dateContentView addSubview:dateLab];
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(20, dateLab.h, SCREENWIDTH-40, 168)];
    picker.delegate=self;
    [_dateContentView addSubview:picker];

    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(_dateContentView.w/2.0-116, picker.h+picker.y+32, 108, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:Color_hex(@"#0075A1") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC-Medium" size:17];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dateContentView addSubview:cancelBtn];
    cancelBtn.backgroundColor = Color_hex(@"#F7F7F7");
    cancelBtn.layer.cornerRadius = 4;
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_dateContentView.w/2.0+8, cancelBtn.y, 108, cancelBtn.h);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC-Medium" size:17];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dateContentView addSubview:sureBtn];
    sureBtn.backgroundColor = Color_hex(@"#0075A1");
    sureBtn.layer.cornerRadius = 4;
    
    UIView *bottomLine = [self lineView];
    bottomLine.frame = CGRectMake(30, picker.h+picker.y, SCREENWIDTH-60, 0.5);
    [_dateContentView addSubview:bottomLine];
    
    self.writeDateView = [[NSBundle mainBundle]loadNibNamed:@"ASWriteDateView" owner:self options:nil].lastObject;
    _writeDateView.frame = CGRectMake(0, SCREENHEIGHT-306, SCREENWIDTH, 306);
    ASHWeakSelf;
    _writeDateView.lastAction = ^{
        weakSelf.dateContentView.hidden = NO;
    };
    _writeDateView.cancellAction = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf fadeOut];
    };
    _writeDateView.sureAction = ^(NSString * _Nonnull startDate, NSString * _Nonnull endDate) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (startDate.length > 0 && endDate.length > 0) {
            BOOL right = [strongSelf compareDate:startDate withDate:endDate toDateFormat:@"yyyy.MM.dd"];
            if (right) {
                strongSelf.sureAction(startDate, endDate);
            }else{
                [SVProgressHUD showErrorWithStatus:@"起始日期不能大于终止日期"];
            }
            
        }
        [strongSelf fadeOut];
    };
    [self addSubview:self.writeDateView];
    _writeDateView.hidden = YES;
        
    if(@available(iOS 11.0, *)) {
        _dateContentView.layer.cornerRadius=12;
        _dateContentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        
        _writeDateView.layer.cornerRadius=12;
        _writeDateView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        
    }else{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_dateContentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12,12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _dateContentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _dateContentView.layer.mask = maskLayer;
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_writeDateView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12,12)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = _writeDateView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        _writeDateView.layer.mask = maskLayer1;
    }
    
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        [self initData];
        
        [picker selectRow:[self midNum:5] inComponent:0 animated:YES];
        self.dateString = @"7天内";
        
    }
    return self;
}

#pragma mark - pickerView delagate,datasource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSUInteger mid = 0;
    NSUInteger rowIndex = 0;
    if(component == 0){
        mid = [self midNum:(int)dateArr.count];
        rowIndex = row%dateArr.count;
        [picker selectRow:rowIndex+mid inComponent:0 animated:NO];
        self.dateString = dateArr[[picker selectedRowInComponent:0]%dateArr.count];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int count = 0;
    if(component == 0){
        count = (int)dateArr.count;
    }
    return count*50;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@",dateArr[row%dateArr.count]];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    [self changeSpearatorLineColor];
    
    UILabel *rowLab = [[UILabel alloc] init];
    rowLab.textAlignment = NSTextAlignmentCenter;
    rowLab.frame = CGRectMake(0, 0, _dateContentView.w, 56);
    [rowLab setFont:[UIFont systemFontOfSize:16]];
    if(component == 0){
        rowLab.text = [NSString stringWithFormat:@"%@",dateArr[row%dateArr.count]];
    }
    return rowLab;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component API_UNAVAILABLE(tvos){
    return 56;
}

    
#pragma mark - Public Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - 改变分割线的颜色 和 选中的背景色
- (void)changeSpearatorLineColor {
    
    for(UIView *speartorView in picker.subviews) {
 
        if (speartorView.frame.size.height < 80) {
            
            // 添加分割线 (判断只添加一次  滑动不断刷新)
            if (speartorView.subviews.count ==0){
                UIView *line = [self lineView];
                line.frame = CGRectMake(0, 0, speartorView.w, 0.5);
                [speartorView addSubview:line];
                
                UIView *line2 = [self lineView];
                line2.frame = CGRectMake(0, speartorView.h-1, speartorView.w, 0.5);
                [speartorView addSubview:line2];
            }
 
            speartorView.backgroundColor = [UIColor clearColor];
        }else{
            speartorView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (UIView *)lineView {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(30, 0, SCREENWIDTH-60, 0.5)];
    line.backgroundColor = Color_hexA(@"#000000", 0.1);
    return line;
}

#pragma mark - 渐进式显示/退出
- (void)fadeIn{
//    self.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
//        self.alpha = 1;
//    }];
    
}
- (void)fadeOut{
//    [UIView animateWithDuration:.35 animations:^{
//        self.alpha = 0.0;
//    }completion:^(BOOL finished) {
//        if (finished){
            [self removeFromSuperview];
//        }
//    }];
}

- (int)midNum:(int)arrCount{
    int mid = (arrCount*50/2)-(arrCount*50/2)%arrCount;
    return mid;
}

#pragma mark - delegate
- (void)sureAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateViewDidClicked:)]) {
        [self.delegate dateViewDidClicked:self];
    }
    if ([self.dateString containsString:@"其他"]) {
        _dateContentView.hidden = YES;
        _writeDateView.hidden = NO;
    }else{
        [self fadeOut];
    }
}
- (void)cancelAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateViewDidCancel:)]) {
        [self.delegate dateViewDidCancel:self];
    }
    [self fadeOut];
}

/**判断两个日期的大小

 *date01 : 第一个日期

 *date02 : 第二个日期

 *format : 日期格式 如：@"yyyy-MM-dd HH:mm"

 *return : 0（等于）1（小于）-1（大于）

 */

- (BOOL)compareDate:(NSString*)date01 withDate:(NSString*)date02 toDateFormat:(NSString*)format{

    int num;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd"];

    NSDate *dt01 = [[NSDate alloc]init];
    NSDate *dt02 = [[NSDate alloc]init];
    dt01 = [df dateFromString:date01];
    dt02 = [df dateFromString:date02];
    NSComparisonResult result = [dt01 compare:dt02];

    switch(result){

        case NSOrderedAscending: num=1;break;

        case NSOrderedDescending: num=-1;break;

        case NSOrderedSame: num=0;break;

        default:
            NSLog(@"erorr dates %@, %@", dt02, dt01);
            
        break;

    }
    if (num < 0) {
        return NO;
    }
    return YES;
}

@end
@implementation UIView (Category)

#pragma mark-- setter,getter方法(深度赋值，取值)
- (void) setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame=CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
    self.frame=frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void) setY:(CGFloat)y{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    self.frame=frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void) setW:(CGFloat)w{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height);
    self.frame=frame;
}
- (CGFloat)w{
    return self.frame.size.width;
}
- (void) setH:(CGFloat)h{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
    self.frame=frame;
}
- (CGFloat)h{
    return self.frame.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
