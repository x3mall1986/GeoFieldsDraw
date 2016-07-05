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

@interface ViewController ()<UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *fieldsList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[GFDAPIClient sharedClient] fieldsJsonWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.fieldsList = responseObject[@"features"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
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
    cell.tillAreaLabel.text = [NSString stringWithFormat:@"%@", fieldInfo[@"properties"][@"till_area"]];
    
    return cell;
}

@end
