//
//  AppDelegate.m
//  EduHeader
//
//  Created by HaoKing on 8/6/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "APService.h"
#import "SlideNavigationController.h"
#import "EHNewsDetailViewController.h"

#import "EHGlobalSingleton.h"

#import "MobClick.h"
#import "EHMacro.h"

#import "UMCheckUpdate.h"

static const NSString *kPushNotificationKey_NewsID = @"newsid";
static const CGFloat kPublicLeftMenuWidth = 180.0f;

static NSString *kHistoryLocationCity = @"kHistoryLocationCity";

@interface AppDelegate ()<CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)NSString *currentCity;
@property (nonatomic, strong)CLLocationManager *manager;
@property (nonatomic, assign)NSInteger gpsFinishCounter;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *leftMenu = (UIViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"P-2-back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"P-2-back"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.gpsFinishCounter = 0;
        [self locateUserCity];
    });
    
    // UMeng 注册
    [MobClick startWithAppkey:@"56331ae1e0f55a6a5200429b"];
    
    // share SDK
    [ShareSDK registerApp:@"9c1367d6ce6c"
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType) {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wxc947d704c666a6d9" appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104855559" appKey:@"VZwezr94cbLLicDG" authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"2802332262" appSecret:@"ede1716b850997a6b36bfa76f61537ab" redirectUri:@"http://www.focus001.com" authType:SSDKAuthTypeBoth];
                      break;
                      
                  default:
                      break;
              }
          }];
    
    [NSThread sleepForTimeInterval:2];
    
    NSString *isOn;
    isOn = [[NSUserDefaults standardUserDefaults] stringForKey:@"vPushSwitchValue"];
    
    if (!isOn) {
        isOn = [NSString stringWithFormat:@"%d", YES];
        [[NSUserDefaults standardUserDefaults] setValue:isOn forKey:@"vPushSwitchValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (isOn) {
        // Required
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
        
        // Required
        [APService setupWithOption:launchOptions];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [UMCheckUpdate checkUpdateWithAppkey:@"56331ae1e0f55a6a5200429b" channel:nil];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [self pushToDetailNewsViewWithNewsID:[userInfo objectForKey:kPushNotificationKey_NewsID]];
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self pushToDetailNewsViewWithNewsID:[userInfo objectForKey:kPushNotificationKey_NewsID]];
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)pushToDetailNewsViewWithNewsID:(NSString *)newsid
{
    if (!newsid || [newsid isEqualToString:@""]) {
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"非法推送新闻id，请检查推送附加字段中是否增加\"newsid\"字段，并确认此字段对应值是合法的新闻id。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alertMessage show];
        
        return;
    }
    
    EHNewsDetailViewController *newsDetailVC = [EHNewsDetailViewController new];
    newsDetailVC.newsID = newsid;
    
    [[SlideNavigationController sharedInstance] pushViewController:newsDetailVC animated:YES];
}

- (void)locateUserCity
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.distanceFilter = 1000.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
            [self.manager requestWhenInUseAuthorization];
            [self.manager requestAlwaysAuthorization];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0) {
            [self.manager requestLocation];
        }
        
        [self.manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        self.gpsFinishCounter ++;
        
        if (self.gpsFinishCounter > 1) {
            return;
        }
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *locCity = placeMark.locality;
            locCity = [locCity stringByReplacingOccurrencesOfString:@"市" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(locCity.length - 1, 1)];
            
            if (!locCity) {
                locCity = @"";
            }
            
            NSString *historyCity = [[NSUserDefaults standardUserDefaults] stringForKey:kHistoryLocationCity];
            
            self.currentCity = locCity;
            if (historyCity && ![historyCity isEqualToString:locCity]) {
                // 2015-12-04 老杨提出最新需求，定位只进行一次，以后都不再切换城市信息。
                /*
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"切换城市" message:[NSString stringWithFormat:@"当前城市为%@，是否要切换到%@", historyCity, self.currentCity] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"切换", nil];
                
                [alertView show];
                 */
            } else {
                [self recordGpsCityAndNotifyWithNewGpsCity:self.currentCity];
            }
            
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error returned");
        } else if (error) {
            NSLog(@"Location error: %@", error);
        }
     }];
    
    [manager stopUpdatingLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        [self recordGpsCityAndNotifyWithNewGpsCity:self.currentCity];
    }
}

- (void)recordGpsCityAndNotifyWithNewGpsCity:(NSString *)cityName
{
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kHistoryLocationCity];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [EHGlobalSingleton sharedInstance].gpsCity = self.currentCity;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_GpsCityChanged object:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


@end
