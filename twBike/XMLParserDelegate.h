//
//  XMLParserDelegate.h
//  twBike
//
//  Created by huang on 2016/8/23.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BikeInformation.h"
@interface XMLParserDelegate : NSObject<NSXMLParserDelegate>



- (NSMutableArray *) getInfo;

@end
