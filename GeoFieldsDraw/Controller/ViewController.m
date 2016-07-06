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
        self.fieldsList = responseObject[@"features"];
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
    
    NSDictionary *fieldInfo = self.fieldsList[indexPath.row];
//    NSLog(@"%@, %@", fieldInfo[@"properties"], fieldInfo[@"properties"][@"name"]);
//    NSString *name = fieldInfo[@"properties"][@"name"];
    cell.nameLabel.text = fieldInfo[@"properties"][@"name"];
    cell.cropLabel.text = fieldInfo[@"properties"][@"crop"];
    cell.tillAreaLabel.text = [NSString stringWithFormat:@"%@ ha", fieldInfo[@"properties"][@"till_area"]];
    
    return cell;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     
     GFDFieldInfoViewController *viewController = segue.destinationViewController;
     viewController.polygon = self.fieldsList[indexPath.row][@"geometry"];
     viewController.property = self.fieldsList[indexPath.row][@"properties"];
 }

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 1) {
        self.mapView.hidden = NO;
        
//        [self.fieldsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *polygonDictionary = obj;
//            
        
//        }];
        GMSPath *path = [GFDGMSCalculateOperation pathForMap:self.mapView byGeoObjects:self.fieldsList];
        
        GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:path];
        [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:coordinateBounds]];
        
    } else {
        self.mapView.hidden = YES;
    }
}

@end
