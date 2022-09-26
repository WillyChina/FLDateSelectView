//
//  ASLDatePickerView.h
//  Headache
//
//  Created by liweiwei on 2022/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ASLDatePickerView;
@protocol ASLDatePickerViewDelegate<NSObject>
-(void)dateViewDidClicked:(ASLDatePickerView *)dateView;
-(void)dateViewDidCancel:(ASLDatePickerView *)dateView;

@end

@interface ASLDatePickerView : UIView
@property (nonatomic, assign) id<ASLDatePickerViewDelegate> delegate;
@property (nonatomic, strong) NSString * dateString;
@property (nonatomic, copy)void(^sureAction)(NSString *startDate,NSString *endDate);
-(void)showInView:(UIView *)aView animated:(BOOL)animated;
@end

@interface UIView(Category)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@end

NS_ASSUME_NONNULL_END
