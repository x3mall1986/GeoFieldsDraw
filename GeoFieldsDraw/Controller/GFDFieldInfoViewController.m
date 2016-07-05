//
//  GFDFieldInfoViewController.m
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import "GFDFieldInfoViewController.h"
@import GoogleMaps;

@interface GFDFieldInfoViewController ()<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapsView;

@end

@implementation GFDFieldInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the mapType to Satellite
    self.mapsView.mapType = kGMSTypeSatellite;
    
    NSLog(@"%@", self.polygon);
    
    NSArray *polygonPoints = [self getCoordinatesFromMultyLevelArray:self.polygon[@"coordinates"]];
    
//    NSArray *shapes = [GeoJSONSerialization shapesFromGeoJSONFeatureCollection:self.polygon error:nil];
    
//    for (MKShape *shape in shapes) {
//        if ([shape isKindOfClass:[MKPointAnnotation class]]) {
//            [mapView addAnnotation:shape];
//        } else if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
//            [mapView addOverlay:(id <MKOverlay>)shape];
//        }
//        NSLog(@"%@", shape);
//    }
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[polygonPoints[0][0] doubleValue]
//                                                            longitude:[polygonPoints[0][1] doubleValue]
//                                                                 zoom:8];
    
    
//    [self.mapsView animateToCameraPosition:camera];
    // Create a rectangular path
    GMSMutablePath *rect = [GMSMutablePath path];
    
    for (NSArray *coordinates in polygonPoints) {
        [rect addCoordinate:CLLocationCoordinate2DMake([coordinates[1] doubleValue],
                                                       [coordinates[0] doubleValue])];
    }
    
    GMSCoordinateBounds *cam = [[GMSCoordinateBounds alloc] initWithPath:rect];
    GMSCameraPosition *camera = [self.mapsView cameraForBounds:cam insets:UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0)];
    self.mapsView.camera = camera;
    
//    [rect addCoordinate:CLLocationCoordinate2DMake(37.36, -122.0)];
//    [rect addCoordinate:CLLocationCoordinate2DMake(37.45, -122.0)];
//    [rect addCoordinate:CLLocationCoordinate2DMake(37.45, -122.2)];
//    [rect addCoordinate:CLLocationCoordinate2DMake(37.36, -122.2)];
    
    // Create the polygon, and assign it to the map.
    GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
    polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
    polygon.strokeColor = [UIColor whiteColor];
    polygon.strokeWidth = 2;
    polygon.map = self.mapsView;

//    NSLog(@"%@", coordinates);
}

- (NSArray *)getCoordinatesFromMultyLevelArray:(NSArray *)multiLevelArray
{
    NSArray *poligonArray;
    if (multiLevelArray.count == 1) {
        poligonArray = [self getCoordinatesFromMultyLevelArray:multiLevelArray.firstObject];
    } else {
        poligonArray = multiLevelArray;
    }
    
    return poligonArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
