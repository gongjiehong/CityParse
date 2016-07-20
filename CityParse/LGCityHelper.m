//
//  LGCityHelper.m
//  CityParse
//
//  Created by 龚杰洪 on 16/7/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "LGCityHelper.h"

@implementation LGCityHelper

NSArray *cityArr()
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:nil];
    NSString *json = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    NSArray *cityArr = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
    return cityArr;
}

+ (NSMutableArray *)getCountrysList
{
    NSMutableArray *returnArray = [@[] mutableCopy];
    for (id country in cityArr())
    {
        LGCountryModel * returnModel = [[LGCountryModel alloc] initWithDictionary:country];
        if ([[country objectForKey:@"state"] isKindOfClass:[NSArray class]])
        {
            returnModel.has_child_state = true;
            returnModel.has_child_city = true;
        }
        else if([[country objectForKey:@"state"] isKindOfClass:[NSDictionary class]])
        {
            returnModel.has_child_state = false;
            returnModel.has_child_city = true;
        }
        else
        {
            returnModel.has_child_state = false;
            returnModel.has_child_city = false;
        }
        [returnArray addObject:returnModel];
    }
    return returnArray;
}

+ (NSMutableArray *)getStatesListByCountryName:(NSString *)countryName
{
    NSMutableArray *returnArray = [@[] mutableCopy];
    NSDictionary *country = nil;
    for (id tempCountry in cityArr())
    {
        if ([[tempCountry objectForKey:@"name"] isEqualToString:@"countryName"])
        {
            country = tempCountry;
            break;
        }
        else
        {
            continue;
        }
    }
    if ([[country objectForKey:@"state"] isKindOfClass:[NSArray class]])
    {
        for (id tempState in [country objectForKey:@"state"])
        {
            LGStateModel *model = [[LGStateModel alloc] initWithDictionary:tempState];
            [returnArray addObject:model];
        }
    }
    else if([[country objectForKey:@"state"] isKindOfClass:[NSDictionary class]])
    {
        LGStateModel *model = [[LGStateModel alloc] initWithDictionary:[country objectForKey:@"state"]];
        [returnArray addObject:model];
    }
    else
    {
        NSLog(@"%@", [country objectForKey:@"state"]);
    }
    return returnArray;

}


//+ (NSMutableArray *)getCitysListByCountryName:(NSString *)countryName
//{
//    for (id state in [country objectForKey:@"state"])
//    {
//        if ([[state objectForKey:@"city"] isKindOfClass:[NSDictionary class]])
//        {
//            
//        }
//        else if ([[state objectForKey:@"city"] isKindOfClass:[NSArray class]])
//        {
//            
//        }
//        else
//        {
//            
//        }
//    }
//}


@end
