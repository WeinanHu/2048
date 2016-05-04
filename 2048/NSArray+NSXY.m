//
//  NSArray+NSXY.m
//  2048
//
//  Created by tarena on 16/4/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NSArray+NSXY.h"

@implementation NSArray (NSXY)
-(NSNumber*)arrayNumberInX:(int)x inY:(int)y lineLength:(int)length{
    return self[y*length+x];
}
@end
