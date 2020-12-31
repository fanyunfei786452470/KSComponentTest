//
//  Header.h
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#ifndef KSHeader_h
#define KSHeader_h

#define IS_IPhoneX \
({BOOL IS_IPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
IS_IPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(IS_IPhoneX);})

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SafeArea_TopBarHeight    (IS_IPhoneX ? 88.f : 64.f)
#define SafeArea_StatusBarHeight (IS_IPhoneX ? 44 : 20)
#define SafeArea_TabbarBarHeight (IS_IPhoneX ? 83 : 49)
#define SafeArea_NavBarHeight 44
#define SafeArea_BottomMargin    (IS_IPhoneX ? 34.f : 0.f)
#define SafeArea_TopMargin       (IS_IPhoneX ? 24.f : 0.f)

#endif /* KSHeader_h */
