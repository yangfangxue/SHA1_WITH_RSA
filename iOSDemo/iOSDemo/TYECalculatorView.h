//
//  TYECalculatorView.h
//  iOSDemo
//
//  Created by 杨芳学 on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYECalculatorView : UIView


@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *additionMethod;

@property (strong, nonatomic) IBOutlet UIButton *rideMethod;

@property (strong, nonatomic) IBOutlet UIButton *reduceMethod;

@property (strong, nonatomic) IBOutlet UIButton *addMethod;

@property (strong, nonatomic) IBOutlet UIButton *equalMethod;



@end

NS_ASSUME_NONNULL_END
