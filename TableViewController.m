//
//  TableViewController.m
//  twBike
//
//  Created by huang on 2016/8/14.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "BikeInformation.h"
#import "DetailViewController.h"
@interface TableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tabelView;
//searchBar



@property (strong,nonatomic) NSMutableArray *cellArr;
//for searchBar陣列
//@property (strong,nonatomic) NSMutableArray *searchList;
@end

@implementation TableViewController
{
    BikeInformation *info ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"站點列表";
    //_searchList = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _bikeDetail.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    info = _bikeDetail[indexPath.row];
    NSLog(@"%@",info.stationName);
    
    cell.textLabel.text =info.stationName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"剩餘車輛:%@  空位:%@",info.stationNums1,info.stationNums2];
    //自適應字體
    cell.detailTextLabel.adjustsFontSizeToFitWidth= YES;
    return cell;
}

//點擊cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //點擊時的灰色動畫
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //傳值給detailVC
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    //方法一
    // detailVC.stationDetail = _bikeDetail[indexPath.row];
    
    detailVC.each = _bikeDetail[indexPath.row];
    
    [self showViewController:detailVC sender:nil];
    //NSLog(@"列印列印%@",_bikeDetail[indexPath.row]);

}

#pragma search bar


@end
