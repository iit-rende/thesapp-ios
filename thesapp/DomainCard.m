//
//  DomainCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "DomainCard.h"
#import "DominioTableViewCell.h"
#define ROW_HEIGHT 85

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

-(NSString *) getName {
    return @"Domain List";
}

-(NSString *) getPrefix {
    return @"D_";
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
    
    lingua = [Utils getCurrentLanguage];
    
    NSString *sec_title = NSLocalizedString(@"CHOSE_DOMAIN", @"Scegli dominio");
    [self addCardTitle:sec_title];
    
    //[self prepare];
    
    if (domini.count > 0) {
        
        tableHeight = domini.count * ROW_HEIGHT;
        NSLog(@"altezza = %f", tableHeight);
        
        float y = [self getHeaderHeightAndPadding];
        
        CGRect tabelFrame = CGRectMake(10, y, fullWithPadding - 20, tableHeight);
        tabellaDomini = [[UITableView alloc] initWithFrame:tabelFrame style:UITableViewStylePlain];
        
        tabellaDomini.delegate = self;
        tabellaDomini.dataSource = self;
        
        tabellaDomini.bounces = NO;
        tabellaDomini.bouncesZoom = NO;
        tabellaDomini.showsVerticalScrollIndicator = NO;
        tabellaDomini.showsHorizontalScrollIndicator = NO;
        //tabellaDomini.backgroundColor = [UIColor magentaColor];
        tabellaDomini.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tabellaDomini.separatorColor = [UIColor lightGrayColor];
        //tabellaDomini.scrollEnabled = NO;
        
        //tabellaDomini.backgroundColor = [UIColor redColor];
    
        UINib *nib = [UINib nibWithNibName:@"DominioTableViewCell" bundle:nil];
        [tabellaDomini registerNib:nib forCellReuseIdentifier:@"domainCell"];
        
        [wrapper addSubview:tabellaDomini];
        
        [tabellaDomini reloadData];
    }
}

#pragma mark - Table View Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Domain *dominio = [domini objectAtIndex: [indexPath row]];
    
    if (dominio != nil) {
        NSLog(@"trovato dominio %@", dominio.descriptor);
        [self.controller getDominio:dominio];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"domainCell";
    
    DominioTableViewCell *cell = (DominioTableViewCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    /*
    if (cell == nil) {
        cell = [[DominioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    */
    
    //cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
    
    //cell.clipsToBounds = YES;
    
    //cell.indentationLevel = 1;
    //cell.indentationWidth = 2000;
    
    Domain *dominio = [domini objectAtIndex: [indexPath row]];
    
    Localization *loca = [dominio.localizations objectForKey:lingua];
    
    NSLog(@"dominio per lingua %@", lingua);
    
    if (dominio != nil && loca != nil) {
        NSString *value =  loca.descriptor;
        cell.titolo.text = value;
        cell.descrizione.text = loca.descrizione;
        cell.numero.text = [NSString stringWithFormat:@"%d", loca.termCount];
        NSLog(@"ci sono %d termini", loca.termCount);
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
