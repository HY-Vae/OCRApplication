//
//  KKIDCardOCRViewController.m
//  OCRApplication
//
//  Created by 李志刚 on 2019/9/3.
//  Copyright © 2019 李志刚. All rights reserved.
//

#import "KKIDCardOCRViewController.h" 

@interface KKIDCardOCRViewController ()<UITextFieldDelegate, UITextViewDelegate>{
    UIImageView * frontFullImageView;
    UIImageView * backFullImageView;
    UIImageView * faceImageView;
    UILabel *frontShadowLabel;
    UILabel *backShadowLabel;
    
    UIView *frontBackground;
    
    UIView *frontBtnBackground;
    UILabel *frontBtnLabel;
    UIButton *frontBtn;
    
    UITextField * nameValueTextField;
    UITextField * sexValueTextField;
    UITextField * nationValueTextField;
    UITextField * birthdayTextField;
    UITextField * codeValueTextField;
    
    UILabel * addressLabel;
    UITextView * addressValueTextView;
    UITextField * addressValueTextField;
    
    UIView *backBackground;
    
    UIView *backBtnBackground;
    UILabel *backBtnLabel;
    UIButton *backBtn;
    
    UITextField * issueValueTextField;
    UITextField * validValueTextField;
    
    UILabel *lbl;
    float lastY;
    CGFloat scale;
    float localWidth;
    CGFloat borderWidth;
    CGFloat labelHeight;
    float lastFrontY;
    CGRect frontFrame;
    CGFloat labelMarginVer;
    UIScrollView * scr;
}

@end

@implementation KKIDCardOCRViewController
@synthesize IDInfo;

- (void)dealloc {
    [EXOCRCardEngineManager finishEngine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configNavigationBarStyle];
}

///配置导航栏样式
- (void)configNavigationBarStyle {
    self.view.backgroundColor = [UIColor whiteColor]; 
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if (iOS7Later) {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        //关闭scrollView自动调整
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份证识别";
    //启动证件扫描引擎
    [EXOCRCardEngineManager initEngine];
    
    [self configUI];
}

- (void) hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)configUI
{
    scale = [[UIScreen mainScreen] scale];
    borderWidth = scale > 0.0 ? 1.0 / scale : 1.0;
    labelHeight = IS_IPHONE ? 30 : 60;
    if (LARGE_SCREEN) {
        labelHeight = 40;
    }
    labelMarginVer = IS_IPHONE ? 10 : 25;
    if (LARGE_SCREEN) {
        labelMarginVer = 15;
    }
    
    CGFloat navHeight = STATUS_BAR_HEIGHT+NAV_BAR_HIGHT;
    scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,navHeight, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight)];
    [scr setBackgroundColor:UIColorFromRGBA(0xf3f3f3,1)];
    [self.view addSubview: scr];
    
    /*for dismiss keyboard*/
    UIView *backView = [[UIView alloc] initWithFrame:scr.frame];
    [backView setBackgroundColor:[UIColor clearColor]];
    [scr addSubview:backView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    [backView addGestureRecognizer:tapGr];
    
    [self configFrontView];
    
    [self configBackView];
}

