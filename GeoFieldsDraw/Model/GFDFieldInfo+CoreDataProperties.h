//
//  GFDFieldInfo+CoreDataProperties.h
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 06.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GFDFieldInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GFDFieldInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *tillArea;
@property (nullable, nonatomic, retain) NSString *crop;
@property (nullable, nonatomic, retain) id geometry;

@end

NS_ASSUME_NONNULL_END
