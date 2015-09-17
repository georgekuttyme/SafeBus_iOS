//
//  MapViewController.m
//  SafeBusTracker
//
//  Created by veena on 15/06/15.
//  Copyright (c) 2015 RainConcert. All rights reserved.
//

#import "MapViewController.h"
#import "FetchMapDetailModel.h"
#import "MapViewAnnotation.h"
#import "LoginViewController.h"
@interface MapViewController ()
#define GETLOCATIONDETAILS @"GetLocationDetails"

@end


@implementation MapViewController

//for setting status bar colour

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //retrieve auth key for nsuserdefaults
    NSUserDefaults *retrieveKey = [NSUserDefaults standardUserDefaults];
    NSString *authKey = [retrieveKey stringForKey:@"authKey"];
    
     if(authKey ==nil){
         // auth key becomes nil it can be fetch to login page
         LoginViewController *loginView  = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
         [self.navigationController pushViewController:loginView animated:YES];
         
     }
    
    // Do any additional setup after loading the view from its nib.
    
    _array_Map_Details =[[NSMutableArray alloc]init];
    arrayBusNames = [[NSMutableArray alloc]init];
    
    //timer setting for refreshing map in 1 minute
    _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updatestuff) userInfo:nil repeats:YES];  //60 represents 60 sec means 1 min
    
    [self fetchMapDetails];
    self.navigationController.navigationBar.hidden = YES;
    self.lbl_titleHeader.text = title_name;
    self.lbl_parentName.text = self.parentName;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [_mapView setZoomEnabled:YES];
    self.mapView.mapType = MKMapTypeStandard;
    [_btn_type setTitle: @"Satellite" forState: UIControlStateNormal];
    
    
}
//functionality for timer trigger
-(void)updatestuff{
    [self fetchMapDetails];
}

//function for add annotations in mapview
-(void)addAnnotation{

    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[_array_Map_Details count];i++){
        
        [arrayBusNames addObject: [[_array_Map_Details objectAtIndex:i] bus_name]];
        
        
    }

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    //setting pin in bus location
    CLLocationCoordinate2D locationCoordinates_buslocation  = CLLocationCoordinate2DMake([[[_array_Map_Details objectAtIndex:0] bus_location_lat] doubleValue],[[[_array_Map_Details objectAtIndex:0] bus_location_lon] doubleValue]);
    MapViewAnnotation *annotation_busLocation = [[MapViewAnnotation alloc]initWithTitle:@"" AndCoordinate:locationCoordinates_buslocation image:@"bus_pin"];
    
    
    [annotationArray addObject:annotation_busLocation];
    [self.mapView addAnnotations:annotationArray];
    [annotationArray removeAllObjects];
    
    
    CLLocation *location =[[CLLocation alloc]initWithLatitude:[[[_array_Map_Details objectAtIndex:0] bus_location_lat] doubleValue] longitude:[[[_array_Map_Details objectAtIndex:0] bus_location_lon] doubleValue]];
    [self updateMapView:location];
    if([fetchMapDetails.bus_status isEqualToString:@"Not in trip"]){
        
        //not in trip case not setting pins in location, only pin bus location
    }
    else{
        
        //intrip case all locations setting pin
        //setting pin in start location

        CLLocationCoordinate2D locationCoordinates_startLocation  = CLLocationCoordinate2DMake([[[_array_Map_Details objectAtIndex:0] start_location_lat] doubleValue],[[[_array_Map_Details objectAtIndex:0] start_location_lon] doubleValue]);
        MapViewAnnotation *annotation_startLoc = [[MapViewAnnotation alloc]initWithTitle:[[_array_Map_Details objectAtIndex:0] start_locationName] AndCoordinate:locationCoordinates_startLocation image:@"start_pin"];
        
        [annotationArray addObject:annotation_startLoc];
        [self.mapView addAnnotations:annotationArray];
        [annotationArray removeAllObjects];
        
        //setting pin in end location
        

        CLLocationCoordinate2D locationCoordinates_endLocation  = CLLocationCoordinate2DMake([[[_array_Map_Details objectAtIndex:0] end_location_lat] doubleValue],[[[_array_Map_Details objectAtIndex:0] end_location_lon] doubleValue]);
        MapViewAnnotation *annotation_endLoc = [[MapViewAnnotation alloc]initWithTitle:[[_array_Map_Details objectAtIndex:0] end_locationName] AndCoordinate:locationCoordinates_endLocation image:@"end_pin"];
        [annotationArray addObject:annotation_endLoc];
        [self.mapView addAnnotations:annotationArray];
        [annotationArray removeAllObjects];
        
        
        //setting pin in visitedlocation
        for(int i=0;i<[fetchMapDetails.visited_locations count];i++){

            CLLocationCoordinate2D locationCoordinates_visitedLoc  = CLLocationCoordinate2DMake([[[fetchMapDetails.visited_locations objectAtIndex:i]objectForKey:@"pLatitude" ]doubleValue],[[[fetchMapDetails.visited_locations objectAtIndex:i]objectForKey:@"pLongitude"]doubleValue]);
            
            MapViewAnnotation *annotation_visitedLoc = [[MapViewAnnotation alloc]initWithTitle:[[fetchMapDetails.visited_locations objectAtIndex:i]objectForKey:@"location_name" ] AndCoordinate:locationCoordinates_visitedLoc image:@"green_pin"];
            [annotationArray addObject:annotation_visitedLoc];
            [self.mapView addAnnotations:annotationArray];
            [annotationArray removeAllObjects];
            
        }
        
        //setting pin in upcominglocation
        
        for(int i=0;i<[fetchMapDetails.upcoming_locations count];i++){
            
            CLLocationCoordinate2D locationCoordinates_upcomingLocation  = CLLocationCoordinate2DMake([[[fetchMapDetails.upcoming_locations objectAtIndex:i]objectForKey:@"pLatitude" ]doubleValue],[[[fetchMapDetails.upcoming_locations objectAtIndex:i] objectForKey:@"pLongitude"]doubleValue] );
            
            MapViewAnnotation *annotation_upcomingLoc = [[MapViewAnnotation alloc]initWithTitle:[[fetchMapDetails.upcoming_locations objectAtIndex:i]objectForKey:@"location_name" ] AndCoordinate:locationCoordinates_upcomingLocation image:@"red_pin"];
            [annotationArray addObject:annotation_upcomingLoc];
            [self.mapView addAnnotations:annotationArray];
            [annotationArray removeAllObjects];
            
        }
        
        
    }
    
   
    
    
}

