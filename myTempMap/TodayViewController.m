//
//  TodayViewController.m
//  myTempMap
//
//  Created by huang on 2016/10/7.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetTableViewCell.h"
#import "ServerCommunicator.h"
#import "XMLParserDelegate.h"
#import <CoreLocation/CoreLocation.h>

#define STATION_NAME @"Station"
#define DISTANCE @"Distance"
#define BIKE_NUMS @"BikeNums"
#define PARKINF_SPACE @"Parking"


@interface TodayViewController () <NCWidgetProviding,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *finalStationsInfo;

@end



@implementation TodayViewController
{
    ServerCommunicator *comm;
    XMLParserDelegate *parserDelegate;
    NSMutableArray *stationArr;
    BikeInformation *bikeItem;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    CLLocationDistance distance;
    CLLocation *stationLocation;
    // NSMutableArray *finalStationsInfo;
    BOOL getUserLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(320.0, 320.0);// For iOS9 and before
    
    // For iOS 10
    if ([self.extensionContext respondsToSelector:@selector(widgetLargestAvailableDisplayMode)]) {
        
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
    // Default
    getUserLocation = true;
    _finalStationsInfo = [NSMutableArray new];
    comm = [ServerCommunicator shareInstance];
    [comm startToDownloadData:^(NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Loading fail:%@",error);
            return;
        }
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        parserDelegate = [XMLParserDelegate new];
        parser.delegate = parserDelegate;
        BOOL success = [parser parse];
        
        if (success) {
            NSLog(@"parse OK");
            stationArr = [parserDelegate getInfo];
            //NSLog(@"staionArr:%@",stationArr);
            [self calculateUserAndStationsDistance];
        }
        
    }];
    
    
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeOtherNavigation;
    [locationManager startUpdatingLocation];
    
}

-(void) widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
        
    }else if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        
        self.preferredContentSize = CGSizeMake(320,300);
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if (getUserLocation) {
        NSLog(@"userLocation");
        getUserLocation = false;
        userLocation = locations.lastObject;
        
    }
}

-(void) calculateUserAndStationsDistance{
    NSMutableDictionary *itemDict = [NSMutableDictionary new];
    
    for (int i = 0; i < stationArr.count; i++) {
        bikeItem = stationArr[i];
        stationLocation = [[CLLocation alloc]initWithLatitude:[bikeItem.stationLat doubleValue] longitude:[bikeItem.stationLon doubleValue]];
        distance = [userLocation distanceFromLocation:stationLocation];
        NSNumber *distansNum = [NSNumber numberWithDouble:distance] ;
        //NSLog(@"distance: %f",distance);
        
        //if (distance < 800){
        NSDictionary *stationInfo = @{DISTANCE:distansNum,STATION_NAME:bikeItem.stationName,BIKE_NUMS:bikeItem.stationNums1,PARKINF_SPACE:bikeItem.stationNums2};
        [itemDict setObject:stationInfo forKey:distansNum];
        
        
        //}
    }
    NSArray *sortArr = itemDict.allKeys;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    // NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:true selector:@selector(compare:)];
    NSArray *fainalSort = [sortArr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    NSLog(@"finalsort: %@",fainalSort);
    for (int i = 0; i < fainalSort.count; i++) {
        [_finalStationsInfo addObject:itemDict[fainalSort[i]]];
        
    }
    NSLog(@"finalStationscount: %lu",_finalStationsInfo.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mainTableView reloadData];
    });
    
}

#pragma -mark TableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_finalStationsInfo.count == 0) {
        return 1;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WidgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // NSLog(@"finalStationCount: %@",_finalStationsInfo);
    if (_finalStationsInfo.count == 0) {
        cell.textLabel.text = @"Loading...";
    }else{
        cell.textLabel.text = @"";
        cell.stationName.text = _finalStationsInfo[indexPath.row][STATION_NAME];
        cell.bikes.text = [NSString stringWithFormat:@"可借:%@",_finalStationsInfo[indexPath.row][BIKE_NUMS]];
        cell.parkingSpace.text =[NSString stringWithFormat:@"| 空位:%@", _finalStationsInfo[indexPath.row][PARKINF_SPACE]];
        cell.distance.text = [NSString stringWithFormat:@"距離:%1.2f公里",[_finalStationsInfo[indexPath.row][DISTANCE] doubleValue] /1000 ];
    }
    
    return cell;
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
