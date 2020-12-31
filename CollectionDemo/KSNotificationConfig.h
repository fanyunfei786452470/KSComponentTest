//
//  KSNotificationConfig.h
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const KSScrollViewContentOffsetXKey;

@interface KSNotificationConfig : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSString *notificationKey;

@end
