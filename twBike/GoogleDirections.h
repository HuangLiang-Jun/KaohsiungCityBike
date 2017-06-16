//
//  GoogleDirections.h
//  twBike
//
//  Created by huang on 2017/6/16.
//  Copyright © 2017年 Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(NSData *data, NSError *error);

@interface GoogleDirections : NSObject


- (void) enterPositionWithOriginLat:(NSString *)lat lon:(NSString *)lon destinationLat:(NSString *)lat2 lon:(NSString *)lon2 doneHandle:(Completion)completion;

@end
