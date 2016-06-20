//
//  FavoritesViewController.h
//  officePoolApp
//
//  Created by Kyle Griffith on 2016-06-16.
//  Copyright © 2016 Kyle Griffith. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FavoritesViewController: UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *favoriteItems;
@property (nonatomic,strong) NSMutableArray *favoriteIconData;

@end