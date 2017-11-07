//
//  SetViewController.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/13.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "SetViewController.h"
#import "TGTInfoSDK.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import "LanguageViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView     *_tableView;
    NSArray         *_arr;
    

}

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    背景图片
    UIImageView *backgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,XScreenHeight)];
    
    backgroud.image = [UIImage imageNamed:@"2.jpg"];
    
    [self.view addSubview:backgroud];
    
    
    
  

    
    
//    标题栏
    [self HeadTitle];
    
    
    [self createTableview];
    
    
}
#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, XScreenWidth, 60)];
    
    _TitleView.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:84.0/255.0 blue:178.0/255.0 alpha:1];
    
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    TitleText.text = SetLange(@"setTitle");
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_TitleView);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
     TitleText.textAlignment = NSTextAlignmentCenter;
}

#pragma mark -创建tableview
-(void)createTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+60, XScreenWidth, XScreenHeight-40-64-25) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 60;
    
    _tableView.sectionHeaderHeight = 20;
    
    [self.view addSubview:_tableView];
    
//    _arr = @[@[@"关闭设备热点",@"修改设备热点",@"设置APN",@"连接Wifi",@"设置翻译语言",@"设置提示语言",@"多语言"],@[@"设置热点访问黑名单",@"设备自检",@"软件版本检测",@"历史流量订单"]];
    
    NSString *str1 = SetLange(@"guanbishebeiredian");
    NSString *str2 = SetLange(@"xiugaishebeiredian");
    NSString *str3 = SetLange(@"shezhivpn");
    NSString *str4 = SetLange(@"lianjieWifi");
    NSString *str5 = SetLange(@"shezhifanyiyuyan");
    NSString *str6 = SetLange(@"shezhitishiyuyan");
    NSString *str7 = SetLange(@"duoyuyan");
  
    NSString *str8 = SetLange(@"shezhiredianfangwenmingdan");
    NSString *str9 = SetLange(@"shebeizijian");
    NSString *str10 = SetLange(@"ruanjianbanbenjiance");
    NSString *str11 = SetLange(@"lishiliuliangdingdan");
    
    
    
    
     _arr = @[@[str1,str2,str3,str4,str5,str6,str7],@[str8,str9,str10,str11]];
    
    _tableView.tableHeaderView =[self headView] ;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr[section] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"idd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
//     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.text = _arr[indexPath.section][indexPath.row];
    
   
    
//    设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    设置左边小图标
//    NSArray *images = @[@[@"",@"",@"",@"",@"",@""],@[@"",@"",@"",@""]];
//    
//    cell.imageView.image = [UIImage imageNamed:images[indexPath.section][indexPath.row]];
    
    
    return cell;


}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//  
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str1 = SetLange(@"jibenshezhi");
    NSString *str2 = SetLange(@"gaojishezhi");
    
    NSArray *arr = @[str1,str2];

    return arr[section];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//   点击闪一闪
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    app语言切换
    if (indexPath.section==0&&indexPath.row==6) {
        
        LanguageViewController *vc = [[LanguageViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
       
        
       

        
    }

}




#pragma mark- 头部视图
-(UIView *)headView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, 90)];
    UILabel *ssid = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 200, 45)];
    
    TGTInfoSDK *tgtInfo = [[TGTInfoSDK alloc]init];
    ssid.text = [tgtInfo getWiFiSSID];
    if (!ssid.text) {
        ssid.text=SetLange(@"devicedName");
    }
    ssid.textColor = [UIColor blackColor];
    [view addSubview:ssid];
    
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
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
