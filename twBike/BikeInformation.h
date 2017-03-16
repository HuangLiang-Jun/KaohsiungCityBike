//
//  BikeInformation.h
//  twBike
//
//  Created by huang on 2016/8/23.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParserDelegate.h"
@interface BikeInformation : NSObject
//儲存XML資料的容器
//站名
@property (nonatomic,strong) NSString *stationName;
//經緯度
@property (nonatomic,strong) NSString *stationLon;
@property (nonatomic,strong) NSString *stationLat;
//大概位置
@property (nonatomic,strong) NSString *stationAddress;
//剩餘車輛
@property (nonatomic,strong) NSString *stationNums1;
//空位
@property (nonatomic,strong) NSString *stationNums2;


@end