#pragma mark - IDCard正面视图
- (void)configFrontView {
    lastY = 10;
    localWidth = SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN;
    
    /*正面*/
    frontBackground = [[UIView alloc]initWithFrame:CGRectMake(0, lastY, SCREEN_WIDTH, 0)];
    frontBackground.backgroundColor = [UIColor whiteColor];
    [scr addSubview:frontBackground];
    lastFrontY = 0;
    /*“身份证正面”按钮*/
    frontBtnBackground = [[UIView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, PHOTO_BUTTON_HEIGHT+PHOTO_BUTTON_MARGIN_TOP+PHOTO_BUTTON_LABEL_HEIGHT)];
    frontBtnBackground.backgroundColor = [UIColor clearColor];
    [frontBackground addSubview:frontBtnBackground];
    //按钮
    frontBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, PHOTO_BUTTON_MARGIN_TOP, PHOTO_BUTTON_WIDTH + 30.0, PHOTO_BUTTON_HEIGHT)];
    [frontBtn setBackgroundImage:[UIImage imageNamed:@"IdCardImg1"] forState:UIControlStateNormal];
    frontBtn.tag = FRONT_TAG;
    [frontBtn addTarget:self action:@selector(launchCameraView:) forControlEvents:UIControlEventTouchUpInside];
    frontBtn.center = CGPointMake(frontBtnBackground.frame.size.width/2, frontBtn.center.y);
    [frontBtnBackground addSubview:frontBtn];
    //提示文字
    frontBtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frontBtnBackground.frame.size.width, PHOTO_BUTTON_LABEL_HEIGHT)];
    frontBtnLabel.textAlignment = NSTextAlignmentCenter;
    frontBtnLabel.numberOfLines = 0;
    if (LARGE_SCREEN) {
        frontBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    } else {
        frontBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
    }
    frontBtnLabel.text = @"点击图片识别身份证正面";
    frontBtnLabel.textColor = UIColorFromRGBA(0x999999,1);
    frontBtnLabel.center = CGPointMake(frontBtnBackground.frame.size.width/2, frontBtnBackground.frame.size.height-PHOTO_BUTTON_LABEL_HEIGHT/2);
    [frontBtnBackground addSubview:frontBtnLabel];
    
    lastFrontY += frontBtnBackground.frame.size.height + 10;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    /*“身份证正面”按钮*/
    /*人脸*/
    int faceHeight = labelHeight*3+labelMarginVer*2;
    int faceWidth = faceHeight / 1.2;
    faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-RIGHT_MARGIN-faceWidth, lastFrontY, faceWidth, faceHeight)];
    [faceImageView setBackgroundColor:[UIColor whiteColor]];
    faceImageView.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    faceImageView.layer.borderWidth = borderWidth;
    [frontBackground addSubview:faceImageView];
    /*姓名*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_FRONT, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //    lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  姓名";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //姓名分隔线
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight/4, borderWidth, labelHeight/2);
    nameBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:nameBorder];
    
    nameValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth-faceWidth-FACEIMG_TEXT_MARGIN, labelHeight)];
    nameValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    nameValueTextField.layer.borderWidth = borderWidth;
    nameValueTextField.delegate = self;
    nameValueTextField.leftViewMode = UITextFieldViewModeAlways;
    nameValueTextField.leftView = lbl;
    nameValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    nameValueTextField.backgroundColor = [UIColor greenColor];
    [frontBackground addSubview:nameValueTextField];
    
    lastFrontY += nameValueTextField.frame.size.height+labelMarginVer;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    /*性别*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_FRONT, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  性别";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //性别分隔线
    CALayer *sexBorder = [CALayer layer];
    sexBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight/4, borderWidth, labelHeight/2);
    sexBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:sexBorder];
    
    sexValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth-faceWidth-FACEIMG_TEXT_MARGIN, labelHeight)];
    sexValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    sexValueTextField.layer.borderWidth = borderWidth;
    sexValueTextField.delegate = self;
    sexValueTextField.leftViewMode = UITextFieldViewModeAlways;
    sexValueTextField.leftView = lbl;
    sexValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sexValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //            sexValueTextField.backgroundColor = [UIColor greenColor];
    [frontBackground addSubview:sexValueTextField];
    
    lastFrontY += sexValueTextField.frame.size.height+labelMarginVer;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    /*民族*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_FRONT, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  民族";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //民族分隔线
    CALayer *nationBorder = [CALayer layer];
    nationBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight/4, borderWidth, labelHeight/2);
    nationBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:nationBorder];
    
    nationValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth-faceWidth-FACEIMG_TEXT_MARGIN, labelHeight)];
    nationValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    nationValueTextField.layer.borderWidth = borderWidth;
    nationValueTextField.delegate = self;
    nationValueTextField.leftViewMode = UITextFieldViewModeAlways;
    nationValueTextField.leftView = lbl;
    nationValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nationValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        nationValueTextField.backgroundColor = [UIColor greenColor];
    [frontBackground addSubview:nationValueTextField];
    
    lastFrontY += nationValueTextField.frame.size.height+labelMarginVer;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    /*出生日期*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_FRONT, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  出生";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //出生分隔线
    CALayer *birthBorder = [CALayer layer];
    birthBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight/4, borderWidth, labelHeight/2);
    birthBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:birthBorder];
    
    birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, labelHeight)];
    birthdayTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    birthdayTextField.layer.borderWidth = borderWidth;
    birthdayTextField.delegate = self;
    birthdayTextField.leftViewMode = UITextFieldViewModeAlways;
    birthdayTextField.leftView = lbl;
    birthdayTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    birthdayTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        birthdayTextField.backgroundColor = [UIColor greenColor];
    [frontBackground addSubview:birthdayTextField];
    
    lastFrontY += birthdayTextField.frame.size.height+labelMarginVer;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    /*住址*/
    if (IS_IPHONE) {
        UIView *addressBackground = [[UIView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, labelHeight*2)];
        addressBackground.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
        addressBackground.layer.borderWidth = borderWidth;
        [frontBackground addSubview:addressBackground];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, LEFTVIEW_WIDTH_FRONT, labelHeight*2)];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.textColor = UIColorFromRGBA(0x1e82d2,1);
        addressLabel.text = @"  住址";
        if (LARGE_SCREEN) {
            addressLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
        } else {
            addressLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
        }
        //            addressLabel.backgroundColor = [UIColor blueColor];
        [frontBackground addSubview: addressLabel];
        //住址分隔线
        CALayer *addressBorder = [CALayer layer];
        addressBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight*3/4, borderWidth, labelHeight/2);
        addressBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
        [addressLabel.layer addSublayer:addressBorder];
        
        addressValueTextView = [[UITextView alloc] initWithFrame:CGRectMake(LEFTVIEW_WIDTH_FRONT+LEFT_MARGIN+1, lastFrontY+1, localWidth-LEFTVIEW_WIDTH_FRONT-2, labelHeight*2-2)];
        addressValueTextView.delegate = self;
        [addressValueTextView setFont:[UIFont systemFontOfSize:17]];
        //            addressValueTextView.backgroundColor = [UIColor greenColor];
        [frontBackground addSubview:addressValueTextView];
        
        lastFrontY += addressValueTextView.frame.size.height+labelMarginVer;
        frontFrame = frontBackground.frame;
        frontFrame.size.height = lastFrontY;
        frontBackground.frame = frontFrame;
    } else {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_FRONT, labelHeight)];
        lbl.backgroundColor = [UIColor clearColor];
        //lbl.backgroundColor = [UIColor blueColor];
        lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
        lbl.text = @"  住址";
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
        //住址分隔线
        CALayer *addressBorder = [CALayer layer];
        addressBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight/4, borderWidth, labelHeight/2);
        addressBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
        [lbl.layer addSublayer:addressBorder];
        
        addressValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, labelHeight)];
        addressValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
        addressValueTextField.layer.borderWidth = borderWidth;
        addressValueTextField.delegate = self;
        addressValueTextField.leftViewMode = UITextFieldViewModeAlways;
        addressValueTextField.leftView = lbl;
        addressValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        addressValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //        addressValueTextField.backgroundColor = [UIColor greenColor];
        [frontBackground addSubview:addressValueTextField];
        
        lastFrontY += addressValueTextField.frame.size.height+labelMarginVer;
        frontFrame = frontBackground.frame;
        frontFrame.size.height = lastFrontY;
        frontBackground.frame = frontFrame;
    }
    /*身份证号*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_FRONT, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  号码";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //号码分隔线
    CALayer *codeBorder = [CALayer layer];
    codeBorder.frame = CGRectMake(LEFTVIEW_WIDTH_FRONT*7/8, labelHeight/4, borderWidth, labelHeight/2);
    codeBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:codeBorder];
    
    codeValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, labelHeight)];
    codeValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    codeValueTextField.layer.borderWidth = borderWidth;
    codeValueTextField.delegate = self;
    codeValueTextField.leftViewMode = UITextFieldViewModeAlways;
    codeValueTextField.leftView = lbl;
    codeValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        codeValueTextField.backgroundColor = [UIColor greenColor];
    [frontBackground addSubview:codeValueTextField];
    
    lastFrontY += codeValueTextField.frame.size.height+10;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    /*正面fullImage*/
    frontFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, (localWidth) * 0.632)];
    frontFullImageView.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    frontFullImageView.layer.borderWidth = borderWidth;
    [frontBackground addSubview:frontFullImageView];
    
    lastFrontY += frontFullImageView.frame.size.height+2;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    //正面遮挡提示
    frontShadowLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastFrontY, localWidth, 20)];
    frontShadowLabel.textColor = [UIColor blackColor];
    if (LARGE_SCREEN) {
        frontShadowLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    } else {
        frontShadowLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];;
    }
    frontShadowLabel.text = @"";
    [frontBackground addSubview:frontShadowLabel];
    
    lastFrontY += frontShadowLabel.frame.size.height+10;
    frontFrame = frontBackground.frame;
    frontFrame.size.height = lastFrontY;
    frontBackground.frame = frontFrame;
    
    /*dismiss keyboard*/
    UITapGestureRecognizer *tapGrFront = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGrFront.cancelsTouchesInView = NO;
    [frontBackground addGestureRecognizer:tapGrFront];
    
    lastY += frontFrame.size.height + 10;
}

