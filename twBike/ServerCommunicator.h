//
//  ServerCommunicator.h
//  twBike
//
//  Created by huang on 2016/11/30.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^Completion)(NSData *data, NSError *error);

@interface ServerCommunicator : NSObject

+ (instancetype) shareInstance;

- (void) startToDownloadData:(Completion)completion;


@end
