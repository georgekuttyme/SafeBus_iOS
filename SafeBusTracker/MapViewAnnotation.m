//
//  MapViewAnnotation.m
//  MapViewExample1
//
//  Created by Ravi Shankar on 04/01/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate image:(NSString*)image_name
{
    self =  [super init];
    _title = title;
    _coordinate = coordinate;
    _image_name =image_name;
    return self;
}
-(MKAnnotationView *)annotationView{
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"MapViewAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
