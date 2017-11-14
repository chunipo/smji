//
//  MainTabbarController.m
//  tgtwifi
//
//  Created by weiyuxiang on 2017/10/12.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "MainTabbarController.h"
#import "HomeViewController.h"
#import "MainNavVc.h"
#import "SetViewController.h"
#import "ShoppingVc.h"
#import "BluetrueViewController.h"


#import "BluetrueVC.h"
#import "GCDTestVC.h"

@interface MainTabbarController ()
{
    
    NSMutableArray   *_arr2;
    UIViewController *zx;
    MainNavVc        *_mainNavc;
    
    
    

}

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetLanguage) name:@"SetLanguage" object:nil];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _arr2 = [NSMutableArray array];
    
    [self createUI];

}

-(void)createUI{
    
    //    NSArray *arr1 = @[@"首页",@"商城",@"设置"];
    
    NSString *str1 = SetLange(@"shouye");
    NSString *str2 = SetLange(@"shangcheng");
    NSString *str3 = SetLange(@"shezhi");
    NSArray *arr1 = @[str1,str2,str3];
    NSArray *arr2 = @[@"HomeViewController",@"ShoppingVc",@"SetViewController"];
    
    //添加视图控制器到tabbar
    [self addVc:arr2 title:arr1];
    
    
   // 设置tabbar颜色跟隐藏黑线
    [self settabbarUI];
   
}
#pragma mark -添加控制器到tabbarVc
-(void)addVc:(NSArray *)arr2 title:(NSArray *)arr1{
    
    
    
    for(int i = 0;i<arr2.count;i++){
        zx = [[NSClassFromString(arr2[i]) alloc]init];
        
        zx.tabBarItem = [[UITabBarItem alloc]initWithTitle:arr1[i] image:nil tag:0 ];
        
        [_arr2 addObject:zx];
    }
    
    
    self.viewControllers = _arr2;


}

#pragma mark -设置tabbar颜色跟隐藏黑线
-(void)settabbarUI{

    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [UITabBar appearance].clipsToBounds = YES;

}


#pragma mark - 设置语言后回到设置页面
-(void)SetLanguage{
    self.selectedIndex = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
