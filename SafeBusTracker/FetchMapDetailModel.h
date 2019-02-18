//
//  FetchMapDetailModel.h
//  SafeBusTracker
//
//  Created by veena on 17/06/15.
//  Copyright (c) 2015 RainConcert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchMapDetailModel : NSObject
//Fetch Map detail model class used for saving map details

@property (nonatomic, strong) NSMutableArray *dataarray;
@property (nonatomic, strong) NSString *end_location_lat;
@property (nonatomic, strong) NSString *end_location_lon;
@property (nonatomic, strong) NSString *end_locationName;
@property (nonatomic, strong) NSString *start_location_lat;
@property (nonatomic, strong) NSString *start_location_lon;
@property (nonatomic, strong) NSString *start_locationName;
@property (nonatomic, strong) NSMutableArray *upcoming_locations;
@property (strong, nonatomic) NSMutableArray *visited_locations;
@property (nonatomic, strong) NSString *bus_name;
@property (nonatomic, strong) NSString *bus_status;
@property (nonatomic, strong) NSString *bus_location_lat;
@property (nonatomic, strong) NSString *bus_location_lon;

@end
