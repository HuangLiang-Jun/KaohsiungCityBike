//
//  ViewController.m
//  twBike
//
//  Created by huang on 2016/8/10.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import "TableViewController.h"
#import "XMLParserDelegate.h"
#import "DetectNetworkStatus.h"
#import "ServerCommunicator.h"
#import "ProgressManager.h"
#import "GoogleDirections.h"


@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,NetworkConnectionProtocol>

{
    
    CLLocationManager *locationManager;
    Reachability *serverReach ;
    BikeInformation *info;
    
}


@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (nonatomic,strong) NSMutableArray *favorArr;
@property (nonatomic,strong) NSMutableArray *bikeInfoArr;
@end

@implementation ViewController
{
    DetectNetworkStatus *networkStatus;
    ServerCommunicator *comm;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressManager showProgress];
    self.bannerView.adUnitID = @"ca-app-pub-1064357173457983/9184236759";
    //test AD
    //self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    comm = [ServerCommunicator shareInstance];

    
    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    //我期待的精確度
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //請告訴蘋果這個app是基於什麼樣的活動
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.delegate = self;
    //show user bluePoint
    _mainMapView.showsUserLocation = true;
    //呈現在手機中地圖縮放距離
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    //地圖中心用高雄市政府的經緯度
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(22.620738,120.312048 ), span);
    
    [_mainMapView setRegion:region animated:true];
    
    UIBarButtonItem *aboutMe = [[UIBarButtonItem alloc]initWithTitle:@"關於我" style:UIBarButtonItemStylePlain target:self action:@selector(aboutMeAlert)];
    self.navigationItem.leftBarButtonItems = @[aboutMe];
    self.navigationItem.title = @"單車資訊";
    //偵測網路有無連
    networkStatus = [[DetectNetworkStatus shareInstance]initWithVC:self];
    [networkStatus startDetectNetworkWithHost:@"www.c-bike.com.tw/xml/stationlistopendata.aspx"];
    
}

#pragma mark - check NetWork &downLoad Data
//網路狀態改變通知
-(void)networkConnection{
    
    [self downLoadList];

}

-(void)downLoadList{
    //資料下載
        [comm startToDownloadData:^(NSData *data, NSError *error) {
        if (error) {
            [ProgressManager dismissProgress];
            NSLog(@"Download Fail: %@",error);
            return;
        }
        
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        XMLParserDelegate *parserDelegate = [XMLParserDelegate new];
        //parser解析的時候可以跟parserDelegate做溝通
        parser.delegate = parserDelegate;
        // 開始解析 會回傳布林值 解析的結果 如果失敗通常原因：網路問題
        BOOL success = [parser parse];
        //可以檢驗解出來的格式是否正確 網站-->XML Validate
        if (success) {
            NSLog(@"Parser OK.");
            _bikeInfoArr = [parserDelegate getInfo];
            //如果資料解析ＯＫ 就放大頭針
            
            if(_bikeInfoArr.count != 0){
                for (int i = 0; i<_bikeInfoArr.count; i++) {
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                    info = _bikeInfoArr[i];
                    annotation.coordinate = CLLocationCoordinate2DMake([info.stationLat doubleValue], [info.stationLon doubleValue]);
                    
                    annotation.title = info.stationName ;
                    annotation.subtitle = [NSString stringWithFormat:@"剩餘車輛:%@,空位:%@",info.stationNums1,info.stationNums2];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_mainMapView addAnnotation:annotation];
                    });
                }
                [ProgressManager dismissProgress];
            }else{
                [ProgressManager dismissProgress];
                NSLog(@"Parser Fail.");
            }
        }
    }];
}

#pragma mark - set custom ann

//加入自定義的大頭針
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //檢查如果annotation是userLocation的話就保持原本的預設藍點
    if (annotation == mapView.userLocation) {
        return nil;
    }
    NSString *reusedID = @"Store";
    //自訂圖標 改成沒有Pin的版本
    //抓到的會是一片空白的大頭針
    MKAnnotationView *result =[mapView dequeueReusableAnnotationViewWithIdentifier:reusedID];
    //如果沒有拿到pin就創造一個新的
    if (result == nil) {
        //自訂圖標
        result =[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reusedID];
        //如果拿到就放到annotation中
    }else{
        result.annotation= annotation;
    }
    //大頭針的圖
    result.canShowCallout = true;
    UIImage *image = [UIImage imageNamed:@"Annotate.png"];
    result.image = image;
    
    //infoWindow left image
    result.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"Ann.png"]];

    
    return result;
}



//點到大頭針可以取得資料

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view{
    
    NSString *userLatStr = [NSString stringWithFormat:@"%f",mapView.userLocation.location.coordinate.latitude];
    NSString *userLonStr = [NSString stringWithFormat:@"%f",mapView.userLocation.location.coordinate.longitude];
    
    NSString *stattionLat = [NSString stringWithFormat:@"%f",view.annotation.coordinate.latitude];
    NSString *stattionLon = [NSString stringWithFormat:@"%f",view.annotation.coordinate.longitude];
    
    
    GoogleDirections *direction = [GoogleDirections new];
    [direction enterPositionWithOriginLat:userLatStr lon:userLonStr destinationLat:stattionLat lon:stattionLon doneHandle:^(NSData *data, NSError *error) {
        
    }];
    
}



#pragma mark - myLoactionBtn
//定位按鈕！
- (IBAction)myLocationBtn:(id)sender {

    _mainMapView.userTrackingMode = MKUserTrackingModeFollow;

}

#pragma mark  - about alert & send mail


//關於我-->alert
-(void)aboutMeAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"關於我" message:@"提供高雄市C-Bike站點位置及單車即時資訊。" preferredStyle:UIAlertControllerStyleAlert];
    //確認的action
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    //第二的action
    UIAlertAction *eMail = [UIAlertAction actionWithTitle:@"意見回饋" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"寫信");
        [self createMFMailEven];
        
    }];
    [alert addAction:eMail];
    //講警告呈現視窗上
    [self presentViewController:alert animated:YES completion:nil];
}


// MFMail DelegateMethod.
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSString *status ;
    switch (result)
    {
        case MFMailComposeResultCancelled: // 取消编辑
            NSLog(@"Mail send canceled...");
            status = @"取消編輯";
            break;
        case MFMailComposeResultSaved: // 儲存
            NSLog(@"Mail saved...");
            status = @"儲存完成";
            break;
        case MFMailComposeResultSent: // 發送
            NSLog(@"Mail sent...");
            status = @"發送成功";
            break;
        case MFMailComposeResultFailed: // 發送失敗
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            status = @"發送失敗";
            break;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        UIAlertController *al = [UIAlertController alertControllerWithTitle:status message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [al addAction:ac];
        [self presentViewController:al animated:YES completion:nil];
    }];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) createMFMailEven{
    
    //創一個mail物件
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    //指定delegate為self
    mailController.mailComposeDelegate = self;
    //收件人
    [mailController setToRecipients:[NSArray arrayWithObjects:@"bboydais@hotmail.com", nil]];
    //標題
    [mailController setSubject:@"意見回饋"];
    //body
    [mailController setMessageBody:@"意見填寫： " isHTML:NO];
    //呼叫電子郵件畫面
    [self presentViewController:mailController animated:YES completion:nil];
    
}

#pragma mark - value to TableView VC

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TableViewController *VC = segue.destinationViewController;
    
    VC.bikeDetail = self.bikeInfoArr;
    
}


@end