#pragma mark - IDCard背面视图
- (void)configBackView {
    /*背面*/
    backBackground = [[UIView alloc]initWithFrame:CGRectMake(0, lastY, SCREEN_WIDTH, 0)];
    backBackground.backgroundColor = [UIColor whiteColor];
    [scr addSubview:backBackground];
    CGRect backFrame;
    float lastBackY = 0;
    /*“身份证背面”按钮*/
    backBtnBackground = [[UIView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, lastBackY, localWidth, PHOTO_BUTTON_HEIGHT+PHOTO_BUTTON_MARGIN_TOP+PHOTO_BUTTON_LABEL_HEIGHT)];
    backBtnBackground.backgroundColor = [UIColor clearColor];
    [backBackground addSubview:backBtnBackground];
    //按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, PHOTO_BUTTON_MARGIN_TOP, PHOTO_BUTTON_WIDTH+30, PHOTO_BUTTON_HEIGHT)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"IdCardImg2"] forState:UIControlStateNormal];
    backBtn.tag = BACK_TAG;
    [backBtn addTarget:self action:@selector(launchCameraView:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.center = CGPointMake(backBtnBackground.frame.size.width/2, backBtn.center.y);
    [backBtnBackground addSubview:backBtn];
    //提示文字
    backBtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backBtnBackground.frame.size.width, PHOTO_BUTTON_LABEL_HEIGHT)];
    backBtnLabel.textAlignment = NSTextAlignmentCenter;
    backBtnLabel.numberOfLines = 0;
    if (LARGE_SCREEN) {
        backBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    } else {
        backBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];;
    }
    backBtnLabel.text = @"点击图片识别身份证背面";
    backBtnLabel.textColor = UIColorFromRGBA(0x999999,1);
    backBtnLabel.center = CGPointMake(backBtnBackground.frame.size.width/2, backBtnBackground.frame.size.height-PHOTO_BUTTON_LABEL_HEIGHT/2);
    [backBtnBackground addSubview:backBtnLabel];
    
    lastBackY += backBtnBackground.frame.size.height + 10;
    backFrame = backBackground.frame;
    backFrame.size.height = lastBackY;
    backBackground.frame = backFrame;
    /*“身份证背面”按钮*/
    /*签发机关*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_BACK, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  签发机关";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //签发机关分隔线
    CALayer *issueBorder = [CALayer layer];
    issueBorder.frame = CGRectMake(LEFTVIEW_WIDTH_BACK*7/8, labelHeight/4, borderWidth, labelHeight/2);
    issueBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:issueBorder];
    
    issueValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastBackY, localWidth, labelHeight)];
    issueValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    issueValueTextField.layer.borderWidth = borderWidth;
    issueValueTextField.delegate = self;
    issueValueTextField.leftViewMode = UITextFieldViewModeAlways;
    issueValueTextField.leftView = lbl;
    issueValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    issueValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        issueValueTextField.backgroundColor = [UIColor greenColor];
    [backBackground addSubview:issueValueTextField];
    
    lastBackY += issueValueTextField.frame.size.height+labelMarginVer;
    backFrame = backBackground.frame;
    backFrame.size.height = lastBackY;
    backBackground.frame = backFrame;
    /*有效期限*/
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH_BACK, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  有效期限";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //有效期限分隔线
    CALayer *validBorder = [CALayer layer];
    validBorder.frame = CGRectMake(LEFTVIEW_WIDTH_BACK*7/8, labelHeight/4, borderWidth, labelHeight/2);
    validBorder.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:validBorder];
    
    validValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastBackY, localWidth, labelHeight)];
    validValueTextField.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    validValueTextField.layer.borderWidth = borderWidth;
    validValueTextField.delegate = self;
    validValueTextField.leftViewMode = UITextFieldViewModeAlways;
    validValueTextField.leftView = lbl;
    validValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    validValueTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        issueValueTextField.backgroundColor = [UIColor greenColor];
    [backBackground addSubview:validValueTextField];
    
    lastBackY += validValueTextField.frame.size.height+10;
    backFrame = backBackground.frame;
    backFrame.size.height = lastBackY;
    backBackground.frame = backFrame;
    //背面fullImage
    backFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastBackY, localWidth, (localWidth) * 0.632)];
    backFullImageView.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    backFullImageView.layer.borderWidth = borderWidth;
    [backBackground addSubview:backFullImageView];
    
    lastBackY += backFullImageView.frame.size.height+2;
    backFrame = backBackground.frame;
    backFrame.size.height = lastBackY;
    backBackground.frame = backFrame;
    //背面遮挡提示
    backShadowLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastBackY, localWidth, 20)];
    backShadowLabel.textColor = [UIColor blackColor];
    if (LARGE_SCREEN) {
        backShadowLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    } else {
        backShadowLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];;
    }
    backShadowLabel.text = @"";
    [backBackground addSubview:backShadowLabel];
    
    lastBackY += backShadowLabel.frame.size.height+10;
    backFrame = backBackground.frame;
    backFrame.size.height = lastBackY;
    backBackground.frame = backFrame;
    
    /*dismiss keyboard*/
    UITapGestureRecognizer *tapGrBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGrBack.cancelsTouchesInView = NO;
    [backBackground addGestureRecognizer:tapGrBack];
    scr.contentSize = CGSizeMake(SCREEN_WIDTH, frontFrame.size.height + backFrame.size.height + 30);
    
    for (UIView *subView in self.view.subviews) {
        for (id controll in subView.subviews)
        {
            if ([controll isKindOfClass:[UITextField class]])
            {
                [controll setBackgroundColor:[UIColor whiteColor]];
                [controll setDelegate:self];
                [controll setAdjustsFontSizeToFitWidth:YES];
                [controll setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            }
        }
    }
}

