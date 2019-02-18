//
//  MapViewController.h
//  SafeBusTracker
//
//  Created by veena on 15/06/15.
//  Copyright (c) 2015 RainConcert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
//map
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
// class model hit
#import "FetchMapDetailModel.h"
//server hit
#import "ConnectionOperation.h"
#import "MBProgressHUD.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,HTTPConnectionDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>{
    ConnectionOperation *connection;//declare connection class object
    MBProgressHUD *HUD;// declare activityindicator class object
    NSMutableArray *arrayBusNames; //declare array for bus names
    FetchMapDetailModel  *fetchMapDetails; //declare class model object

}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;//declare mapview object
@property (strong, nonatomic) NSString *parentName;//decalre string  parent name
@property (strong, nonatomic) IBOutlet UILabel *lbl_parentName;//declare label parentName
@property (strong, nonatomic) IBOutlet UILabel *lbl_titleHeader;//declare label title header
@property (strong, nonatomic) IBOutlet UILabel *lbl_busStatus;//declare label bus status
@property (strong, nonatomic) IBOutlet UIButton *btn_type;//declare button type
@property (strong, nonatomic) NSMutableArray *array_Map_Details;//declare array for map details
@property (strong, nonatomic) IBOutlet UILabel *lbl_busName;//declare label busname
@property (strong, nonatomic) IBOutlet UITableView *tblview_DropDown;//declare tableview for dropdown
@property (strong, nonatomic)NSTimer *timer;

- (IBAction)refreshSelected:(UIButton *)sender;
- (IBAction)changeMapType:(id)sender;
- (IBAction)logoutSelected:(UIButton *)sender;
- (IBAction)dropDownSelected:(UIButton *)sender;


@end
