//
//  RYBlueToothTool.m
//  SmartInsole
//
//  Created by Think on 2017/10/19.
//  Copyright © 2017年 Eden. All rights reserved.

#import "RYBlueToothTool.h"
#import "NSString+Extension.h"

//弱引用/强引用
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define WeakSelf(weakSelf)  __weak __typeof(self) weakSelf = self;

@interface RYBlueToothTool()
{
    BabyBluetooth *baby;
}
@end

@implementation RYBlueToothTool
SZSingleton_M

- (void)setupBluetooth{
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
}

- (void)scanBluetooth
{
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    if ([self.UUIDString isNotBlank]){
        self.connectedPeripheral = [baby retrievePeripheralWithUUIDString:self.UUIDString];
        self->baby.having(self.connectedPeripheral). then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }else{
        baby.scanForPeripherals().begin();
    }
}

- (void)babyDelegate
{
    kWeakSelf(self)
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        kStrongSelf(self)
        switch (central.state) {
            case CBCentralManagerStatePoweredOn:
            {
                self.blueToothOpen = YES;
                NSLog(@"设备打开成功，开始扫描设备");
                if ([self.delegate respondsToSelector:@selector(blueToothState:)]) {
                    [self.delegate blueToothState:YES];
                }
            }
                break;
            case CBCentralManagerStatePoweredOff:
            {
                self.blueToothOpen = NO;
                [self->baby cancelAllPeripheralsConnection];
                if ([self.delegate respondsToSelector:@selector(blueToothState:)]) {
                    [self.delegate blueToothState:NO];
                }
            }
                break;
            default:
                break;
        }
    }];
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        kStrongSelf(self)
        [self->baby cancelScan];
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        kStrongSelf(self)
        if ([self.delegate respondsToSelector:@selector(connectionFail:)]) {
            [self.delegate connectionFail:peripheral];
        }
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"%@断开连接",peripheral.name);
        kStrongSelf(self)
        if ([self.delegate respondsToSelector:@selector(onDisconnect:)]) {
            [self.delegate onDisconnect:peripheral];
        }
//        [self->baby AutoReconnect:peripheral];
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        kStrongSelf(self)
        
        if ([self.delegate respondsToSelector:@selector(matchSuccess:)]) {
            [self.delegate matchSuccess:peripheral];
        }
        NSLog(@"搜索到了设备：%@",peripheral.name);
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        NSLog(@"-----Discover设备 %@ 的所有服务：%@",peripheral.name,peripheral.services);
        [rhythm beats];
    }];
    
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        kStrongSelf(self)
//        NSLog(@"service == %@",[service.UUID UUIDString]);
        
        if ([[service.UUID UUIDString] isEqualToString:@"FE18"]) {
            for (CBCharacteristic *c in service.characteristics) {
                
                if (c.properties == CBCharacteristicPropertyWrite) {
                    self.writeCharacteristic = c;
                }else if (c.properties == CBCharacteristicPropertyNotify){
                    
//                    self.characteristic = c;
                    [self notifyCharacteristic:peripheral characteristic:c];
                    if ([self.delegate respondsToSelector:@selector(connectionSuccess:characteristic:)]){
                        self.connectedPeripheral = peripheral;
                        
                        [self.delegate connectionSuccess:peripheral characteristic:c];
                        
                    }
                }
            }
        }
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:@"JXB_TTM"]) {
            return YES;
        }
        return NO;
        
    }];
    
    [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:@"JXB_TTM"]) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        kStrongSelf(self)
        NSLog(@"setBlockOnCancelScanBlock");
        if (!self->_connectedPeripheral) {
            if ([self.delegate respondsToSelector:@selector(connectionFail:)]) {
                [self.delegate connectionFail:self->_connectedPeripheral];
            }
        }
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
//        NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
//                                         CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
//                                         CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    if(peripheral.state != CBPeripheralStateConnected) {
        //        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate) {
        //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        
        [baby notify:peripheral characteristic:characteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
            NSLog(@"new value %@",characteristics.value);
            
            [self dataWithValue:characteristics.value];
        }];
    }
}

- (void)dataWithValue:(NSData *)value{
    NSMutableString *content = [NSMutableString string];
    for (int i = 0; i < value.length; i++) {
         [content appendFormat:@"%@%d", i == 0 ? @"" : @" ", ((Byte *)value.bytes)[i]];
    }

    if ([self.delegate respondsToSelector:@selector(getReturnValue:)]) {
        [self.delegate getReturnValue:content];
    }
}

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type {
    NSInteger start = 0;
    while (start < data.length) {
        NSUInteger bufCount = MIN(20, data.length - start);
        [[RYBlueToothTool sharedInstance].connectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(start, bufCount)]
                                                       forCharacteristic:characteristic
                                                                    type:type];
        start += bufCount;
    }
}

- (void)writeData{
    NSString *content = @"F5100000FF";
    
    NSData *data;
    
    content = [content uppercaseString];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (content.length <= 0) {
        return;
    }
    NSMutableString *logContent = [NSMutableString string];
    NSUInteger length = ([content length] + 1) / 2;
    char *myBuffer = (char *)malloc(length);
    bzero(myBuffer, length);
    for (int i = 0; i < length; i++) {
        unsigned int anInt;
        NSString * hexCharStr = [content substringWithRange:NSMakeRange(i*2, MIN(content.length - i*2, 2))];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i] = (char)anInt;
        [logContent appendFormat:@"%@%@", logContent.length ? @" " : @"", hexCharStr];
    }
    data = [NSData dataWithBytes:myBuffer length:length];
    free(myBuffer);
    
    [[RYBlueToothTool sharedInstance] writeValue:data forCharacteristic:[RYBlueToothTool sharedInstance].writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
- (void)setMode:(NSInteger)index unit:(NSString *)strUnit{
    Byte b[7];
    b[0] = 0xF5;
    b[1] = 0x11;
    b[2] = 0x02;
    switch (index) {
            case 0:
            b[3] = 0x01;
            break;
            case 1:
            b[3] = 0x00;
            break;
            case 2:
            b[3] = 0x02;
            break;
        default:
            break;
    }
    b[4] = [strUnit isEqualToString:@"℃"] ? 0x00:0x01;
    b[5] = (Byte)(b[3] + b[4]);
    b[6] = 0xFF;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [[RYBlueToothTool sharedInstance] writeValue:data forCharacteristic:[RYBlueToothTool sharedInstance].writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)cancelScan{
    [baby cancelScan];
}

- (void)cancelConnection{
    [baby cancelAllPeripheralsConnection];
}

@end

