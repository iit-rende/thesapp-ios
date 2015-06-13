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

@interface SideMenuTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, UITextFieldDelegate>
{
    NSArray *array, *icons, *views, *filters;
    NSMutableArray *suggestions;
    NSTimer *timer;
    BOOL expanded;
    int intervallo, indice;
    float filterHeight;
    AFHTTPRequestOperationManager *manager;    
    MMDrawerController *parent;
    UIActivityIndicatorView *loader;
    UIButton *xbtn;
    UIView *container, *filterToggleButton;
    UIImage *filter_list, *down_arrow, *up_arrow;
    UIImageView *toggleFilter;
    UILabel *filterBtn;
}

@property (strong, nonatomic) NSString *domainChosen;
@property (strong, nonatomic) NSArray *filteredList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *filterTableView;
@property (nonatomic, strong) UITableView *suggestionTableView;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) IBOutlet UIView *barContainer;
@property (nonatomic, strong) UIView *filter;
@property (nonatomic, strong) UILabel *suggestionTitle;

-(IBAction)expandFilter:(id)sender;

@end
