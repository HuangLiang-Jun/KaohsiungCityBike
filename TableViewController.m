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



@interface TableViewController ()<UISearchBarDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tabelView;
@property (strong,nonatomic) NSMutableArray *cellArr;
@property (strong,nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) UISearchBar *searchBar;

@end



@implementation TableViewController {
    BikeInformation *info ;


}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"站點列表";
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    [self changeSearchCancelButtonToChinese];
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.placeholder = @"請輸入站名或路名";
    
    self.navigationItem.titleView = _searchBar;

    _searchResults = [[NSMutableArray alloc]initWithArray:_bikeDetail];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_searchResults.count == 0) {
        return 1;
    }
    
    return _searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (_searchResults.count == 0) {
        cell.textLabel.text = @"沒有資料";
        cell.detailTextLabel.text = @"";
        return cell;
    }
    
    info = _searchResults[indexPath.row];
    NSLog(@"%@",info.stationName);
    
    cell.textLabel.text =info.stationName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"剩餘車輛:%@  空位:%@",info.stationNums1,info.stationNums2];
    //自適應字體
    cell.detailTextLabel.adjustsFontSizeToFitWidth= YES;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchResults.count == 0) {
        return;
    }
    
    if (_searchBar.isFirstResponder) [_searchBar resignFirstResponder];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];

    
    detailVC.each = _searchResults[indexPath.row];
    
    [self showViewController:detailVC sender:nil];
    

}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [_searchResults removeAllObjects];
    
    if ([searchText isEqualToString:@""]) {
        [_searchResults addObjectsFromArray:_bikeDetail];
        
    } else {
    
        for (int i = 0 ; i < _bikeDetail.count; i++) {
            
            BikeInformation *tmp = _bikeDetail[i];
            if ([tmp.stationName.lowercaseString rangeOfString:searchText].length != 0 || [tmp.stationAddress.lowercaseString rangeOfString:searchText].length != 0) {
                [_searchResults addObject:tmp];
                
            }
        }
    }
    
    [_tabelView reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    NSLog(@"search bar clicked cancel.");
    
    [_searchResults removeAllObjects];
    [_searchResults addObjectsFromArray:_bikeDetail];
    [_tabelView reloadData];
    [searchBar endEditing:true];
    searchBar.text = @"";
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];


}

-(void) changeSearchCancelButtonToChinese {

    for (UIView *view in _searchBar.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                
                UIButton *cancelButton = (UIButton*)subview;
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                return;
            }
        }
    }

}



@end

