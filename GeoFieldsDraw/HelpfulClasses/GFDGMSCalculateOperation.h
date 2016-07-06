//
//  GFDGMSCalculateOperation.h
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 06.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

@interface GFDGMSCalculateOperation : NSObject

+ (GMSPolygon *)polygonForMap:(GMSMapView *)mapsView byGeoObject:(NSDictionary *)geoObject;
+ (GMSPath *)pathForMap:(GMSMapView *)mapsView byGeoObjects:(NSArray *)geoObjects;

@end
