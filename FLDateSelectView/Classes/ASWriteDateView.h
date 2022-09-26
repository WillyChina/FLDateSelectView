//
//  ASWriteDateView.h
//  Headache
//
//  Created by liweiwei on 2022/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASWriteDateView : UIView
@property (nonatomic, copy)void(^lastAction)(void);
@property (nonatomic, copy)void(^startDateAction)(void);
@property (nonatomic, copy)void(^endDateAction)(void);
@property (nonatomic, copy)void(^cancellAction)(void);
@property (nonatomic, copy)void(^sureAction)(NSString *startDate,NSString *endDate);
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@end

NS_ASSUME_NONNULL_END
