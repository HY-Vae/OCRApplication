//
//  ViewController.m
//  OCRApplication
//
//  Created by 李志刚 on 2019/9/3.
//  Copyright © 2019 李志刚. All rights reserved.
//

#import "ViewController.h"

#import "KKIDCardOCRViewController.h"
#import "KKBankCardOCRViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configNavigationBarStyle];
}

///配置导航栏样式
- (void)configNavigationBarStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item; 
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if (iOS7Later) {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    } 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"OCR识别";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
}

- (void)configUI {
    CGFloat navHeight = STATUS_BAR_HEIGHT+NAV_BAR_HIGHT;
    CGFloat lastY = navHeight + 50;
    
    UIImageView *idcardImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 245, 166)];
    [idcardImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)]];
    idcardImgView.userInteractionEnabled = YES;
    idcardImgView.tag = 1;
    idcardImgView.image = [UIImage imageNamed:@"IdCardImg1"];
    idcardImgView.center = CGPointMake(self.view.frame.size.width / 2, lastY + 100);
    [self.view addSubview:idcardImgView];
    
    UILabel *idcardLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    idcardLb.text = @"身份证识别";
    idcardLb.textColor = [UIColor lightGrayColor];
    idcardLb.textAlignment = NSTextAlignmentCenter;
    idcardLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    idcardLb.center = CGPointMake(self.view.frame.size.width / 2, lastY + 200);
    [self.view addSubview:idcardLb];
    
    lastY+= 250;
   
    UIImageView *bankcardImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 245, 166)];
    [bankcardImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)]];
    bankcardImgView.userInteractionEnabled = YES;
    bankcardImgView.tag = 2;
    bankcardImgView.image = [UIImage imageNamed:@"BankCardImg"];
    bankcardImgView.center = CGPointMake(self.view.frame.size.width / 2, lastY + 100);
    [self.view addSubview:bankcardImgView];
    
    UILabel *bankcardLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    bankcardLb.text = @"银行卡识别";
    bankcardLb.textColor = [UIColor lightGrayColor];
    bankcardLb.textAlignment = NSTextAlignmentCenter;
    bankcardLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    bankcardLb.center = CGPointMake(self.view.frame.size.width / 2, lastY + 200);
    [self.view addSubview:bankcardLb];
}

- (void)jumpAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    if(index == 1) {
        KKIDCardOCRViewController *IdCardVC = [[KKIDCardOCRViewController alloc]init];
        [self.navigationController pushViewController:IdCardVC animated:YES];
    } else {
        KKBankCardOCRViewController *BankCardVC = [[KKBankCardOCRViewController alloc]init];
        [self.navigationController pushViewController:BankCardVC animated:YES];
    }
}

@end
