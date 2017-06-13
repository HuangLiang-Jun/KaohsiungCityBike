//
//  ProgressManager.m
//  twBike
//
//  Created by huang on 2017/6/11.
//  Copyright © 2017年 Huang. All rights reserved.
//

#import "ProgressManager.h"
#import <SVProgressHUD/SVProgressHUD.h>


@implementation ProgressManager

+ (void) showProgress {

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}

+ (void) dismissProgress {

    [SVProgressHUD dismiss];

}

@end
