//
//  HDViewController.m
//  HaidoraRefresh
//
//  Created by mrdaios on 03/12/2015.
//  Copyright (c) 2014 mrdaios. All rights reserved.
//

#import "HDTableViewController.h"
#import <HaidoraRefresh.h>

@interface HDTableViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _count;
}
@end

@implementation HDTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _count = 5;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addPullToRefreshWithActionHandler:^{
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                     dispatch_get_main_queue(), ^{
                       [self.tableView stopPullRefresh];
                       _count = 5;
                       [self.tableView reloadData];
                     });
    }];

    [self.tableView addInfiniteToRefreshWithActionHandler:^{
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                     dispatch_get_main_queue(), ^{
                       [self.tableView stopInfiniteRefresh];
                       _count += 5;
                       [self.tableView reloadData];
                     });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentify];
        cell.textLabel.text = @"1";
    }
    return cell;
}

@end
