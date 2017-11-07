//
//  BluetrueViewController.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/26.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "BluetrueViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#define kServiceUUID @"49535343-FE7D-4AE5-8FA9-9FAFD205E455" //服务的UUID
#define kCharacteristicUUID @"444E414C-4933-4543-AE2E-F30CB91BB70D" //特征的UUID

@interface BluetrueViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UITableView       *_tableView;
    
    NSMutableArray    *_arr;
    
    
    NSString          *_peripName;
    
    
    BOOL              isEqul  ;
}


/* 中心管理者 */
 @property (nonatomic, strong) CBCentralManager *cMgr;
 
 /* 连接到的外设 */
 @property (nonatomic, strong) CBPeripheral *peripheral;


@end

@implementation BluetrueViewController

//1.建立一个Central Manager实例进行蓝牙管理

-(CBCentralManager *)cMgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _cMgr;
}


//只要中心管理者初始化 就会触发此代理方法 判断手机蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
            // 在中心管理者成功开启后再进行一些操作
            // 搜索外设
            
           
            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                              options:nil]; // dict,条件
            // 搜索成功之后,会调用我们找到外设的代理方法
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
        }
            break;
        default:
            break;
    }
}

/**** 执行扫描的动作之后，如果扫描到外设了，就会自动回调下面的协议方法了 ****/
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{

    NSLog(@"peripheral.name####%@。信号强度###%@",peripheral,RSSI);
    
    if (peripheral.name) {
        
        for (NSString *str in _arr) {
            if ([str isEqualToString:peripheral.name]) {
                isEqul = YES;
                break;
            }else{
                
                isEqul = NO;
            }
              
        }
        if (isEqul == NO) {
            [_arr addObject:peripheral.name];
        }
        
    }
    [_tableView reloadData];
    
    /*
     peripheral = , advertisementData = {
     kCBAdvDataChannel = 38;
     kCBAdvDataIsConnectable = 1;
     kCBAdvDataLocalName = OBand;
     kCBAdvDataManufacturerData = <4c69616e 0e060678 a5043853 75>;
     kCBAdvDataServiceUUIDs =     (
     FEE7
     );
     kCBAdvDataTxPowerLevel = 0;
     }, RSSI = -55
     根据打印结果,我们可以得到运动手环它的名字叫 OBand-75
     
     */
    
    // 需要对连接到的外设进行过滤
    // 1.信号强度(40以上才连接, 80以上连接)
    // 2.通过设备名(设备字符串前缀是 OBand)
    // 在此时我们的过滤规则是:有OBand前缀并且信号强度大于35
    // 通过打印,我们知道RSSI一般是带-的
    
    if ([peripheral.name hasPrefix:@"途鸽翻译机"]) {
        // 在此处对我们的 advertisementData(外设携带的广播数据) 进行一些处理
        
        // 通常通过过滤,我们会得到一些外设,然后将外设储存到我们的可变数组中,
        // 这里由于附近只有1个运动手环, 所以我们先按1个外设进行处理
        
        // 标记我们的外设,让他的生命周期 = vc
        self.peripheral = peripheral;
        // 发现完之后就是进行连接
        [self.cMgr connectPeripheral:self.peripheral options:nil];
        NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    }
}


/*如果连接成功，就会回调下面的协议方法了*/
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    NSLog(@"连接成功");
    // 连接成功之后,可以进行服务和特征的发现
    
    //  设置外设的代理
    self.peripheral.delegate = self;
    
    //停止中心管理设备的扫描动作，要不然在你和已经连接好的外设进行数据沟通时，如果又有一个外设进行广播且符合你的连接条件，那么你的iOS设备也会去连接这个设备（因为iOS BLE4.0是支持一对多连接的），导致数据的混乱。
    [self.cMgr stopScan];
    
    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.peripheral discoverServices:nil];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
}

//一旦我们读取到外设的相关服务UUID就会回调下面的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
{
    //到这里，说明你上面调用的  [_peripheral discoverServices:nil]; 方法起效果了，我们接着来找找特征值UUID
    NSLog(@"发现服务###%@",[peripheral services]);
       /*1 全局查找*/
//    for (CBService *s in [peripheral services]) {
//        
//        [peripheral discoverCharacteristics:nil forService:s];
//    }
    
    /*2  指定某个特征查找*/
    CBUUID *serverUDID = [CBUUID UUIDWithString:kServiceUUID];
    CBUUID *charaterUDID = [CBUUID UUIDWithString:kCharacteristicUUID];
    for (CBService *server in peripheral.services) {
        if ([server.UUID isEqual:serverUDID]) {
            //查找制定的服务的特征
            [peripheral discoverCharacteristics:@[charaterUDID] forService:server];
        }
    }
    
    

    
}


//4.获得外围设备的服务 & 5.获得服务的特征

// 发现外设服务里的特征的时候调用的代理方法(这个是比较重要的方法，你在这里可以通过事先知道UUID找到你需要的特征，订阅特征，或者这里写入数据给特征也可以)
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
//    [self writeToLog:@"查找到对应的特征"];
    
    //设置服务特征值的UUID
    CBUUID *serverUUID = [CBUUID UUIDWithString:kServiceUUID];
    if ([service.UUID isEqual:serverUUID]) {
        //遍历该服务中的特征
        for (CBCharacteristic *character in service.characteristics) {
            if ([character.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                //此时的特征既是我们要查找的特征
                //情景1：设置外围设备为已通知状态（订阅特征）
                [peripheral setNotifyValue:YES forCharacteristic:character];
                //情景2:读取特征中的特征值，用来进行操作
                                [peripheral readValueForCharacteristic:character];
                                if (character.value) {
                                    NSLog(@"读取到特征值");
                                }
            }
        }
    }
}
//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"write value success(写入成功) : %@", characteristic);
}

//获取外设发来的数据,不论是read和notify,获取数据都从这个方法中读取
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [peripheral readRSSI];
    NSNumber* rssi = [peripheral RSSI];
    
    //读取BLE4.0设备的电量
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]]){
        NSData* data = characteristic.value;
        NSString* value = [self hexadecimalString:data];
        NSLog(@"characteristic(读取到的) : %@, data : %@, value : %@", characteristic, data, value);
    }
    
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

//将传入的NSString类型转换成ASCII码并返回
- (NSData*)dataWithString:(NSString *)string{
    unsigned char *bytes = (unsigned char *)[string UTF8String];
    NSInteger len = string.length;
    return [NSData dataWithBytes:bytes length:len];
}







- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr = [NSMutableArray arrayWithCapacity:0];
    _peripName = @"rrrrrrrrrrrrrrrr";
    isEqul = NO;
    
    
    [self createCmgr];
    
    
    [self createTable];
    
}

-(void)createCmgr{
    self.cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

}

-(void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+60, XScreenWidth, XScreenHeight-40-64-25) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 100;
    
    [self.view addSubview:_tableView];



}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"idd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    //     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.text = _arr[indexPath.row];
    
    
    
    //    设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //    设置左边小图标
    //    NSArray *images = @[@[@"",@"",@"",@"",@"",@""],@[@"",@"",@"",@""]];
    //
    //    cell.imageView.image = [UIImage imageNamed:images[indexPath.section][indexPath.row]];
    
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    _peripName = cell.textLabel.text;
    //   点击闪一闪
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self dismissCmgr];
    
    [self createCmgr];
    
}

-(void)dismissCmgr{
    self.cMgr = nil;
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
