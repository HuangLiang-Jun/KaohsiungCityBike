//
//  XMLParserDelegate.m
//  twBike
//
//  Created by huang on 2016/8/23.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import "XMLParserDelegate.h"

@implementation XMLParserDelegate
{
    
    BikeInformation *bikeInfor;
    NSMutableString *currentElementValue;
    NSMutableArray *results;
    
}
//找到開始標籤
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"Station"]) {
        //找到標籤把bikeinfo初始化
        bikeInfor = [BikeInformation new];
    }else if ([elementName isEqualToString:@"StationName"]){
        //站名
        currentElementValue = nil;
    }else if ([elementName isEqualToString:@"StationAddress"]){
        //站址
        currentElementValue = nil;
    }else if ([elementName isEqualToString:@"StationLat"]){
        //緯度
        currentElementValue = nil;
    }else if ([elementName isEqualToString:@"StationLon"]){
        //經度
        currentElementValue = nil;
    }else if ([elementName isEqualToString:@"StationNums1"]){
        //剩餘車輛
        currentElementValue = nil;
    }else if ([elementName isEqualToString:@"StationNums2"]){
        //空位
        currentElementValue = nil;
    }
    
    
}

//找到標籤後的動作
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (currentElementValue == nil) {
        currentElementValue = [[NSMutableString alloc]initWithString:string];
    }else{
        //有可能分段進來
        [currentElementValue appendString:string];
    }
}

//找到結束標籤
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"Station"]) {
        if (results == nil) {
            results = [NSMutableArray new];
        }
        [results addObject:bikeInfor];
        bikeInfor = nil;
    }else if ([elementName isEqualToString:@"StationName"]){
        //站名
        bikeInfor.stationName =currentElementValue;
    }else if ([elementName isEqualToString:@"StationAddress"]){
        //站址
        bikeInfor.stationAddress =currentElementValue;
    }else if ([elementName isEqualToString:@"StationLat"]){
        //緯度
        bikeInfor.stationLat =currentElementValue;
    }else if ([elementName isEqualToString:@"StationLon"]){
        //經度
        bikeInfor.stationLon =currentElementValue;
    }else if ([elementName isEqualToString:@"StationNums1"]){
        //剩餘車輛
        bikeInfor.stationNums1 =currentElementValue;
    }else if ([elementName isEqualToString:@"StationNums2"]){
        //空位
        bikeInfor.stationNums2 =currentElementValue;
    }
    currentElementValue = nil;
    
}


-(NSMutableArray *)getInfo{
    return results;
}

@end
