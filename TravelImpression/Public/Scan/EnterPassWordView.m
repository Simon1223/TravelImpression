//
//  EnterPassWordView.m
//  SMDD
//
//  Created by Lww on 16/12/27.
//  Copyright © 2016年 DianDi. All rights reserved.
//

#import "EnterPassWordView.h"
#import "CustomKeyBoardView.h"

@interface EnterPassWordView () <UITextFieldDelegate>
{
    UIView *numberBgView;
    UILabel *noticeLabel;
    NSString *armsString;
    CustomKeyBoardView *keyboardView;
}

@end

@implementation EnterPassWordView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGB(36, 36, 40, 1);

        numberBgView = [[UIView alloc] initWithFrame:CGRectMake(40, 120, DEVICE_WIDTH - 80, 44)];
        numberBgView.layer.borderWidth = 0.5;
        numberBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        numberBgView.layer.cornerRadius = 2;
        numberBgView.layer.masksToBounds = YES;
        [self addSubview:numberBgView];
        
        noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 174, DEVICE_WIDTH - 80, 25)];
        noticeLabel.text = @"请输入口令码，口令码为6为数字";
        noticeLabel.textColor = [UIColor grayColor];
        noticeLabel.font = Font(14);
        [self addSubview:noticeLabel];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake((DEVICE_WIDTH - 100) / 2, 210, 100, 44);
        sureBtn.backgroundColor = [UIColor lightGrayColor];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 3;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [sureBtn addTarget:self action:@selector(gotoCarTeamInfo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        [self setCustomKeyBoardView];
        CGFloat width = (CGRectGetWidth(numberBgView.frame) - 60) / 6;
        for (int i = 0; i < 6; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + width * i, 0, width, 44)];
            label.tag = i + 2;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont boldSystemFontOfSize:16.f];
            label.textAlignment = NSTextAlignmentCenter;
            [numberBgView addSubview:label];
        }
    }
    
    return self;
}

- (void)gotoCarTeamInfo
{
    if (armsString.length == 6) {
        /*
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USERID, @"userid",@"1", @"type",armsString, @"arms", nil];
        [[HttpRequestClient sharedClient] sendGetHttpRequestForUrl:UserJoinInfoURL param:params success:^(NSDictionary *resultData) {
            
            NSInteger status = [[resultData objectForKey:@"status"] integerValue];
            NSDictionary *dataDic = [resultData objectForKey:@"data"];
            if(status ==1){
                EnjoyCarTeamViewController *vc = [EnjoyCarTeamViewController new];
                vc.dataDic = dataDic;
                vc.arms = armsString;
                vc.type = @"1";
                vc.carID = _carID;
                [[GlobalTool sharedTool].currentViewController.navigationController pushViewController:vc animated:YES];
                
            } else {
                [SVProgressHUD showInfoWithStatus:[resultData stringValueForKey:@"info"]];
                [keyboardView cleanInputString];
                [self setLableContent:@""];
            }
            
        } fail:^(NSError *error) {
            
        }];
         */
    }
}

-(void)setCustomKeyBoardView{
     keyboardView = [[CustomKeyBoardView alloc]initWithFrame:CGRectZero SuperView:self Block:^(NSString *string) {
         [self setLableContent:string];
         armsString = string;
     }];
    [keyboardView showWithAnimate:NO Duration:0.f];
}

-(void)setLableContent:(NSString*)str
{
    for (int i = 0; i < 6; i ++) {
        UILabel *tempLB = (UILabel *)[numberBgView viewWithTag:i + 2];
        tempLB.text = @"";
    }

    for (int i = 0; i < str.length; i++) {
        NSString *temp = [str substringWithRange:NSMakeRange(i, 1)];
        UILabel *tempLB = (UILabel *)[numberBgView viewWithTag:i + 2];
        tempLB.text = temp;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (toBeString.length > 6) {
        return NO;
    }
    return YES;
}


@end
