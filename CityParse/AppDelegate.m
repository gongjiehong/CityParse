//
//  AppDelegate.m
//  CityParse
//
//  Created by 龚杰洪 on 16/7/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "AppDelegate.h"
#import "LGCityHelper.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSMutableArray *array = [LGCityHelper getCountrysList];
    
    NSLog(@"%@", array);
    
    NSMutableSet *set = [NSMutableSet set];
    
    for (LGCountryModel *model in array)
    {
        NSLog(@"%@", model.name);
        [set addObject:model.name];
    }
    
    NSLog(@"%@", set);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:nil];
    NSString *json = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    NSArray *cityArr = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
    NSLog(@"%@", cityArr);
    
    for (id country in cityArr)
    {
        if ([[country objectForKey:@"state"] isKindOfClass:[NSArray class]])
        {
            for (id state in [country objectForKey:@"state"])
            {
                if ([[state objectForKey:@"city"] isKindOfClass:[NSDictionary class]])
                {
                    
                }
                else if ([[state objectForKey:@"city"] isKindOfClass:[NSArray class]])
                {
                    
                }
                else
                {
                    NSLog(@"%@", [state objectForKey:@"city"]);
                }
            }
        }
        else if([[country objectForKey:@"state"] isKindOfClass:[NSDictionary class]])
        {
//            NSLog(@"%@", [[country objectForKey:@"state"] objectForKey:@"name"]);
        }
        else
        {
//            NSLog(@"%@", country);
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
