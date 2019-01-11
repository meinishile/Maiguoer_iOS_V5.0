//
//  WJSlideMenu.m
//  WJSlideMenu
//  https://github.com/wjTime
//  Created by 高文杰 on 16/3/6.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#define menuW self.frame.size.width
#define menuH self.frame.size.height
#define navH  64
#define navBtnW 60
#define titleViewW 120
#define leftMoveX 200;
#define rightMoveX 200;

#import "WJSlideMenu.h"

@interface WJSlideMenu ()
{
    BOOL canSlide;
}
@property (nonatomic,strong)NSArray *navBtns;

@end

@implementation WJSlideMenu



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // create leftMenuView
        UIView *leftMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuW, menuH+30)];
        leftMenuView.backgroundColor = SVCV1T11Color;
        [self addSubview:leftMenuView];
        if (iPhoneX)
        {
            leftMenuView.frame = CGRectMake(0, -24, menuW, menuH+24);
        }
        self.leftMenuView = leftMenuView;
        canSlide = NO;
        
        // create rightMenuView
        UIView *rightMenuView = [[UIView alloc]initWithFrame:CGRectMake(menuH, 0, menuH, menuH)];
        rightMenuView.backgroundColor = SVCV1B7Color;
        [self addSubview:rightMenuView];
        self.rightMenuView = rightMenuView;
        
        // create background main view
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, menuW, menuH)];
        mainView.backgroundColor = SVCV1B7Color;
        [self addSubview:mainView];
        self.mainView = mainView;
        
//        self.translucentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuW, menuH)];
//        self.translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        self.translucentView.hidden = YES;
//        [self.mainView addSubview:self.translucentView];
        
        // create navgaiton background view
        UIView *navBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuW, navH)];
        navBgView.backgroundColor = [UIColor clearColor];
        [mainView addSubview:navBgView];
        self.navBgView = navBgView;
        
        // create left navigation button
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, navBtnW, 44)];
        leftButton.backgroundColor = [UIColor whiteColor];
        [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        [navBgView addSubview:leftButton];
        self.navLeftBtn = leftButton;
        
        
        // create right navigation button
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(menuW-navBtnW, 20, navBtnW, 44)];
        rightButton.backgroundColor = [UIColor whiteColor];
        [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        [navBgView addSubview:rightButton];
        self.navRigthBtn = rightButton;
        
        // create navigation titleVeiw
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake((menuW-titleViewW)/2, 20, titleViewW, 44)];
        titleView.backgroundColor = [UIColor whiteColor];
        [navBgView addSubview:titleView];
        self.titleView = titleView;
        
        // cretea navBtns array
        self.navBtns = [NSArray arrayWithObjects:self.navLeftBtn,self.navRigthBtn, nil];
        
        if (iPhoneX)
        {
            navBgView.frame = CGRectMake(0, 0, menuW, navH+20);
            leftButton.frame = CGRectMake(0, 40, navBtnW, 44);
            rightButton.frame = CGRectMake(menuW-navBtnW, 40, navBtnW, 44);
        }
    }
    
    return self;
}


// left and right click animation
- (void)leftAndRightBtnClickEvent:(UIButton *)btn isLeft:(BOOL)isLeft push:(BOOL)push{
    
    btn.selected = !btn.selected;
    canSlide = btn.selected;
   CGRect mainFrame = self.mainView.frame;
    
    if (canSlide==YES)
    {
        self.translucentView.hidden = NO;
    }
    else
    {
        self.translucentView.hidden = YES;
    }
    if (isLeft) {
        if (self.mainView.frame.origin.x < 0) {
            btn.selected = !btn.selected;
            return;
        }
        if (btn.selected) {
            CGRect frame = self.leftMenuView.frame;
            frame.origin.x = menuW;
            self.rightMenuView.frame = frame;
            mainFrame.origin.x += _leftMovex ? _leftMovex : leftMoveX;
        }else{
            mainFrame.origin.x -= _leftMovex ? _leftMovex : leftMoveX;
        }
    }else{
        if (self.mainView.frame.origin.x > 0) {
            btn.selected = !btn.selected;
            return;
        }
        if (btn.selected) {
            CGRect frame = self.leftMenuView.frame;
            frame.origin.x = 0;
            self.rightMenuView.frame = frame;
            mainFrame.origin.x -= _rightMovex ? _rightMovex : rightMoveX;
        }else{
            mainFrame.origin.x += _rightMovex ? _rightMovex : rightMoveX;
        }
    }
    CGFloat time = 0.25;
    if (push) {
        time = 0.0;
    }
    [UIView animateWithDuration:time animations:^{
        self.mainView.frame = mainFrame;
    } completion:^(BOOL finished) {

    }];
}
- (void)willMoveToWindow:(UIWindow *)newWindow{
    
        if (self.hidden == YES) {
            self.hidden = YES;
        }
}

// navLeftbtn click event
- (void)leftClick:(UIButton *)btn{
    [self leftAndRightBtnClickEvent:btn isLeft:YES push:NO];
}

// navRightbtn click event
- (void)rightClick:(UIButton *)btn{
    
//    [self leftAndRightBtnClickEvent:btn isLeft:NO push:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterScanningView)])
    {
        [self.delegate enterScanningView];
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (self.hidden == YES) {
        self.hidden = YES;
    };
}
// close left menu
- (void)closeLeftMenuView{
    
    [self leftAndRightBtnClickEvent:self.navBtns[0] isLeft:YES push:YES];
    
}
- (void)closeRightMenuView{
    
//    [self leftAndRightBtnClickEvent:self.navBtns[1] isLeft:NO push:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (canSlide==YES)
    {
        [self leftAndRightBtnClickEvent:self.navBtns[0] isLeft:YES push:YES];
    }
    
}

@end
