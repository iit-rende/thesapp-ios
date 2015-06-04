//
//  SideMenuTableViewController.m
//  Camera di Commercio
//
//  Created by Paolo Burzacca on 19/03/15.
//  Copyright (c) 2015 E-Lios. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "ScrollerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define TIMER_INTERVAL 1.5

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController
@synthesize mySearchController, controller;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    indice = 0;
    manager = [AFHTTPRequestOperationManager manager];
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationControllerArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"", @"",nil];
    
    array = [[NSArray alloc] init];
    
    parent = (MMDrawerController *) self.parentViewController;
    
    //search controller
    
    float os_version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (os_version >= 8.000000)
    {
        // IOS 8
        mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        mySearchController.searchResultsUpdater = self;
        mySearchController.dimsBackgroundDuringPresentation = NO;
        mySearchController.searchBar.scopeButtonTitles = @[@"titolo1"];
        mySearchController.searchBar.delegate = self;
        mySearchController.active = YES;
        mySearchController.searchBar.autoresizesSubviews = NO;
        mySearchController.hidesNavigationBarDuringPresentation = YES;
        mySearchController.searchBar.selectedScopeButtonIndex = 0;
        mySearchController.searchBar.showsScopeBar = NO;
        mySearchController.searchBar.showsCancelButton = NO;
        mySearchController.searchBar.showsSearchResultsButton = NO;
        mySearchController.searchBar.translatesAutoresizingMaskIntoConstraints = YES;
        mySearchController.searchBar.barTintColor = [UIColor blueColor];
        mySearchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(0, 0);
        //[self.mySearchController.searchBar sizeToFit];
        
        NSLog(@"subview = %@", [[mySearchController.searchBar.subviews firstObject] description]);
        
        mySearchController.searchBar.clipsToBounds = YES;
        self.barContainer.clipsToBounds = YES;
        
        CGRect curFrame = self.mySearchController.searchBar.frame;
        CGRect nuovoFrame = CGRectMake(-50, 0, 340, curFrame.size.height);
        [self.mySearchController.searchBar setFrame:nuovoFrame];
        //self.mySearchController.searchBar.text = @",";
        [self.barContainer addSubview:self.mySearchController.searchBar];
        
        UIView *vista = [mySearchController.searchBar.subviews firstObject];
        //vista.autoresizesSubviews = NO;
        
        NSLog(@"nipoti = %@", [vista.subviews description]);
        
        UIView *barra = [vista.subviews objectAtIndex:2];

        barra.frame = CGRectMake(0, 0, 100, 44);
        barra.layer.frame = CGRectMake(0, 0, 100, 44);
        barra.backgroundColor = [UIColor yellowColor];
        
        UIView *container = [[UIView alloc] initWithFrame:nuovoFrame];
        [container addSubview:self.mySearchController.searchBar];
        container.backgroundColor = [UIColor greenColor];
        container.clipsToBounds = YES;
        
        self.tableView.tableHeaderView = container; //mySearchController.searchBar
        
        self.definesPresentationContext = YES;
    }
    else
    {
        // IOS 7
        //controller = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    }
}

