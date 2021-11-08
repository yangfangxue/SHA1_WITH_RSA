//
//  ViewController.m
//  iOSDemo
//
//  Created by 杨芳学 on 2021/6/11.

#import "ViewController.h"
#import "TYENetworking.h"
#import "TYECalculatorView.h"
#import "TYESetHostUrlViewController.h"



@interface ViewController ()

@property (nonatomic, strong) TYECalculatorView *calculatorView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutNavView];
    [self layoutUI];
}
#pragma mark - UI
- (void)layoutNavView {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"我的计算器" forState:0];
    [leftButton setTitleColor:[UIColor blackColor] forState:0];
    leftButton.bounds = CGRectMake(0, 0, 60.f, 44.f);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton addTarget:self action:@selector(go2SetVC:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:@"设置" forState:0];
    [settingButton setTitleColor:[UIColor blackColor] forState:0];
    settingButton.bounds = CGRectMake(0, 0, 36.f, 44.f);
    settingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [settingButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
}
- (void)layoutUI {
    
    [self.view addSubview:self.calculatorView];
}
#pragma mark - Action

- (void)go2SetVC:(UIButton *)sender {
    
    TYESetHostUrlViewController *vc = [[TYESetHostUrlViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 懒加载

- (TYECalculatorView *)calculatorView {
    if (!_calculatorView) {
        _calculatorView = [[[NSBundle mainBundle] loadNibNamed:@"TYECalculatorView" owner:self options:nil] lastObject];
        _calculatorView.frame = self.view.frame;
    }
    return _calculatorView;
}








@end
