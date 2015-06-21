//
//  SideMenuTableViewController.h
//  Camera di Commercio
//
//  Created by Paolo Burzacca on 19/03/15.
//  Copyright (c) 2015 E-Lios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ScrollerViewController.h"
#import <MMDrawerController.h>
#import <AFHTTPRequestOperationManager.h>

@interface SideMenuTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate>
{
    NSArray *array, *icons, *views, *filters;
    NSMutableArray *suggestions, *listaDomini;
    NSTimer *timer;
    BOOL expanded;
    int intervallo, indice;
    float filterHeight;
    AFHTTPRequestOperationManager *manager;    
    MMDrawerController *parent;
    ScrollerViewController *svc;
    UIActivityIndicatorView *loader;
    UIButton *xbtn, *tendina;
    UIView *container, *filterToggleButton;
    UIImage *filter_list, *down_arrow, *up_arrow;
    UIImageView *toggleFilter;
    UILabel *filterBtn, *advice;
    UIPickerView *myPickerView;
    NSString *lingua;
}

@property (strong, nonatomic) NSArray *filteredList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *filterTableView;
@property (nonatomic, strong) UITableView *suggestionTableView;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIView *barContainer;
@property (nonatomic, strong) UIView *filter;
@property (nonatomic, strong) UILabel *suggestionTitle;
@property (nonatomic, strong) Domain *chosenDomain;

-(IBAction)expandFilter:(id)sender;
-(void) menuOpen:(NSMutableArray *) domini;

@end
