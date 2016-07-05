//
//  GFDFieldInfoViewController.m
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import "GFDFieldInfoViewController.h"
#import "GFDGMSCalculateOperation.h"

@import GoogleMaps;

@interface GFDFieldInfoViewController ()<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapsView;
@property (weak, nonatomic) IBOutlet UILabel *fieldNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldCropAndAreaLabel;

@end

@implementation GFDFieldInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fieldNameLabel.text = self.property[@"name"];
    self.fieldCropAndAreaLabel.text = [NSString stringWithFormat:@"%@ \t %@ ha", self.property[@"crop"], self.property[@"till_area"]];
    
    // Set the mapType to Satellite
    self.mapsView.mapType = kGMSTypeSatellite;
    
    GMSPolygon *polygon = [GFDGMSCalculateOperation polygonForMap:self.mapsView byGeoObject:self.polygon];
    
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:polygon.path];
    //    GMSCameraPosition *camera = [self.mapsView cameraForBounds:coordinateBounds insets:UIEdgeInsetsZero];
    //    self.mapsView.camera = camera;
    [self.mapsView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:coordinateBounds]];
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

@end
