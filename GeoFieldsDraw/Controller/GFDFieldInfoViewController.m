//
//  GFDFieldInfoViewController.m
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import "GFDFieldInfoViewController.h"
#import "GFDGMSCalculateOperation.h"
#import "GFDFieldInfo.h"

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
    
    self.fieldNameLabel.text = self.fieldInfo.name;;
    self.fieldCropAndAreaLabel.text = [NSString stringWithFormat:@"%@ \t %@ ha", self.fieldInfo.crop, self.fieldInfo.tillArea];
    
    // Set the mapType to Satellite
    self.mapsView.mapType = kGMSTypeSatellite;
    
    GMSPolygon *polygon = [GFDGMSCalculateOperation polygonForMap:self.mapsView byGeoObject:self.fieldInfo.geometry];
    
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:polygon.path];
    //    GMSCameraPosition *camera = [self.mapsView cameraForBounds:coordinateBounds insets:UIEdgeInsetsZero];
    //    self.mapsView.camera = camera;
    [self.mapsView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:coordinateBounds]];
}

@end
