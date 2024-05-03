//
//  RYBlueToothTool.h
//  SmartInsole
//
//  Created by Think on 2017/10/19.
//  Copyright © 2017年 Eden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZSingleton.h"
#import <RYCOMSDK/BabyBluetooth.h>
@class BZDeviceEntity;

@protocol RYBlueToothToolDelegate<NSObject>

@optional

- (void)blueToothState:(BOOL)open;

- (void)connectionFail:(CBPeripheral *)peripheral;

- (void)matchSuccess:(CBPeripheral *)peripheral;

- (void)onDisconnect:(CBPeripheral *)peripheral;

- (void)connectionSuccess:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;

- (void)getReturnValue:(NSString *)data;

@end

@interface RYBlueToothTool : NSObject

SZSingleton_H
- (void)setupBluetooth;
- (void)scanBluetooth;
- (void)connectBluetooth;
- (void)writeData;
- (void)setMode:(NSInteger)index unit:(NSString *)strUnit;

//保存连接的设备和特征
@property (nonatomic,strong) CBPeripheral *connectedPeripheral;
@property (nonatomic,strong) CBCharacteristic *writeCharacteristic;

@property (nonatomic,copy) NSString *UUIDString;
// 蓝牙是否打开
@property (nonatomic,assign) BOOL blueToothOpen;

@property (nonatomic,weak) id<RYBlueToothToolDelegate> delegate;

- (void)cancelScan;

- (void)cancelConnection;

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;

@end