#pragma mark - 启动扫描
- (void)launchCameraView:(UIButton *)sender
{
    BOOL bShouldFront = YES;
    if (sender.tag == FRONT_TAG) {
        bShouldFront = YES;
    } else {
        bShouldFront = NO;
    }
    [self launchCameraViewWithFront:bShouldFront];
}

#pragma mark 启动扫描(切换正反面)
- (void)launchCameraViewWithFront:(BOOL)isFront{
    EXOCRIDCardRecoManager *manager = [EXOCRIDCardRecoManager sharedManager:self];
    //扫描页的相关设置
    [manager setDisplayLogo:NO];     //是否显示logo
    [manager setEnablePhotoRec:NO]; //是否开启本地相册识别
    [manager setScanFrameColorRGB:0x1F76F1 andAlpha:0.5];//扫描页设置，扫描框颜色
    [manager setScanNormalTextColorRGB:0x0000ff];   //正常状态扫描字体颜色
    [manager setScanErrorTextColorRGB:0x00ff00];    //错误状态扫描字体颜色
    [manager setScanFrontNormalTips:@""];    //正常状态正面扫描提示文字
    [manager setScanFrontErrorTips:@"请扫描身证份正面"];
    [manager setScanBackNormalTips:@""];     //正常状态背面扫描提示文字
    [manager setScanBackErrorTips:@"请扫描身证份背面"];
    [manager setScanNormalTipsFontName:@"CourierNewPS-BoldMT" andFontSize:34.0f];//正常状态扫描提示文字字体名称及字体大小
    [manager setScanErrorTipsFontName:@"CourierNewPS-BoldMT" andFontSize:34.0f];
    [manager setImageMode:ID_IMAGEMODE_HIGH];  //取图设置，设置取图模式（目前支持三种取图模式）
    __weak typeof(self) weakSelf = self;
    [manager recoIDCardFromStreamWithSide:isFront OnCompleted:^(int statusCode, EXOCRIDCardInfo *idInfo) {
        NSLog(@"Completed -- 扫描成功");
        NSLog(@"%@", [idInfo toString]);
        self.IDInfo = idInfo;
        [weakSelf loadData]; 
    } OnCanceled:^(int statusCode) {
        NSLog(@"Canceled");
    } OnFailed:^(int statusCode, UIImage *recoImg) {
        NSLog(@"Failed-- 扫描失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"识别失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loadData
{
    if (IDInfo.type == 1) {
        //人脸
        if (IDInfo.faceImg != nil) {
            [faceImageView setImage:IDInfo.faceImg];
        }
        
        //姓名
        if (nameValueTextField != nil)
            nameValueTextField.text = IDInfo.name;
        
        //性别
        if (sexValueTextField != nil)
            sexValueTextField.text = IDInfo.gender;
        
        //民族
        if (nationValueTextField != nil)
            nationValueTextField.text = IDInfo.nation;
        
        //出生日期
        if (birthdayTextField != nil) {
            birthdayTextField.text = IDInfo.birth;
        }
        
        //住址
        if (IS_IPHONE) {
            if (addressValueTextView != nil) {
                addressValueTextView.text = IDInfo.address;
                //textview 改变字体的行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10;// 字体的行间距
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                             NSParagraphStyleAttributeName:paragraphStyle
                                             };
                addressValueTextView.attributedText = [[NSAttributedString alloc] initWithString:addressValueTextView.text attributes:attributes];
            }
        } else {
            if (addressValueTextField != nil)
                addressValueTextField.text = IDInfo.address;
        }
        //身份证号
        if (codeValueTextField != nil)
            codeValueTextField.text = IDInfo.code;
        //身份证正面图像
        if (frontFullImageView != nil)
            [frontFullImageView setImage:IDInfo.frontFullImg];
        //身份证正面图像是否遮挡
        if (IDInfo.frontShadow == 1) {
            frontShadowLabel.textColor = [UIColor redColor];
            frontShadowLabel.text = @"检测到身份证正面图像四周有遮挡";
        } else {
            frontShadowLabel.textColor = [UIColor blackColor];
            frontShadowLabel.text = @"检测到身份证正面图像四周无遮挡";
        }
    }else{
        //签发机关
        if (issueValueTextField != nil)
            issueValueTextField.text = IDInfo.issue;
        //有效期限
        if (validValueTextField != nil)
            validValueTextField.text = IDInfo.valid;
        //身份证背面图像
        if (backFullImageView != nil)
            [backFullImageView setImage:IDInfo.backFullImg];
        //身份证背面图像是否遮挡
        if (IDInfo.backShadow == 1) {
            backShadowLabel.textColor = [UIColor redColor];
            backShadowLabel.text = @"检测到身份证背面图像四周有遮挡";
        } else {
            backShadowLabel.textColor = [UIColor blackColor];
            backShadowLabel.text = @"检测到身份证背面图像四周无遮挡";
        }
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}

@end