#pragma mark - metodi ricerca generici
-(void)aTime {
    NSLog(@"chiamato aTime");
    
    [timer invalidate];
    //parte richiesta
    
    NSString *testo = mySearchController.searchBar.text;
    NSString *domain = @"&domain=Turismo"; //TODO
    NSString *suffix = @"/search?query=";
    
    NSString *requestString = [[[[Utils getServerBaseAddress] stringByAppendingString:suffix] stringByAppendingString:testo] stringByAppendingString:domain];
    
    NSLog(@"requestString = %@", requestString);
    
    [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([operation.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)operation.response;
            
            NSDictionary *headers = [r allHeaderFields];
            
            intervallo = [[headers valueForKey:@"X-Search-Interval"] intValue];
            
            NSLog(@"intervallo di chiamata = %d", intervallo);
            
            NSArray *suggestions = [json objectForKey:@"suggestions"];
            
            NSLog(@"suggestions count: %d", (int)[suggestions count]);
            NSLog(@"suggestions: %@", suggestions);
            
            array = suggestions;
            
             NSLog(@"array tot = %d", (int) array.count);
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
     NSLog(@"sectionForSectionIndexTitle");

    //ios 8
    CGRect searchBarFrame = self.mySearchController.searchBar.frame;
    [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
    return NSNotFound;
}

#pragma mark - metodi ricerca IOS 8


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"updateSearchResultsForSearchController");
    indice++;
    
    if (indice < 4) {
        UIView *vista = [mySearchController.searchBar.subviews firstObject];
        //vista.autoresizesSubviews = NO;
        
        NSLog(@"nipoti = %@", [vista.subviews description]);
        
        UIView *view = [vista.subviews objectAtIndex:0];
        UIView *sfondo = [vista.subviews objectAtIndex:1];
        UIView *barra = [vista.subviews objectAtIndex:2];
        
        float width1 = 268; //vista.layer.frame.size.width;
        float height1 = vista.layer.frame.size.height;
        CGRect frame0 = CGRectMake(50, 0, width1, height1);
        vista.layer.frame = CGRectInset(frame0, 0, 0);
        
        //float width = 292; //mySearchController.searchBar.layer.frame.size.width - 100;
        //float height = mySearchController.searchBar.layer.frame.size.height;
        //CGRect frame1 = CGRectMake(-50, 0, width, height);
        //mySearchController.searchBar.layer.frame = CGRectInset(frame1, 0, 0);
        
        float width2 = 340; //mySearchController.searchBar.frame.size.width - 52;
        CGRect frame2 = CGRectMake(-50, 0, width2, mySearchController.searchBar.frame.size.height);
        mySearchController.searchBar.frame = frame2;
        
        sfondo.frame = CGRectMake(0, 0, 170, 44);
        barra.frame = CGRectMake(0, 0, 100, 44);
        barra.layer.frame = CGRectMake(0, 0, 100, 44);
        barra.backgroundColor = [UIColor yellowColor];
        view.frame = CGRectMake(0, 0, 180, 44);
    }
    NSString *searchString = searchController.searchBar.text;
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    
    NSLog(@"cerco per %@", searchString);
    
    if (searchString != nil) {
        if (searchString.length > 0) {
            
            //azzero timer
            [timer invalidate];
            
            //inizializzo timer ad ogni lettera digitata
            timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(aTime) userInfo:nil repeats:YES];
            
            
        }
    }
    
    //[self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSLog(@"selectedScopeButtonIndexDidChange");
    
    CGRect curFrame = searchBar.frame;
    
    NSLog(@"[curframe = %f, %f, %f, %f]", curFrame.origin.x, curFrame.origin.y, curFrame.size.width, curFrame.size.height);
    
    //CGRect nuovoFrame = CGRectMake(-50, 0, curFrame.size.width, curFrame.size.height);
    //[searchBar setFrame:nuovoFrame];
    
    [self updateSearchResultsForSearchController:self.mySearchController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *json = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = [json objectForKey:@"descriptor"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int riga = (int)[tableView indexPathForSelectedRow].row;
    if (riga < 0) return;
    
    NSDictionary *json = [array objectAtIndex:riga];
    NSString *value = [json objectForKey:@"descriptor"];
    NSLog(@"didSelectRowAtIndexPath = %@", value);
    
    if (value == nil) return;
    
    //NSArray *subviews = [parent.centerViewController.view subviews];
    UINavigationController *navC = (UINavigationController *) parent.centerViewController;
    
    ScrollerViewController *svc = (ScrollerViewController *) [navC.viewControllers firstObject];
    
    [svc getSingleTerm:value];
    
    [parent closeDrawerAnimated:YES completion:nil];
    
    //NSArray *sotto = view.subviews;
    //int cards = (int) view.subviews.count;
    //NSLog(@"ci sono %d card", cards);
    
    //for (UIView *v in subviews) {
    //    NSLog(@"[View] %@", [v description]);
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end