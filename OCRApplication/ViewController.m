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
    CGFloat lastY = navHeight+50;
    UIView *idcardView = [[UIView alloc] initWithFrame:CGRectMake(0,lastY, SCREEN_WIDTH * 0.9,60)];
    [idcardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)]];
    [idcardView setBackgroundColor:UIColorFromRGBA(0xFFB943,1)];
    idcardView.center = CGPointMake(SCREEN_WIDTH/2, lastY+10);
    idcardView.layer.cornerRadius = 5.0;
    idcardView.tag = 1;
    idcardView.clipsToBounds = YES;
    [self.view addSubview:idcardView];
    
    UILabel *idcardLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    idcardLb.text = @"身份证识别";
    idcardLb.textColor = [UIColor whiteColor];
    idcardLb.textAlignment = NSTextAlignmentCenter;
    idcardLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:22.0];
    idcardLb.center = CGPointMake(idcardView.frame.size.width/2 - 20, idcardView.frame.size.height / 2);
    [idcardView addSubview:idcardLb];
    
    UIImageView *idcardArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    idcardArrow.image = [UIImage imageNamed:@"btn_arrow"];
    idcardArrow.center = CGPointMake(idcardView.frame.size.width - 40, idcardView.frame.size.height / 2);
    [idcardView addSubview:idcardArrow];
   
    UIView *bankcardView = [[UIView alloc] initWithFrame:CGRectMake(0,lastY + 80, SCREEN_WIDTH * 0.9,60)];
    [bankcardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)]];
    [bankcardView setBackgroundColor:UIColorFromRGBA(0xD5C09F,1)];
    bankcardView.tag = 2;
    bankcardView.center = CGPointMake(SCREEN_WIDTH/2, lastY+90);
    bankcardView.userInteractionEnabled = YES;
    bankcardView.layer.cornerRadius = 5.0;
    bankcardView.clipsToBounds = YES;
    [self.view addSubview:bankcardView];
    
    UILabel *bankcardLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    bankcardLb.text = @"银行卡识别";
    bankcardLb.textColor = [UIColor whiteColor];
    bankcardLb.textAlignment = NSTextAlignmentCenter;
    bankcardLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:22.0];
    bankcardLb.center = CGPointMake(bankcardView.frame.size.width/2 - 20, bankcardView.frame.size.height / 2);
    [bankcardView addSubview:bankcardLb];
    
    UIImageView *bankcardArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    bankcardArrow.image = [UIImage imageNamed:@"btn_arrow"];
    bankcardArrow.center = CGPointMake(bankcardView.frame.size.width - 40, bankcardView.frame.size.height / 2);
    [bankcardView addSubview:bankcardArrow];
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
