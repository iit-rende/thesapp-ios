//
//  DomainCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "DomainCard.h"
#define ROW_HEIGHT 44

@implementation DomainCard
@synthesize domini, tabellaDomini;

-(id) init {
    NSLog(@"[DomainCard] init");
    self = [super init];
    if (self) {
        //[self render];
    }
    return self;
}
/*
+(DomainCard *) createWithDomain:(Domain *) dominio {
    DomainCard *card = [DomainCard new];
    card.dominio = dominio;
    [card render];
    return card;
}
*/
-(void) render {
    
    //self.backgroundColor = [UIColor whiteColor];
    //self.clipsToBounds = YES;
    
    NSString *sec_title = NSLocalizedString(@"CHOSE_DOMAIN", @"Scegli dominio");
    [self addCardTitle:sec_title];
    
    //[self prepare];
    
    if (domini.count > 0) {
        
        tableHeight = domini.count * ROW_HEIGHT;
        NSLog(@"altezza = %f", tableHeight);
        tabellaDomini.bounces = NO;
        tabellaDomini.bouncesZoom = NO;
        tabellaDomini.showsVerticalScrollIndicator = NO;
        tabellaDomini.showsHorizontalScrollIndicator = NO;
        tabellaDomini.backgroundColor = [UIColor magentaColor];
        
        float y = [self getHeaderHeightAndPadding];
        
        CGRect tabelFrame = CGRectMake(10, y, fullWithPadding - 20, tableHeight);
        tabellaDomini = [[UITableView alloc] initWithFrame:tabelFrame style:UITableViewStylePlain];
        tabellaDomini.delegate = self;
        tabellaDomini.dataSource = self;
        
        tabellaDomini.scrollEnabled = NO;
        
        [wrapper addSubview:tabellaDomini];
        
        [tabellaDomini reloadData];
    }
}

#pragma mark - Table View Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cliccato su riga %d", (int) indexPath.row);
    
    Domain *dominio = [domini objectAtIndex: [indexPath row]];
    
    if (dominio != nil) {
        NSLog(@"trovato dominio %@", dominio.descriptor);
        [self.controller getDominio:dominio];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Domain *dominio = [domini objectAtIndex: [indexPath row]];
    
    if (dominio != nil) {
        NSString *value =  dominio.descriptor;
        cell.textLabel.text = value;
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return domini.count;
}

@end
