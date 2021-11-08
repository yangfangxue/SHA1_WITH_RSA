//
//  TYESetHostUrlViewController.m
//  iOSDemo
//
//  Created by 杨芳学 on 2021/6/11.
//

#import "TYESetHostUrlViewController.h"
#import "TYENetworking.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface TYESetHostUrlViewController ()

@property (nonatomic, strong) UITextField *hostUrlTextField;

@end

@implementation TYESetHostUrlViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.hostUrlTextField.text.length > 0) {
       [TYENetworking sharedManager].hostUrl = self.hostUrlTextField.text;
    }else {
        [SVProgressHUD showErrorWithStatus:@"请务必设置HostUrl"];
        [SVProgressHUD dismissWithDelay:1.5f];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置HOST URL";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
}

#pragma mark UI

- (void) layoutUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    titleLabel.frame = CGRectMake(30, 150, kScreenWidth - 60, 50);
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"请输入服务器IP，如(192.168.0.110) \n 端口号已默认设置8080无需输入";
    
    self.hostUrlTextField = [[UITextField alloc] init];
    [self.view addSubview:self.hostUrlTextField];
    self.hostUrlTextField.frame = CGRectMake(30, 210, kScreenWidth - 40, 30);
    self.hostUrlTextField.textAlignment = NSTextAlignmentLeft;
    self.hostUrlTextField.returnKeyType = UIReturnKeyDefault;
    self.hostUrlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.hostUrlTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.hostUrlTextField.layer.borderWidth = 1.0f;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