#pragma mark Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mapview delegates for view annotation
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if([annotation isKindOfClass:[MapViewAnnotation class]]){
        MapViewAnnotation *currentLocation = (MapViewAnnotation*)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapViewAnnotation"];
        annotationView.canShowCallout = YES;
        annotationView.enabled = YES;
        
        if(annotationView == nil){
            annotationView = currentLocation.annotationView;
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapViewAnnotation"];
            annotationView.canShowCallout = YES;
            annotationView.enabled = YES;
        }
        else{
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapViewAnnotation"];
            annotationView.annotation = annotation;
            annotationView.canShowCallout = YES;
            annotationView.enabled = YES;
        }
        
        if([[(MapViewAnnotation *)annotationView.annotation image_name] isEqualToString:@"bus_pin"]){
            //setting image for bus pin
    
            annotationView.image = [UIImage imageNamed:@"bus_pin.png"];
        }
        
        //setting image for start pin for annotation start location
        if([[(MapViewAnnotation *)annotationView.annotation image_name] isEqualToString:@"start_pin"])
            annotationView.image = [UIImage imageNamed:@"start_pin.png"];
        
         //setting image for end pin for annotation end location
        if([[(MapViewAnnotation *)annotationView.annotation image_name] isEqualToString:@"end_pin"])
            annotationView.image = [UIImage imageNamed:@"end_pin.png"];
        
         //setting image for red pin for annotation unvisited location
        
        if([[(MapViewAnnotation *)annotationView.annotation image_name] isEqualToString:@"red_pin"])
            annotationView.image = [UIImage imageNamed:@"red_pin.png"];
        
        //setting image for green pin for annotation visited location
        if([[(MapViewAnnotation *)annotationView.annotation image_name] isEqualToString:@"green_pin"])
            annotationView.image = [UIImage imageNamed:@"green_pin.png"];
        
        
        return annotationView;
    }
    else
        return nil;
    
    
}


#pragma mark - IBActions
//refresh button action
- (IBAction)refreshSelected:(UIButton *)sender{
    [self fetchMapDetails];
}
//map type (satellite or normal)change button action
- (IBAction)changeMapType:(id)sender{
    
    if (self.mapView.mapType == MKMapTypeStandard){
        self.mapView.mapType = MKMapTypeSatellite;
        [_btn_type setTitle: @"Normal" forState: UIControlStateNormal];
        
    }
    else{
        self.mapView.mapType = MKMapTypeStandard;
        [_btn_type setTitle: @"Satellite" forState: UIControlStateNormal];
        
    }
}

