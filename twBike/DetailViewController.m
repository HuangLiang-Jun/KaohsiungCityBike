//
//  DetailViewController.m
//  twBike
//
//  Created by huang on 2016/8/28.
//  Copyright © 2016年 Huang. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"
#import "BikeInformation.h"
@interface DetailViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *detailMapView;



@property (weak, nonatomic) IBOutlet UILabel *station;
@property (weak, nonatomic) IBOutlet UILabel *bikeNum;
@property (weak, nonatomic) IBOutlet UILabel *parkNum;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"站點資訊";
    _station.adjustsFontSizeToFitWidth = YES;
        //label弧度
    _bikeNum.layer.cornerRadius = 11;
    _bikeNum.layer.masksToBounds=TRUE;
    _parkNum.layer.cornerRadius = 11;
    _parkNum.layer.masksToBounds=TRUE;
    

    //顯示文字 站名
    _station.text = [NSString stringWithFormat:@"%@", self.each.stationName];
    //剩餘車輛
    _bikeNum.text = [NSString stringWithFormat:@" 剩餘車輛:%@", self.each.stationNums1];
    //空位
    _parkNum.text = [NSString stringWithFormat:@" 空位:%@",self.each.stationNums2];
    //地圖顯示資訊
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([self.each.stationLat doubleValue], [self.each.stationLon doubleValue]);
    
//---
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(coor, span);
    [_detailMapView setRegion:region animated:TRUE];
    
    //add ann
    MKPointAnnotation *ann = [MKPointAnnotation new];
    ann.coordinate = coor;
    
    [_detailMapView addAnnotation:ann];

}
//anntation style
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
   MKAnnotationView *result =[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"store"];
    
    result.image = [UIImage imageNamed:@"Annotate.png"];
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
