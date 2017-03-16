//
//  DetectNetworkStatus.h
//  twBike
//
//  Created by huang on 2016/11/28.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StatusSingleton.h"


@protocol NetworkConnectionProtocol <NSObject>

@optional

-(void) networkConnection;

@end

@interface DetectNetworkStatus : NSObject
HMSingletonH(DetectNetworkStatus)

+ (instancetype) shareInstance;

- (instancetype) initWithVC:(UIViewController *)viewController;

- (void) currentNetworkStatus;

- (void) startDetectNetworkStatus;

- (void) startDetectNetworkWithHost:(NSString *)hostName;



@end



