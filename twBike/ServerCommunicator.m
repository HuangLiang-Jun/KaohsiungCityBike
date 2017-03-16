//
//  ServerCommunicator.m
//  twBike
//
//  Created by huang on 2016/11/30.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import "ServerCommunicator.h"

#define URL_STRING @"http://www.c-bike.com.tw/xml/stationlistopendata.aspx"

static ServerCommunicator *_serverCommunicator;

@implementation ServerCommunicator

+ (instancetype) shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serverCommunicator = [ServerCommunicator new];
    });
    return _serverCommunicator;
}

-(void) startToDownloadData:(Completion)completion{
    
    NSURL *url = [NSURL URLWithString:URL_STRING];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completion != nil) {
            
            completion (data,error);
            return ;
        }
    }];
    [task resume];
}




@end
