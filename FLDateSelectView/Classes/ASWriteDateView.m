//
//  ASWriteDateView.m
//  Headache
//
//  Created by liweiwei on 2022/4/24.
//

#import "ASWriteDateView.h"
#import "UUDatePicker.h"

@interface ASWriteDateView ()<UUDatePickerDelegate>{
    
}
@property(nonatomic,strong)UUDatePicker *datePicker;
@property(nonatomic,copy)NSString *startDateStr;
@property(nonatomic,copy)NSString *endDateStr;
@property(nonatomic,assign)BOOL isStart;
@property (nonatomic, assign)NSInteger index;
@end

@implementation ASWriteDateView

-(void)changeIndex{
    _index++;
}

- (IBAction)backAction:(UIButton *)sender {
    self.hidden = YES;
    self.lastAction();
}

- (IBAction)startDateClick:(UIButton *)sender {
    _isStart = YES;
    _index = 0;
    [self performSelector:@selector(changeIndex) withObject:nil afterDelay:1];
    [self addSubview:self.datePicker];

}

- (IBAction)endDateClick:(UIButton *)sender {
    _isStart = NO;
    _index = 0;
    [self performSelector:@selector(changeIndex) withObject:nil afterDelay:1];
    [self addSubview:self.datePicker];
}

- (IBAction)cancellClick:(UIButton *)sender {
    self.hidden = YES;
    self.cancellAction();
}

- (IBAction)sureClick:(UIButton *)sender {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *currentStr = [formatter stringFromDate:[NSDate date]];
    
    if (![self.startDateStr containsString:@"."]) {
        [SVProgressHUD showErrorWithStatus:@"请选择起始日期"];
        return;
    }
    
    if (![self.endDateStr containsString:@"."]) {
        [SVProgressHUD showErrorWithStatus:@"请选择截止日期"];
        return;
    }
    
    BOOL right = [self compareDate:self.startDateStr withDate:currentStr toDateFormat:@"yyyy.MM.dd"];
    if (!right) {
        [SVProgressHUD showErrorWithStatus:@"起始日期不能晚于当前日期"];
        return;
    }
    
    right = [self compareDate:self.endDateStr withDate:currentStr toDateFormat:@"yyyy.MM.dd"];
    if (!right) {
        [SVProgressHUD showErrorWithStatus:@"截止日期不能晚于当前日期"];
        return;
    }
    
    right = [self compareDate:self.startDateStr withDate:self.endDateStr toDateFormat:@"yyyy.MM.dd"];
    if (!right) {
        [SVProgressHUD showErrorWithStatus:@"截止日期不能早于起始日期"];
        return;
    }
    
    self.hidden = YES;
    self.sureAction(self.startDateStr, self.endDateStr);
}

- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay{
    
    if (self.datePicker.canChange) {
        
        if (_isStart) {
            self.startDateStr = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
            [self.startBtn setTitle:[NSString stringWithFormat:@"%@                                   ",self.startDateStr] forState:UIControlStateNormal];
        }else{
            self.endDateStr= [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
            [self.endBtn setTitle:[NSString stringWithFormat:@"%@                                    ",self.endDateStr] forState:UIControlStateNormal];
        }
        
    }
   
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


- (void)awakeFromNib{
    [super awakeFromNib];
    self.datePicker = [[UUDatePicker alloc]initWithframe:self.frame Delegate:self PickerStyle:UUDateStyle_YearMonthDay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
