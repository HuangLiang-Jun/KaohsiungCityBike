//
//  DetailViewController.h
//  twBike
//
//  Created by huang on 2016/8/28.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeInformation.h"

@interface DetailViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *stationDetail;

//方法二
//@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) BikeInformation * each;

@end
