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
#import "UILabel+FormattedText.h"

#define TIMER_INTERVAL 1.5
#define FILTER_HEIGHT 35
#define CATEGORIES_ROW_HEIGHT 30
#define RESULTS_ROW_HEIGHT 40

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController
@synthesize filter, filterBtn, filterTableView;

//     [self.searchBar becomeFirstResponder];

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *domainColor = [Utils getChosenDomainColor];
    if (domainColor != nil) self.barContainer.backgroundColor = domainColor;
    else NSLog(@"SCARTO");
    
    indice = 0;
    manager = [AFHTTPRequestOperationManager manager];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.translucent = NO;
    
    array = [[NSArray alloc] init];
    
    parent = (MMDrawerController *) self.parentViewController;
    
    //misure
    
    float totalWidth = 280;
    float sidePadding = 5;
    float xSize = 30;
    float loaderSize = 37;
    float tendinaWidth = 70;
    float searchBarWidth = totalWidth - 5 * sidePadding - tendinaWidth - xSize;
    float loaderLeft = searchBarWidth + tendinaWidth + sidePadding;
    float wrapperHeight = xSize + 2 * sidePadding;
    float filter_Y = wrapperHeight + 8 * sidePadding;
    float containerHeight = wrapperHeight + FILTER_HEIGHT + 2 * sidePadding;

    //search controller
    
    CGRect nuovoFrame = CGRectMake(0, 0, totalWidth, containerHeight);
    container = [[UIView alloc] initWithFrame:nuovoFrame];
    container.backgroundColor = self.barContainer.backgroundColor;
    container.clipsToBounds = YES;
    
    //wrapper
    CGRect wrapperFrame = CGRectMake( sidePadding, 4 * sidePadding, totalWidth - 4 * sidePadding , wrapperHeight);
    UIView *wrapper = [[UIView alloc] initWithFrame:wrapperFrame];
    wrapper.backgroundColor = [UIColor whiteColor];
    wrapper.clipsToBounds = YES;
    wrapper.layer.borderColor = [UIColor grayColor].CGColor;
    wrapper.layer.borderWidth = 1.0f;
    wrapper.layer.cornerRadius = 3;
    wrapper.layer.masksToBounds = YES;
    
    [container addSubview:wrapper];
    
    CGRect searchBarFrame = CGRectMake(sidePadding + tendinaWidth + sidePadding, sidePadding, searchBarWidth, xSize);
    self.searchBar = [[UITextField alloc] initWithFrame:searchBarFrame];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.enabled = YES;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Cerca un termine...";
    
    [self.searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [wrapper addSubview:self.searchBar];
    
    //menu a tendina
    
    CGRect tendinaFrame = CGRectMake(sidePadding, sidePadding, tendinaWidth, xSize);
    /*
    UIButton *tendina = [[UIButton alloc] initWithFrame:tendinaFrame];
    tendina.backgroundColor = [UIColor whiteColor];
    [tendina setTitle:@"Turismo" forState:UIControlStateNormal];
    [tendina setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tendina.titleLabel setFont:[tendina.titleLabel.font fontWithSize:16.0f]];
    UIImage *img = [UIImage imageNamed:@"down_arrow"];
    [tendina setImage:img forState:UIControlStateNormal];
    tendina.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tendina.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    tendina.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [wrapper addSubview:tendina];
    */
    
    CGFloat spacing = 6.0;
    
    UIButton *tendina = [UIButton buttonWithType:UIButtonTypeCustom];
    [tendina setFrame:tendinaFrame];
    [tendina setCenter:CGPointMake(tendinaWidth / 2, xSize / 2)];
    [tendina setClipsToBounds:false];
    [tendina setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [tendina setTitle:@"Turismo" forState:UIControlStateNormal];
    [tendina.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [tendina setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // SET the colour for your wishes
    //[tendina setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)]; // SET the values for your wishes
    //[tendina setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -40.f, 0.f)];
    tendina.backgroundColor = [UIColor whiteColor];
    
    CGSize imageSize = tendina.imageView.frame.size;
    tendina.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    CGSize titleSize = tendina.titleLabel.frame.size;
    tendina.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    [wrapper addSubview:tendina];
    
    //activity indicator
    CGRect loaderFrame = CGRectMake(loaderLeft, sidePadding, loaderSize, loaderSize);
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loader setFrame:loaderFrame];
    loader.hidesWhenStopped = YES;
    [loader setTintColor:[UIColor darkGrayColor]];
    
    //x button
    CGRect btnFrame = CGRectMake(230, sidePadding, xSize, xSize);
    xbtn = [[UIButton alloc] initWithFrame:btnFrame];
    [xbtn setTitle:@"X" forState:UIControlStateNormal];
    [xbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [xbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [wrapper addSubview:xbtn];
    
    [wrapper addSubview:loader];
    
    [xbtn addTarget:self action:@selector(XBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // filtro categorie
    CGRect filtroFrame = CGRectMake(0, filter_Y, totalWidth, FILTER_HEIGHT);
    filter = [[UIView alloc] initWithFrame:filtroFrame];
    UIColor *azure = [Utils colorFromHexString:@"277EFF"];
    filter.backgroundColor = azure;
    
    CGRect filterBtnFrame = CGRectMake(20, 5, 0, 0);
    filterBtn = [[UIButton alloc] initWithFrame:filterBtnFrame];
    [filterBtn setTitle:@"FILTRA PER CATEGORIA" forState:UIControlStateNormal];
    [filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [filterBtn sizeToFit];
    [filterBtn addTarget:self action:@selector(expandFilter:) forControlEvents:UIControlEventTouchUpInside];
    [filter addSubview:filterBtn];
    
    //tasto toggle filtro
    CGRect toggleFilterBtnFrame = CGRectMake(totalWidth - 2 * sidePadding - xSize, 5, xSize, xSize);
    toggleFilter = [[UIButton alloc] initWithFrame:toggleFilterBtnFrame];
    [toggleFilter setTitle:@"X" forState:UIControlStateNormal];
    [toggleFilter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toggleFilter.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [filter addSubview:toggleFilter];
    
    CGRect filterTableFrame = CGRectMake(sidePadding, sidePadding, totalWidth - 2 * sidePadding, 0);
    filterTableView = [[UITableView alloc] initWithFrame:filterTableFrame style:UITableViewStylePlain];
    [filterTableView sizeToFit];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    filterTableView.hidden = YES;
    filterTableView.bounces = NO;
    filterTableView.bouncesZoom = NO;
    filterTableView.showsVerticalScrollIndicator = NO;
    filterTableView.showsHorizontalScrollIndicator = NO;
    filterTableView.tableHeaderView = nil;
    filterTableView.tableFooterView = nil;
    filterTableView.separatorColor = [UIColor clearColor];
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [filter addSubview:filterTableView];
    
    [container addSubview:filter];
    
    filter.hidden = YES;
    
    //self.tableView.tableHeaderView = container;
    [self.view addSubview:container];
}

-(void) XBtnClicked:(UIButton *) btn {
    self.searchBar.text = @"";
}

-(void) startSearch {
    
    if (expanded) [self expandFilter:self];
    
    NSString *searchString = self.searchBar.text;
    NSLog(@"cerco per %@", searchString);
    if (searchString != nil) {
        if (searchString.length > 0) {
            //azzero timer
            [timer invalidate];
            //inizializzo timer ad ogni lettera digitata
            timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(aTime) userInfo:nil repeats:YES];
            
        }
    }
}

-(void)textFieldDidChange:(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    
    theTextField.attributedText = [[NSAttributedString alloc] initWithString:theTextField.text
                                                                    attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    
    [self startSearch];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing %@]", self.searchBar.text);
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldBeginEditing");
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    

    NSLog(@"textFieldDidBeginEditing %@]", self.searchBar.text);
}

#pragma mark - metodi ricerca generici
-(void)aTime {
    NSLog(@"chiamato aTime");
    
    [loader startAnimating];
    xbtn.hidden = YES;
    [timer invalidate];
    //parte richiesta
    
    NSString *testo = self.searchBar.text;
    NSString *domain = @"&domain=Turismo"; //TODO
    NSString *suffix = @"/search?query=";
    
    NSString *requestString = [[[[Utils getServerBaseAddress] stringByAppendingString:suffix] stringByAppendingString:testo] stringByAppendingString:domain];
    
    NSLog(@"requestString = %@", requestString);
    
    [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        NSLog(@"json = %@", json);
        
        if ([operation.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)operation.response;
            
            NSDictionary *headers = [r allHeaderFields];
            
            intervallo = [[headers valueForKey:@"X-Search-Interval"] intValue];
            
            NSLog(@"intervallo di chiamata = %d", intervallo);
            
            NSArray *suggestions = [json objectForKey:@"suggestions"];
            NSDictionary *facets = [json objectForKey:@"facets"];
            
            NSArray *categories = [facets objectForKey:@"categories"];
            
            int totCat = (int)[categories count];
            
            NSLog(@"categories count: %d", totCat);
            NSLog(@"categories: %@", [categories description]);
            
            filters = categories;
            
            filterHeight = categories.count * CATEGORIES_ROW_HEIGHT;
            
            [filterTableView reloadData];
            
            filterTableView.hidden = NO;
            
            array = suggestions;
            
            if (totCat > 0) {
                NSLog(@"array tot = %d", (int) array.count);
                [self.tableView reloadData];
                filter.hidden = NO;
                
                float newHeight  = container.frame.size.height + FILTER_HEIGHT;
                CGRect newContFrame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, newHeight);
                container.frame = newContFrame;
            }
            
            [loader stopAnimating];
            xbtn.hidden = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [loader stopAnimating];
        xbtn.hidden = NO;
    }];
}

-(IBAction)expandFilter:(id)sender {
    
    float increment = filterHeight + 50;
    float height, difference, btnY, tableHeight, containerHeight;
    NSString *titolo;
    
    if (!expanded) {
        height = filterHeight + increment;
        tableHeight = filterHeight;
        difference = increment;
        btnY = filterHeight + 20;
        containerHeight = 70 + filterHeight + 60;
        NSLog(@"espando");
        titolo = @"USA TUTTE LE CATEGORIE";
    }
    else {
        height = FILTER_HEIGHT;
        tableHeight = 0;
        containerHeight = 105;
        difference = -increment;
        btnY = 5;
        NSLog(@"comprimo");
        titolo = @"FILTRA PER CATEGORIA";
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    filter.frame = CGRectMake(filter.frame.origin.x, filter.frame.origin.y, filter.frame.size.width, height);
    
    container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, containerHeight);
    
    float y = self.tableView.frame.origin.y  + difference;

    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    filterTableView.frame = CGRectMake(filterTableView.frame.origin.x, filterTableView.frame.origin.y, filterTableView.frame.size.width, tableHeight); //height - 50
    
    filterBtn.frame = CGRectMake(filterBtn.frame.origin.x, btnY, filterBtn.frame.size.width, filterBtn.frame.size.height);
    
    toggleFilter.frame = CGRectMake(toggleFilter.frame.origin.x, btnY, toggleFilter.frame.size.width, toggleFilter.frame.size.height);
    
    [filterBtn setTitle:titolo forState:UIControlStateNormal];
    [filterBtn sizeToFit];
    
    [UIView commitAnimations];
    
    expanded = !expanded;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
     NSLog(@"sectionForSectionIndexTitle");

    if (tableView == self.tableView) {
        //ios 8
        CGRect searchBarFrame = self.searchBar.frame;
        [tableView scrollRectToVisible:searchBarFrame animated:NO];
        return NSNotFound;
    }
    else {
        return NSNotFound;
    }
}

#pragma mark - metodi ricerca IOS 8
/*
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"updateSearchResultsForSearchController");
    indice++;
    
    if (indice < 4) {
        UIView *vista = [self.searchBar.subviews firstObject];
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
        CGRect frame2 = CGRectMake(-50, 0, width2, self.searchBar.frame.size.height);
        self.searchBar.frame = frame2;
        
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
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) return [array count];
    NSLog(@"filtri %d", (int) [filters count]);
    return [filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == self.tableView) {
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        NSDictionary *json = [array objectAtIndex:indexPath.row];
        
        NSLog(@"json = %@", [json description]);
        
        cell.textLabel.text = [json objectForKey:@"descriptor"];
        
        NSString *keyword = self.searchBar.text;
        NSRange range = [cell.textLabel.text rangeOfString:keyword options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) {
        } else {
            int start = (int)range.location;
            int prefixLength = (int) keyword.length;
            [cell.textLabel setTextColor:[UIColor redColor] range:NSMakeRange(start, prefixLength)];
        }
        
        cell.detailTextLabel.text = @"";
        
    }
    else {
        
        static NSString *CellIdentifier = @"newFriendCell";
        cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        //cell = [tableView dequeueReusableCellWithIdentifier:@"cellFilter" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        NSDictionary *json = [filters objectAtIndex:indexPath.row];
        cell.textLabel.text = [json objectForKey:@"descriptor"];
        cell.textLabel.font = [cell.textLabel.font fontWithSize:14.0f];
        int count = [[json objectForKey:@"count"] intValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", count];
        
        cell.detailTextLabel.textColor = [UIColor groupTableViewBackgroundColor];
        cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:12.0f];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.filterTableView) return 0;
    return RESULTS_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.filterTableView) return 0;
    return RESULTS_ROW_HEIGHT;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) return RESULTS_ROW_HEIGHT;
    return CATEGORIES_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int riga = (int)[tableView indexPathForSelectedRow].row;
    if (riga < 0) return;
 
    if (tableView == self.tableView) {
    
        NSDictionary *json = [array objectAtIndex:riga];
        NSString *value = [json objectForKey:@"descriptor"];
        NSLog(@"didSelectRowAtIndexPath = %@", value);
        
        if (value == nil) return;
        
        //NSArray *subviews = [parent.centerViewController.view subviews];
        UINavigationController *navC = (UINavigationController *) parent.centerViewController;
        
        ScrollerViewController *svc = (ScrollerViewController *) [navC.viewControllers firstObject];
        
        [svc getSingleTerm:value];
        [parent closeDrawerAnimated:YES completion:nil];
    }
    else {
        
        NSDictionary *json = [filters objectAtIndex:riga];
        NSString *titolo = [json objectForKey:@"descriptor"];
        NSLog(@"titolo = %@", titolo);
        [self expandFilter:nil];
        [filterBtn setTitle:titolo forState:UIControlStateNormal];
        
        //TODO: filtra risultati
        
    }
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