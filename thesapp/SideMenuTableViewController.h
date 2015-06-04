//
//  SideMenuTableViewController.h
//  Camera di Commercio
//
//  Created by Paolo Burzacca on 19/03/15.
//  Copyright (c) 2015 E-Lios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import <MMDrawerController.h>
#import <AFHTTPRequestOperationManager.h>

@interface SideMenuTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
{
    NSArray *array;
    NSArray *icons;
    NSArray *views;
    NSTimer *timer;
    int intervallo, indice;
    AFHTTPRequestOperationManager *manager;    
    MMDrawerController *parent;
}

@property (strong, nonatomic) NSArray *filteredList;
@property (nonatomic, strong) NSMutableArray *navigationControllerArray;
@property (nonatomic, strong) UISearchDisplayController *controller;
@property (nonatomic, strong) UISearchController *mySearchController;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIView *barContainer;

@end