//dropdown action for fetching bus names
- (IBAction)dropDownSelected:(UIButton *)sender{
    self.tblview_DropDown.hidden = NO;
}

//logout button  action
- (IBAction)logoutSelected:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:@"Are you sure you  want to logout?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"CANCEL", nil];
    alert.tag = 100;
    [alert show];
}

//Function for fetching  map details
- (void)fetchMapDetails
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    //retrieve auth key for nsuserdefaults for setting the auth key to location request for fetch map details
    NSUserDefaults *retreiveAuthkey = [NSUserDefaults standardUserDefaults];
    NSString *authKey = [retreiveAuthkey stringForKey:@"authKey"];
    NSString *queryString  = [NSString stringWithFormat:@"%@?authKey=%@",GETLOCATIONDETAILS,authKey];
    connection = [[ConnectionOperation alloc]init];
    connection.delegate = self;
    [connection sendConnectionRequestForData:queryString forService:@""];
    connection.typeOfRequest = GETLOCATIONDETAILS;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate =userLocation.location.coordinate;
    
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayBusNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //for adding bus names in array bus names
    cell.textLabel.text = [arrayBusNames objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tblview_DropDown.hidden = YES;
    //for selecting table view for fetching map details
    [self fetchMapDetails];
}

#pragma mark- touch
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.tblview_DropDown.hidden = YES;
}

#pragma mark - Connectionoperation
- (void)connectionFailedWithError:(NSString *)description{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:@"Your network connectivity seems to be weak. Please retry." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)reqCompletedWithData:(NSData *)responsData typeOfRequest:(NSString *)requestType{
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingAllowFragments error:&error];
    if (jsonDictionary == nil) {
        [self.view setUserInteractionEnabled:YES];
        return;
    }
    
    //map details data manipulation
    if([requestType isEqualToString:GETLOCATIONDETAILS]){
        
        if ([[jsonDictionary objectForKey:@"status"] isEqualToString:@"Success"])
        {
            fetchMapDetails  = [[FetchMapDetailModel alloc  ]init];
            self.array_Map_Details = [[NSMutableArray alloc]init];
            fetchMapDetails.dataarray =[jsonDictionary objectForKey:@"data"];
            NSMutableArray *dataArray = [jsonDictionary objectForKey:@"data"];
            
            for (NSDictionary *dict in dataArray) {
                
                //saving map details to a class model
                self.lbl_busStatus.text = [dict objectForKey:@"bus_status"];
                self.lbl_busName.text =[dict  objectForKey:@"bus_name"];
                fetchMapDetails.bus_status  = [dict objectForKey:@"bus_status"];
                fetchMapDetails.bus_name    = [dict  objectForKey:@"bus_name"];
                fetchMapDetails.bus_location_lat = [dict valueForKeyPath:@"bus_location.pLatitude"];
                fetchMapDetails.bus_location_lon = [dict valueForKeyPath:@"bus_location.pLongitude"];
                fetchMapDetails.start_location_lat =[dict valueForKeyPath:@"start_location.pLatitude"];
                fetchMapDetails.start_location_lon =[dict valueForKeyPath:@"start_location.pLongitude"];
                fetchMapDetails.start_locationName =[dict valueForKeyPath:@"start_location.location_name"];
                fetchMapDetails.end_location_lat =[dict valueForKeyPath:@"end_location.pLatitude"];
                fetchMapDetails.end_location_lon =[dict valueForKeyPath:@"end_location.pLongitude"];
                fetchMapDetails.end_locationName =[dict valueForKeyPath:@"end_location.location_name"];
                fetchMapDetails.visited_locations = [dict objectForKey:@"visited_locations"];
                fetchMapDetails.upcoming_locations = [dict objectForKey:@"upcoming_locations"];
                
                [_array_Map_Details addObject:fetchMapDetails];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Function for adding map annotations
                    [self addAnnotation];
                    
                });
                
            }
            
            
        }
        
        else if ([[jsonDictionary objectForKey:@"status"] isEqualToString:@"error"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:[jsonDictionary objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
        
    }
    
    [HUD hide:YES];
    
}

#pragma mark- Alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag  == 100)
    {
        //Logout case
        if(buttonIndex ==  0)
        {
            // for stopping timer object
            [_timer invalidate];
            //remove auth key and parentname for logout case
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authKey"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"parent_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login view" object:self];
            
        }
    }
}

//function for updating map view
- (void)updateMapView:(CLLocation *)location {
    // create a region and pass it to the Map View
    MKCoordinateRegion region;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    //setting zoom level for mapview
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;;
    [self.mapView setRegion:region animated:YES];
    
}

@end
