//
//  DomainCategoryCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 22/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "DomainCategoryCard.h"
#define ROW_HEIGHT 44

@implementation DomainCategoryCard
@synthesize categorie, dominio, tabellaCategorie;

-(id) init {
    NSLog(@"[DomainCategoryCard] init");
    self = [super init];
    if (self) {
        //[self render];
    }
    return self;
}

-(NSString *) getName {
    if (dominio != nil) return dominio.descriptor;
    return [super getName];
}

-(void) render {
    
    NSLog(@"[DomainCategoryCard] render, ci sono %d categorie", (int) categorie.count);
    
    NSString *sec_title = NSLocalizedString(@"CHOSE_CAT", @"Scegli categoria");
    [self addCardTitle:sec_title];
    
    [self renderTable];
}

-(void) renderTable {
    if (categorie.count > 0) {
        
        float y = [self getHeaderHeightAndPadding];
        
        tableHeight = categorie.count * ROW_HEIGHT;
        NSLog(@"altezza tabella = %f (%d * %d)", tableHeight, (int)categorie.count, ROW_HEIGHT);
        tabellaCategorie.bounces = NO;
        tabellaCategorie.bouncesZoom = NO;
        tabellaCategorie.showsVerticalScrollIndicator = NO;
        tabellaCategorie.showsHorizontalScrollIndicator = NO;
        tabellaCategorie.backgroundColor = [UIColor purpleColor];
        
        //IOS 7
        if ([tabellaCategorie respondsToSelector:@selector(setSeparatorInset:)]) {
            [tabellaCategorie setSeparatorInset:UIEdgeInsetsZero];
        }
        
        //IOS 8
        if ([tabellaCategorie respondsToSelector:@selector(layoutMargins)]) {
            tabellaCategorie.layoutMargins = UIEdgeInsetsZero;
        }
        
        //CGRect wrapperFrame = CGRectMake(10, y, fullWithPadding - 20, tableHeight);
        CGRect tabellaFrame = CGRectMake(10,y, fullWithPadding - 20, tableHeight);
        //CGRect wrapperFrame = CGRectMake(10, y, width, height);
        
        //UIView *tableWrapper = [[UIView alloc] initWithFrame:wrapperFrame];
        //tableWrapper.backgroundColor = [UIColor blueColor];
        
        tabellaCategorie = [[UITableView alloc] initWithFrame:tabellaFrame style:UITableViewStylePlain];
        tabellaCategorie.delegate = self;
        tabellaCategorie.dataSource = self;
        //[tabellaCategorie sizeToFit];
        
        float width = wrapper.frame.size.width;
        float height = tabellaCategorie.frame.size.height + header.frame.size.height + 30;
        NSLog(@"altezza = %f", height);
        CGRect nuovoFrame = CGRectMake(wrapper.frame.origin.x, wrapper.frame.origin.y, width, height);
        //CGRect nuovoFrame = CGRectMake(0,0, width, height);
        //self.frame = nuovoFrame;
        tabellaCategorie.scrollEnabled = YES;
        tabellaCategorie.bounces = NO;
        
        wrapper.frame = nuovoFrame;
        self.contentSize = nuovoFrame.size;
        //self.clipsToBounds = YES;
        tabellaCategorie.delaysContentTouches = YES;
        tabellaCategorie.canCancelContentTouches = YES;
        
        //tableWrapper.backgroundColor = [UIColor blueColor];
        
        //[tableWrapper addSubview:tabellaCategorie];
        [wrapper addSubview:tabellaCategorie];
        
        [tabellaCategorie reloadData];
    
    }
}

#pragma mark - Table View Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cliccato su riga %d", (int) indexPath.row);
    
    NSDictionary *cat = [categorie objectAtIndex:(int) indexPath.row];
    NSString *term = [cat objectForKey:@"descriptor"];
    
    NSLog(@"cliccato su %@", term);

    [self.controller getDomainCategory:term fromDomain:self.dominio];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *categoria = [categorie objectAtIndex: [indexPath row]];
    
    if (categoria != nil) {
        NSString *value =  [categoria objectForKey:@"descriptor"];
        cell.textLabel.text = value;
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return categorie.count;
}

@end
