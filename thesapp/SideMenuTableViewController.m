//
//  SideMenuTableViewController.m
//  Camera di Commercio
//
//  Created by Paolo Burzacca on 19/03/15.
//  Copyright (c) 2015 E-Lios. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+FormattedText.h"
#import "AppDelegate.h"

#define TIMER_INTERVAL 1.5
#define FILTER_HEIGHT 35
#define CATEGORIES_ROW_HEIGHT 30
#define RESULTS_ROW_HEIGHT 40
#define LOADER_SIZE 37
#define PICKER_VIEW_HEIGHT 162

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController
@synthesize filter, filterTableView, chosenDomain, suggestionTableView, suggestionTitle, sfondo;

-(void)hideKeyBoard {
    [self.searchBar endEditing:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    NSLog(@"menu apparso");
    
    //self.barContainer.backgroundColor = [UIColor orangeColor];
    
    if (listaDomini.count > 0) {
        chosenDomain = [listaDomini firstObject];
        [tendina setTitle:chosenDomain.localization forState:UIControlStateNormal];
    }
    
    UIColor *colore;
    if (chosenDomain != nil) {
        colore = [Utils colorFromHexString:chosenDomain.color];
        
        NSLog(@"COLORE DA DOMINIO");
    }
    else {
        colore = [Utils getDefaultColor];
        NSLog(@"COLORE DI DEFAULT");
    }
    
    NSLog(@"View Will appear, cambio colore");
    //self.barContainer.backgroundColor = colore;
    
    UINavigationController *navC = (UINavigationController *) parent.centerViewController;
    svc = (ScrollerViewController *) [navC.viewControllers firstObject];
    
    /*
    UIColor *domainColor = [Utils getChosenDomainColor];
    if (domainColor != nil)
        self.barContainer.backgroundColor = domainColor;
    else NSLog(@"SCARTO");
     */

}

-(void) menuOpen:(NSMutableArray *) domini {
    
    //[self.searchBar becomeFirstResponder];
    
    NSLog(@"svc.listaDomini = %d", (int) domini.count);
    
    //if (svc.listaDomini.count > 0) listaDomini = svc.listaDomini;
    //else listaDomini = [[NSMutableArray alloc] init];
    
    listaDomini = domini;
    
    if (listaDomini.count > 0) {
        //chosenDomain = [listaDomini firstObject]; //SBAGLIATO
        if (svc != nil) {
            chosenDomain = svc.dominioScelto;
            NSLog(@"SVC NON NULLO");
        }
        else {
            chosenDomain = nil;
        }
        
        [tendina setTitle:chosenDomain.localization forState:UIControlStateNormal];
        
        if (chosenDomain != nil) {
            
            NSLog(@"colore = %@", chosenDomain.color);
            UIColor *colore = [Utils colorFromHexString:chosenDomain.color];
            
            if (colore != nil){
                self.barContainer.backgroundColor = colore;
                //self.barContainer.tintColor = colore;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:
                 ^{
                    self.barContainer.backgroundColor = colore;
                     NSLog(@"colore cambiato in %@", chosenDomain.localization);
                 }];
                
                [self.barContainer setBackgroundColor:colore];
                

            } else NSLog(@"colore non cambiato");
            
        } else {
         
            NSLog(@"dominio nullo");
            self.barContainer.backgroundColor = [Utils getDefaultColor];
        }
    }
    
    [myPickerView reloadAllComponents];
    myPickerView.hidden = YES;
    
    NSLog(@"apro menu side");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float totalWidth = [AppDelegate getSidemenuWidth];
    
    lingua = [Utils getCurrentLanguage];
    
    self.barContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, 64)];
    //self.barContainer.tintColor = [Utils getDefaultColor];
    //self.barContainer.clipsToBounds = YES;
    
    container.clipsToBounds = NO;
    
    [self.view addSubview:self.barContainer];
    
    //sfondo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, 64)];
    //sfondo.backgroundColor = [UIColor blackColor];
    //self.barContainer.backgroundColor = [Utils getDefaultColor];
    //[container addSubview:sfondo];
    
    advice = [[UILabel alloc] initWithFrame:CGRectMake(10, self.barContainer.frame.size.height + 20, totalWidth - 20, 22)];
    advice.text = @"Nessun risultato";
    advice.textColor = [UIColor darkGrayColor];
    advice.textAlignment = NSTextAlignmentCenter;
    
    //if (svc.listaDomini.count > 0) listaDomini = svc.listaDomini;
    //else listaDomini = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    

    filter_list = [UIImage imageNamed:@"filter_list"];
    up_arrow = [UIImage imageNamed:@"up_arrow_white"];
    
    //misure

    NSLog(@"width = %f", totalWidth );
    float sidePadding = 5;
    float xSize = 30;
    float tendinaWidth = 70;
    float searchBarWidth = totalWidth - 5 * sidePadding - tendinaWidth - xSize;
    float loaderLeft = searchBarWidth + tendinaWidth;
    float wrapperHeight = xSize + 4 * sidePadding;
    float filter_Y = wrapperHeight + 8 * sidePadding;
    float containerHeight = wrapperHeight + FILTER_HEIGHT + 2 * sidePadding;
    
    indice = 0;
    manager = [AFHTTPRequestOperationManager manager];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGRect tableFrame = CGRectMake(0, containerHeight + FILTER_HEIGHT, totalWidth, self.view.frame.size.height - containerHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    self.navigationController.navigationBar.translucent = NO;
    
    array = [[NSArray alloc] init];
    
    parent = (MMDrawerController *) self.parentViewController;
    
    //search controller
    
    CGRect nuovoFrame = CGRectMake(0, 0, totalWidth, containerHeight);
    container = [[UIView alloc] initWithFrame:nuovoFrame];
    //container.backgroundColor = [UIColor clearColor]; //self.barContainer.backgroundColor;
    //container.clipsToBounds = YES;
    
    //wrapper
    CGRect wrapperFrame = CGRectMake( 3*sidePadding, 6 * sidePadding, totalWidth - 6 * sidePadding , wrapperHeight);
    UIView *wrapper = [[UIView alloc] initWithFrame:wrapperFrame];
    wrapper.backgroundColor = [UIColor whiteColor];
    wrapper.clipsToBounds = YES;
    wrapper.layer.borderColor = [UIColor grayColor].CGColor;
    wrapper.layer.borderWidth = 1.0f;
    wrapper.layer.cornerRadius = 4;
    //wrapper.layer.masksToBounds = YES;
    wrapper.layer.shadowOffset = CGSizeMake(2, 2);
    wrapper.layer.shadowRadius = 4.0;
    wrapper.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    wrapper.layer.shadowOpacity = 1.0;
    wrapper.layer.masksToBounds = NO;
    
    [container addSubview:wrapper];
    
    CGRect searchBarFrame = CGRectMake(sidePadding + tendinaWidth + sidePadding, 2* sidePadding, searchBarWidth, xSize);
    
    self.searchBar = [[UITextField alloc] initWithFrame:searchBarFrame];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.enabled = YES;
    [self.searchBar setFont:[UIFont systemFontOfSize:14.f]];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = NSLocalizedString(@"SEARCH_PLACEHOLDER", @"cerca termine");
    
    [self.searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [wrapper addSubview:self.searchBar];
    
    //menu a tendina
    
    
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
    
    //CGFloat spacing = 6.0;
    CGRect tendinaFrame = CGRectMake(sidePadding, 2 * sidePadding, tendinaWidth, xSize);
    tendina = [UIButton buttonWithType:UIButtonTypeCustom];
    [tendina setFrame:tendinaFrame];
    //[tendina setCenter:CGPointMake(tendinaWidth / 2, xSize / 2)];
    [tendina setClipsToBounds:false];
    //[tendina setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    tendina.titleLabel.numberOfLines = 2;
    tendina.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [tendina.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [tendina setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // SET the colour for your wishes
    //[tendina setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)]; // SET the values for your wishes
    //[tendina setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -40.f, 0.f)];
    tendina.backgroundColor = [UIColor clearColor];
    
    [tendina addTarget:self action:@selector(openPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    //CGSize imageSize = tendina.imageView.frame.size;
    //tendina.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    //CGSize titleSize = tendina.titleLabel.frame.size;
    //tendina.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    //tendina.imageEdgeInsets = UIEdgeInsetsMake(10,tendinaWidth - 10, 10, 5);
    
    [wrapper addSubview:tendina];
    
    //activity indicator
    CGRect loaderFrame = CGRectMake(loaderLeft, sidePadding, LOADER_SIZE, LOADER_SIZE);
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loader setFrame:loaderFrame];
    loader.hidesWhenStopped = YES;
    [loader setTintColor:[UIColor darkGrayColor]];
    
    //x button
    //float leftBtn = [AppDelegate getSidemenuWidth] - 55;
    CGRect btnFrame = CGRectMake(loaderLeft, 2*sidePadding, xSize, xSize);
    xbtn = [[UIButton alloc] initWithFrame:btnFrame];
    [xbtn setTitle:@"x" forState:UIControlStateNormal];
    [xbtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [xbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [xbtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [wrapper addSubview:xbtn];
    [wrapper addSubview:loader];
    
    [xbtn addTarget:self action:@selector(XBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // filtro categorie
    CGRect filtroFrame = CGRectMake(0, filter_Y, totalWidth, FILTER_HEIGHT);
    filter = [[UIView alloc] initWithFrame:filtroFrame];
    
    if (chosenDomain != nil) {
        filter.backgroundColor = [Utils colorFromHexString:chosenDomain.color];
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //CREO PULSANTE DI ESPANSIONE FILTRO
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    CGRect toggleButtonFrame = CGRectMake(0, 5, totalWidth, 35);
    filterToggleButton = [[UIView alloc] initWithFrame:toggleButtonFrame];
    
    CGRect filterBtnFrame = CGRectMake(10, 5, 0, 35);
    filterBtn = [[UILabel alloc] initWithFrame:filterBtnFrame];
    [filterBtn setText:@"FILTRA PER CATEGORIA"];
    [filterBtn setTextColor:[UIColor whiteColor]];
    [filterBtn setFont:[UIFont systemFontOfSize:13.f]];
    [filterBtn sizeToFit];
    [filterToggleButton addSubview:filterBtn];
    
    //tasto toggle filtro
    CGRect toggleFilterBtnFrame = CGRectMake(totalWidth - 2 * sidePadding - xSize, 5, xSize / 3 * 2, xSize / 3 * 2);
    toggleFilter = [[UIImageView alloc] initWithFrame:toggleFilterBtnFrame];
    [toggleFilter setImage:filter_list];
    [filterToggleButton addSubview:toggleFilter];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandFilter:)];
    [filterToggleButton addGestureRecognizer:singleFingerTap];
    
    [filter addSubview:filterToggleButton];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
    
    float suggTabStartY = 360; // self.tableView.frame.size.height + self.tableView.frame.origin.y;
    
    NSLog(@"start = %f", suggTabStartY);
    
    CGRect suggTabFrame = CGRectMake(0, suggTabStartY + 30, totalWidth, 50);
    suggestionTableView = [[UITableView alloc] initWithFrame:suggTabFrame style:UITableViewStylePlain];
    suggestionTableView.backgroundColor = [UIColor clearColor];
    suggestionTableView.delegate = self;
    suggestionTableView.dataSource = self;
    suggestionTableView.bounces = NO;
    suggestionTableView.bouncesZoom = NO;
    suggestionTableView.showsVerticalScrollIndicator = NO;
    suggestionTableView.showsHorizontalScrollIndicator = NO;
    suggestionTableView.tableHeaderView = nil;
    suggestionTableView.tableFooterView = nil;
    suggestionTableView.separatorColor = [UIColor clearColor];
    suggestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    suggestionTableView.hidden = YES;
    [self.view addSubview:suggestionTableView];
    
    CGRect titleFrame = CGRectMake(sidePadding, 360, totalWidth, 16);
    suggestionTitle = [[UILabel alloc] initWithFrame:titleFrame];
    suggestionTitle.text = [NSLocalizedString(@"COULD_INTEREST", @"potrebbe interessare") uppercaseString];
    suggestionTitle.textColor = [UIColor darkGrayColor];
    [suggestionTitle setFont:[UIFont systemFontOfSize:14.f]];
    suggestionTitle.hidden = YES;
    [self.view addSubview:suggestionTitle];
    
    addGestureRecognizer:tapGesture.cancelsTouchesInView = NO;
    //[self.tableView addGestureRecognizer:tapGesture];
    //[container addGestureRecognizer:tapGesture];
    [self.view addGestureRecognizer:tapGesture];
    
    //prendo altezza sidebar
    
    float altezza = self.view.frame.size.height;
    float yPicker = altezza - PICKER_VIEW_HEIGHT - 10;
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, yPicker, totalWidth - 20, PICKER_VIEW_HEIGHT)];
    myPickerView.delegate = self;
    myPickerView.backgroundColor = self.barContainer.backgroundColor;
    myPickerView.tintColor = [UIColor whiteColor];
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden = YES;
    myPickerView.layer.borderWidth = 1.0;
    myPickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:myPickerView];
}

-(void) openPicker:(UIButton *) button {
    //myPickerView.hidden = NO;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"CHOSE_DOMAIN", @"Dominio")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Annulla")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    
    for (Domain *dom in listaDomini) {
        [actionSheet addButtonWithTitle:dom.localization];
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    int voce = (int) buttonIndex - 1;
    NSLog(@"scelto indice %d", voce);
    
    if (!(voce > -1 && voce < listaDomini.count)) return;
    
    Domain *dominio = [listaDomini objectAtIndex:voce];
    
    if (dominio == nil) return;
    
    NSLog(@"dominio scelto = %@", dominio.localization);
    myPickerView.hidden = YES;
    [tendina setTitle:dominio.localization forState:UIControlStateNormal];
    chosenDomain = dominio;
    //[Utils setCurrentDomain:dominio];
    svc.dominioScelto = dominio;
    NSLog(@"cambio colore picker in %@", chosenDomain.color);
    filter.backgroundColor = [Utils colorFromHexString:chosenDomain.color];
    self.barContainer.backgroundColor = [Utils colorFromHexString:chosenDomain.color];
    
    //se c'è frase nella search bar parte ricerca
    
    if (self.searchBar.text != nil) {
        if (self.searchBar.text.length > 0) {
            [self aTime];
        }
    }
}

#pragma mark - Picker View Delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"cliccato su riga %d", (int) row);
    Domain *dominio = [listaDomini objectAtIndex:row];
    
    if (dominio == nil) return;
    
    NSLog(@"dominio scelto = %@", dominio.localization);
    myPickerView.hidden = YES;
    [tendina setTitle:dominio.localization forState:UIControlStateNormal];
    chosenDomain = dominio;
    //[Utils setCurrentDomain:dominio];
    svc.dominioScelto = dominio;
    NSLog(@"cambio colore picker");
    filter.backgroundColor = [Utils colorFromHexString:chosenDomain.color];
    
    //se c'è frase nella search bar parte ricerca
    
    if (self.searchBar.text != nil) {
        if (self.searchBar.text.length > 0) {
            [self aTime];
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return listaDomini.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Domain *dominio = [listaDomini objectAtIndex:row];
    return dominio.localization;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    //label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.font = [label.font fontWithSize:20.0f];
    //label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    Domain *dominio = [listaDomini objectAtIndex:row];
    label.text = dominio.localization;
    
    return label;
}

/*
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}
*/
#pragma mark - other methods

-(void) XBtnClicked:(UIButton *) btn {
    self.searchBar.text = @"";
    [advice removeFromSuperview];
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

-(void) filterSearchByCategory:(NSString *)cat {
    
    [loader startAnimating];
    
    if (chosenDomain.descriptor == nil) {
        NSLog(@"Nessun dominio scelto");
        return;
    }
    
    xbtn.hidden = YES;

    NSString *cate = [Utils WWWFormEncoded:cat];
    NSString *suffix = @"/search?query=";
    NSString *testo = self.searchBar.text;
    NSString *domain = [@"&domain=" stringByAppendingString:chosenDomain.descriptor];
    NSString *category = [@"&category=" stringByAppendingString:cate];
    NSString *requestString = [[[[[Utils getServerBaseAddress] stringByAppendingString:suffix] stringByAppendingString:testo] stringByAppendingString:domain] stringByAppendingString:category];
    
    NSLog(@"[filterSearchByCategory] requestString = %@", requestString);

    [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        NSLog(@"[Filter] JSON: %@", json);
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        suggestions = [[NSMutableArray alloc] init];
        //suggestions vanno filtrate in base al valore "semantic"
        NSArray *temp = [json objectForKey:@"suggestions"];

        for (NSDictionary *sugg in temp) {
            int semantic = [[sugg objectForKey:@"semantic"] intValue];

            if (semantic) {
                [suggestions addObject:sugg];
            }
            else {
                [results addObject:sugg];
            }
        }
        
        int suggerimenti = (int) [suggestions count];
        
        NSLog(@"trovati %d risultati non sematici", (int) [results count]);
        NSLog(@"trovati %d risultati sematici", suggerimenti);
        
        if (suggerimenti > 0) {
            suggestionTableView.hidden = NO;
            suggestionTitle.hidden = NO;
        }
        else {
            suggestionTableView.hidden = YES;
            suggestionTitle.hidden = YES;
        }
        
        array = [[NSArray alloc] initWithArray:results];
        
        //aggiorno tabelle risultati
        [self.tableView reloadData];
        
        float newHeight = array.count * RESULTS_ROW_HEIGHT;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                          self.tableView.frame.origin.y,
                                          self.tableView.frame.size.width,
                                          newHeight);
        
        [suggestionTableView reloadData];
        
        float inizioY = self.tableView.frame.size.height + self.tableView.frame.origin.y + 20;
        
        suggestionTitle.frame = CGRectMake(suggestionTitle.frame.origin.x,
                                           inizioY,
                                           suggestionTitle.frame.size.width,
                                           suggestionTitle.frame.size.height);
        
        float height = suggerimenti * RESULTS_ROW_HEIGHT;
        suggestionTableView.frame = CGRectMake(suggestionTableView.frame.origin.x, inizioY + 30, suggestionTableView.frame.size.width, height);
        
        //[suggestionTableView sizeToFit];
        //[self.tableView sizeToFit];
        
        [loader stopAnimating];
        xbtn.hidden = NO;
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
        NSLog(@"Error: %@", error);
        [loader stopAnimating];
        xbtn.hidden = NO;
    }];
}

#pragma mark - metodi ricerca generici
-(void)aTime {

    NSLog(@"INIZIA RICERCA");
    
    [loader startAnimating];
    xbtn.hidden = YES;
    [timer invalidate];
    //parte richiesta
    
    if (chosenDomain.descriptor == nil) {
        NSLog(@"Descrizione dominio mancnate");
        return;
    }
    
    filter.backgroundColor = [Utils colorFromHexString:chosenDomain.color];
    
    NSString *dominio = [Utils WWWFormEncoded:chosenDomain.descriptor];
    
    NSString *testo = [Utils WWWFormEncoded:self.searchBar.text];
    NSString *domain = [@"&domain=" stringByAppendingString:dominio]; //TODO
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
            
            NSArray *suggestionsArray = [json objectForKey:@"suggestions"];
            NSDictionary *facets = [json objectForKey:@"facets"];
            
            NSArray *categories = [facets objectForKey:@"categories"];
            
            int totCat = (int)[categories count];
            
            NSLog(@"categories count: %d", totCat);
            
            if (totCat == 0) {
                
                [self.view addSubview:advice];
            }
            else {
                NSLog(@"categories: %@", [categories description]);
                
                filters = categories;
                filterHeight = categories.count * CATEGORIES_ROW_HEIGHT;
                [filterTableView reloadData];
                filterTableView.hidden = NO;
                
                if (categories.count == 1) {
                    NSLog(@"UNA SOLA CATEGORIA TROVATA");
                    filterToggleButton.hidden = YES;
                    
                    filterTableView.frame = CGRectMake(filterTableView.frame.origin.x, filterTableView.frame.origin.y, filterTableView.frame.size.width, CATEGORIES_ROW_HEIGHT);
                    
                }
                else{
                    
                    filterTableView.frame = CGRectMake(filterTableView.frame.origin.x, filterTableView.frame.origin.y, filterTableView.frame.size.width, 0);
                    
                    filterToggleButton.hidden = NO;
                }
                
                [advice removeFromSuperview];
                
                NSMutableArray *semantics = [[NSMutableArray alloc] init];
                NSMutableArray *not_semantics = [[NSMutableArray alloc] init];
                
                for (NSDictionary *risultato in suggestionsArray) {
                    NSString *descriptor = [risultato objectForKey:@"descriptor"];
                    bool semantico = [[risultato objectForKey:@"semantic"] boolValue];
                    if (semantico) {
                        NSLog(@"%@ è semantico", descriptor);
                        [semantics addObject:risultato];
                    }
                    else {
                        [not_semantics addObject:risultato];
                        NSLog(@"%@ non è semantico", descriptor);
                    }
                }
                
                //GESTISCO I NON SEMANTICI
                array = not_semantics;
                
                if (totCat > 0) {
                    NSLog(@"array tot = %d", (int) array.count);
                    [self.tableView reloadData];
                    filter.hidden = NO;
                    
                    float newHeight  = container.frame.size.height + FILTER_HEIGHT;
                    CGRect newContFrame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, newHeight);
                    container.frame = newContFrame;
                    
                    float nuovaHeight = array.count * RESULTS_ROW_HEIGHT;
                    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                      self.tableView.frame.origin.y,
                                                      self.tableView.frame.size.width,
                                                      nuovaHeight);
                }
                
                
                //GESTISCO I SEMANTICI
                
                suggestions = semantics;
                
                if (suggestions.count > 0) {
                    suggestionTableView.hidden = NO;
                    suggestionTitle.hidden = NO;
                }
                else {
                    suggestionTableView.hidden = YES;
                    suggestionTitle.hidden = YES;
                }
                
                [suggestionTableView reloadData];
                
                NSLog(@"ci sono %d suggestions", (int) suggestions.count);
                
                //sposto tabella verticalmente
                float inizioY = self.tableView.frame.size.height + self.tableView.frame.origin.y + 20;
                
                NSLog(@"inizioY = %f", inizioY);
                
                suggestionTitle.frame = CGRectMake(suggestionTitle.frame.origin.x,
                                                   inizioY,
                                                   suggestionTitle.frame.size.width,
                                                   suggestionTitle.frame.size.height);
                
                float height = suggestions.count * RESULTS_ROW_HEIGHT;
                
                
                
                suggestionTableView.frame = CGRectMake(suggestionTableView.frame.origin.x, inizioY + 30, suggestionTableView.frame.size.width, height);
                
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
    
    [self.searchBar resignFirstResponder];
    
    float increment = filterHeight + 50;
    float height, difference, btnY, tableHeight, containerHeight, tabellaY;
    NSString *titolo;
    
    if (!expanded) {
        height = filterHeight + increment;
        tableHeight = filterHeight;
        difference = increment;
        btnY = filterHeight + 20;
        containerHeight = 80 + increment;
        NSLog(@"espando");
        titolo = @"USA TUTTE LE CATEGORIE";
        tabellaY = containerHeight;
    }
    else {
        height = FILTER_HEIGHT;
        tableHeight = 0;
        containerHeight = 115;
        difference = -increment;
        btnY = 5;
        NSLog(@"comprimo");
        titolo = @"FILTRA PER CATEGORIA";
        tabellaY = containerHeight;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    filter.frame = CGRectMake(filter.frame.origin.x, filter.frame.origin.y, filter.frame.size.width, height);
    
    container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, containerHeight);
    
    //float y = self.tableView.frame.origin.y  + difference;

    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, tabellaY, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    filterTableView.frame = CGRectMake(filterTableView.frame.origin.x, filterTableView.frame.origin.y, filterTableView.frame.size.width, tableHeight); //height - 50
    
    //filterBtn.frame = CGRectMake(filterBtn.frame.origin.x, btnY, filterBtn.frame.size.width, filterBtn.frame.size.height);
    
    //toggleFilter.frame = CGRectMake(toggleFilter.frame.origin.x, btnY, toggleFilter.frame.size.width, toggleFilter.frame.size.height);
    
    filterToggleButton.frame = CGRectMake(filterToggleButton.frame.origin.x, btnY, filterToggleButton.frame.size.width, filterToggleButton.frame.size.height);
    
    float suggestionNewY = self.tableView.frame.origin.y + self.tableView.frame.size.height + 10;
    
    suggestionTitle.frame = CGRectMake(
                                           suggestionTitle.frame.origin.x,
                                           suggestionNewY,
                                           suggestionTitle.frame.size.width,
                                           suggestionTitle.frame.size.height
                                           );
    
    suggestionTableView.frame = CGRectMake(
                                           suggestionTableView.frame.origin.x,
                                           suggestionNewY + 30,
                                           suggestionTableView.frame.size.width,
                                           suggestionTableView.frame.size.height
                                );
    
    if (expanded) {
        [toggleFilter setImage:filter_list];
    }
    else {
        [toggleFilter setImage:up_arrow];
    }
    
    [filterBtn setText:titolo];
    [filterBtn sizeToFit];
    
    [UIView commitAnimations];
    
    expanded = !expanded;
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
    if (tableView == suggestionTableView) return [suggestions count];
    return [filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == self.tableView) {
    
        static NSString *CellIdentifier = @"cell";
    
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *json = [array objectAtIndex:indexPath.row];
        
        NSLog(@"json = %@", [json description]);
        
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
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
    else if (tableView == suggestionTableView) {
        
        static NSString *CellIdentifier = @"suggCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        NSDictionary *json = [suggestions objectAtIndex:indexPath.row];
        cell.textLabel.text = [json objectForKey:@"descriptor"];
        //cell.textLabel.font = [cell.textLabel.font fontWithSize:14.0f];
        //cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    else {
        
        static NSString *CellIdentifier = @"newFriendCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
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
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
        NSString *lang = [json objectForKey:@"language"];
        NSLog(@"didSelectRowAtIndexPath = %@", value);
        
        if (value == nil) return;
        
        //NSArray *subviews = [parent.centerViewController.view subviews];

        NSLog(@"qui??, svc = %@", [svc description]);
        [svc getSingleTerm:value withDomain:chosenDomain andLanguage:lang];
        [parent closeDrawerAnimated:YES completion:nil];

        [self.searchBar resignFirstResponder];
    }
    else if (tableView == suggestionTableView) {
    
        NSDictionary *json = [suggestions objectAtIndex:riga];
        NSString *value = [json objectForKey:@"descriptor"];
        NSLog(@"[suggestions] didSelectRowAtIndexPath = %@", value);
        
        if (value == nil) return;
        
        [svc getSingleTerm:value withDomain:chosenDomain andLanguage:lingua];
        [parent closeDrawerAnimated:YES completion:nil];
        
        [self.searchBar resignFirstResponder];
    }
    else {
        
        if (filterToggleButton.hidden) return;
        
        NSDictionary *json = [filters objectAtIndex:riga];
        NSString *catFilter = [json objectForKey:@"descriptor"];
        NSLog(@"catFilter = %@", catFilter);
        [self expandFilter:nil];
        [filterBtn setText:catFilter];
        
        [self filterSearchByCategory:catFilter];
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