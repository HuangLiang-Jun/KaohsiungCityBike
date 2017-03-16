//
//  WidgetTableViewCell.h
//  
//
//  Created by huang on 2016/12/1.
//
//

#import <UIKit/UIKit.h>

@interface WidgetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *bikes;
@property (weak, nonatomic) IBOutlet UILabel *parkingSpace;

@end
