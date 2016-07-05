//
//  GFDGMSCalculateOperation.m
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 06.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import "GFDGMSCalculateOperation.h"
#import "GeoJson.h"

@implementation GFDGMSCalculateOperation

+ (GMSPolygon *)polygonForMap:(GMSMapView *)mapsView byGeoObject:(NSDictionary *)geoObject
{
    // Create a rectangular path
    GMSPath *rect = [self parseGeoCoordinateFromDictionary:geoObject];
    
    // Create the polygon, and assign it to the map.
    GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
    polygon.fillColor = [UIColor colorWithWhite:1 alpha:0.2];
    polygon.strokeColor = [UIColor whiteColor];
    polygon.strokeWidth = 2;
    polygon.map = mapsView;
    
    return polygon;
}

+ (GMSPath *)parseGeoCoordinateFromDictionary:(NSDictionary *)dictionary
{
    GMSMutablePath *rect = [GMSMutablePath path];
    
    GeoJSONFactory *factory = [GeoJSONFactory new];
    [factory createObject:dictionary];
    
    GeoJSONMultiPolygon *geoMultyPolygon = factory.object;
    
    for (int i = 0; i < geoMultyPolygon.count; i++) {
        GeoJSONPolygon *geoPolygon = [geoMultyPolygon polygonAt:i];
        for (int j = 0; j < geoPolygon.vertexCount; j++) {
            GeoJSONPoint *point = [geoPolygon vertexAt:j];
            [rect addCoordinate:CLLocationCoordinate2DMake(point.latitude,
                                                           point.longitude)];
        }
        
        for (int k = 0; k < geoPolygon.holeCount; k++) {
            GeoJSONMultiPoint *multyPoint = [geoPolygon holeAt:k];
            
            for (int j = 0; j < multyPoint.count; j++) {
                GeoJSONPoint *point = [multyPoint pointAt:j];
                [rect addCoordinate:CLLocationCoordinate2DMake(point.latitude,
                                                               point.longitude)];
            }
            
        }
    }
    
    return [rect copy];
}

@end
