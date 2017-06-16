//
//  GoogleDirections.m
//  twBike
//
//  Created by huang on 2017/6/16.
//  Copyright © 2017年 Huang. All rights reserved.
//

#import "GoogleDirections.h"



@implementation GoogleDirections

NSString *fullUrlStr = @"https://maps.googleapis.com/maps/api/directions/json?origin=%@,%@&destination=%@,%@&mode=bicycling&key=AIzaSyDjY13yGQExPbOb3RJucafS5NTc4VN6KJ4";
// walking & default driving

- (void) enterPositionWithOriginLat:(NSString *)lat lon:(NSString *)lon destinationLat:(NSString *)lat2 lon:(NSString *)lon2 doneHandle:(Completion)completion {

    
    NSString *fullUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@,%@&destination=%@,%@&key=AIzaSyDjY13yGQExPbOb3RJucafS5NTc4VN6KJ4",lat,lon,lat2,lon2];
    
    NSURL *url = [[NSURL alloc]  initWithString:fullUrlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error != NULL) {
            NSLog(@"get navigation error: %@",error.description);
            return;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonData: %@", jsonStr);
        
    }] resume];
    
}


@end
