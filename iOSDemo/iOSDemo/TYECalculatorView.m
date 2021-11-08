//
//  TYECalculatorView.m
//  iOSDemo
//
//  Created by 杨芳学 on 2021/6/11.
//

#import "TYECalculatorView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TYENetworking.h"

@interface TYECalculatorView()

{
    
}

@end

@implementation TYECalculatorView

//方法
- (IBAction)methodType:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    if ([senderButton.currentTitle isEqualToString:@"="]) {
        NSArray *numberArray = [[NSArray alloc] init];
        NSString *method = @"";
        if ([_resultLabel.text containsString:@"%"]) {
            
            numberArray = [_resultLabel.text componentsSeparatedByString:@"%"];
            method = @"4";
            
        }else if ([_resultLabel.text containsString:@"*"]) {
            
            numberArray = [_resultLabel.text componentsSeparatedByString:@"*"];
            method = @"3";
        }
        else if ([_resultLabel.text containsString:@"-"]) {
            
            numberArray = [_resultLabel.text componentsSeparatedByString:@"-"];
            method = @"2";
        }
        else if ([_resultLabel.text containsString:@"+"]) {
            
            numberArray = [_resultLabel.text componentsSeparatedByString:@"+"];
            method = @"1";
        }
        if (method.length == 0) {
            return;
        }
        //HTTP请求计算
        [[TYENetworking sharedManager] requestWithType:1 urlString:@"/buss/op" parameters:@{@"opType":method,@"opl":numberArray[0],@"opr":numberArray[1]} showHUD:NO successBlock:^(id  _Nonnull responseObject, BOOL codeZero) {
            if (codeZero == 0) {
                NSDictionary *dic = responseObject;
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",dic]];
                [SVProgressHUD dismissWithDelay:2.0f];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultLabel.text = [NSString stringWithFormat:@"%@",dic[@"content"][@"opRt"]];
                });
            }
        } failureBlock:^(NSError * _Nonnull error) {
               
        }];
        
    }
    _resultLabel.text = [_resultLabel.text stringByAppendingString:senderButton.currentTitle];
}
//数字
- (IBAction)addNumber:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    _resultLabel.text = [_resultLabel.text stringByAppendingString:senderButton.currentTitle];
}

- (IBAction)clearResult:(id)sender {
    
    _resultLabel.text = @"";
}

- (IBAction)aliveTest:(id)sender {
    
    [[TYENetworking sharedManager] requestWithType:0 urlString:@"buss/alive" parameters:@{} showHUD:NO successBlock:^(id  _Nonnull responseObject, BOOL codeZero) {
        if (codeZero == 0) {
            NSDictionary *dic = responseObject;
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",dic]];
            [SVProgressHUD dismissWithDelay:2.0f];
        }
    } failureBlock:^(NSError * _Nonnull error) {
           
    }];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
