//
//  LGCountryModel.h
//  Sudy
//
//  Created by 龚杰洪 on 16/7/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

@class LGStateModel;
@class LGCityModel;
@interface LGCountryModel : JsonBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

@property (nonatomic, assign) BOOL has_child_state;
@property (nonatomic, assign) BOOL has_child_city;

@end

@interface LGStateModel : JsonBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) BOOL has_child_city;

@end

@interface LGCityModel : JsonBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

@end
