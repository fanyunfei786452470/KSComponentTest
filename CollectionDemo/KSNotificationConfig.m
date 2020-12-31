//
//  KSNotificationConfig.m
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import "KSNotificationConfig.h"

NSString *const KSScrollViewContentOffsetXKey = @"KSScrollViewContentOffsetXKey";

@implementation KSNotificationConfig

+ (instancetype)sharedManager {
    static KSNotificationConfig *___manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ___manager = [KSNotificationConfig new];
    });
    
    return ___manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


@end
