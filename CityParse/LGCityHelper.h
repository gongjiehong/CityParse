//
//  LGCityHelper.h
//  CityParse
//
//  Created by 龚杰洪 on 16/7/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGCountryModel.h"

@interface LGCityHelper : NSObject


+ (NSMutableArray *)getCountrysList;

+ (NSMutableArray *)getStatesListByCountryName:(NSString *)countryName;


@end
