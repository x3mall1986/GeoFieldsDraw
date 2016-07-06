//
//  ViewController.m
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import "ViewController.h"
#import "GFDAPIClient.h"
#import "GFDFieldsListTableViewCell.h"
#import "GFDFieldInfoViewController.h"
#import "GeoJSONSerialization.h"
#import "MBProgressHUD.h"
#import "GFDGMSCalculateOperation.h"
#import "GFDFieldInfo+CoreDataProperties.h"

#import <MagicalRecord/MagicalRecord.h>

@import GoogleMaps;

@interface ViewController ()<UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *fieldsList;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.mapType = kGMSTypeSatellite;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GFDAPIClient sharedClient] fieldsJsonWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self saveDataFromServer:responseObject];
//        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
        
        [self fetchFieldsFromBase];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - AdditionalMethods
- (void)saveDataFromServer:(id)responseObject
{
//    self.fieldsList = [GFDFieldInfo MR_importFromArray:responseObject[@"features"]];
//    
//    GFDFieldInfo *fieldsListTest = [GFDFieldInfo MR_findFirst];
//    // Update the entity in the block of saveWithBlock:
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        // Build the predicate to find the person sought
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname ==[c] %@ AND lastname ==[c] %@", firstname, lastname];
//    }];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        NSLog(@"count of enteties = %ld", [GFDFieldInfo MR_countOfEntities]);
//    }];
    
    NSArray *geoJson = responseObject[@"features"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *fieldInfoDictionary in geoJson)
        {
            NSLog(@"%@ %@", fieldInfoDictionary[@"properties"][@"name"], fieldInfoDictionary[@"properties"][@"till_area"]);
            // Build the predicate to find the person sought
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@ AND tillArea ==[c] %@",
                                      fieldInfoDictionary[@"properties"][@"name"], fieldInfoDictionary[@"properties"][@"till_area"]];
            
            NSLog(@"%@", predicate);
            GFDFieldInfo *fieldFounded  = [GFDFieldInfo MR_findFirstWithPredicate:predicate inContext:localContext];

            if (fieldFounded) {
                [fieldFounded MR_importValuesForKeysWithObject:fieldInfoDictionary];
            } else {
                GFDFieldInfo *fieldInfo = [GFDFieldInfo MR_createEntityInContext:localContext];
                [fieldInfo MR_importValuesForKeysWithObject:fieldInfoDictionary];
            }
        }
        
    } completion:^(BOOL success, NSError *error) {
        [self fetchFieldsFromBase];
    }];
}

- (void)fetchFieldsFromBase
{
    self.fieldsList = [GFDFieldInfo MR_findAllSortedBy:@"name" ascending:YES];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fieldsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFDFieldsListTableViewCell *cell = nil;
    static NSString *autoCompleteRowIdentifier = @"GFDFieldsListTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:autoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[GFDFieldsListTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:autoCompleteRowIdentifier];
    }
    
    GFDFieldInfo *fieldInfo = self.fieldsList[indexPath.row];
    cell.nameLabel.text = fieldInfo.name;
    cell.cropLabel.text = fieldInfo.crop;
    cell.tillAreaLabel.text = [NSString stringWithFormat:@"%@", fieldInfo.tillArea];
    
    return cell;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     
     GFDFieldInfoViewController *viewController = segue.destinationViewController;
     viewController.fieldInfo = self.fieldsList[indexPath.row];
 }

#pragma mark - Actions
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 1) {
        self.mapView.hidden = NO;
        
        GMSPath *path = [GFDGMSCalculateOperation pathForMap:self.mapView byGeoObjects:self.fieldsList];
        
        GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:path];
        [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:coordinateBounds]];
        
    } else {
        self.mapView.hidden = YES;
    }
}

@end
