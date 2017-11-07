//
//  TodayViewController.m
//  tset1031
//
//  Created by TGT on 2017/10/30.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置widget展示视图的大小
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100) ;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    
    [btn setTitle:@"进入" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(openURLContainingAPP) forControlEvents:UIControlEventTouchUpInside];
    
    
}

// 取消widget默认的inset，让应用靠左
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}


- (void)openURLContainingAPP{
    //通过extensionContext借助host app调起app
    [self.extensionContext openURL:[NSURL URLWithString:@"myWidget://action=richScan"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}

//activeDisplayMode有以下两种
//NCWidgetDisplayModeCompact, // 收起模式
//NCWidgetDisplayModeExpanded, // 展开模式

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if(activeDisplayMode == NCWidgetDisplayModeCompact) {
        // 尺寸只设置高度即可，因为宽度是固定的，设置了也不会有效果
        self.preferredContentSize = CGSizeMake(0, 110);
    } else {
        self.preferredContentSize = CGSizeMake(0, 310);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
