//
//  SZSingleton.h
//  SZShop
//
//  Created by szgw on 16/10/26.
//  Copyright © 2016年 SZGW. All rights reserved.
//

#define SZSingleton_H + (instancetype)sharedInstance;

#define SZSingleton_M \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
