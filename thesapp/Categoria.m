//
//  Categoria.m
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Categoria.h"

@implementation Categoria

+(Categoria *) createFromJson:(NSDictionary *) dict {
    Categoria *cat = [Categoria new];
    Descriptor *descriptor = [Descriptor new];
    descriptor.descriptor = [dict objectForKey:@"descriptor"];
    NSDictionary *domainJson = [dict objectForKey:@"domain"];
    Domain *dominio = [Domain getDomainFromJson:domainJson];
    cat.descriptor = descriptor;
    cat.domain = dominio;
    NSArray *terms = [dict objectForKey:@"terms"];
    
    if (terms.count == 0) {
     
        NSLog(@"NESSUN TERMINE TROVATO");
        return cat;
    }
    
    NSLog(@"termini scaricati = %@", [terms description]);
    cat.terms = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *itArray = [[NSMutableArray alloc] init];
    NSMutableArray *enArray = [[NSMutableArray alloc] init];
    
    [cat.terms setObject:itArray forKey:@"it"];
    [cat.terms setObject:enArray forKey:@"en"];
    
    for (NSDictionary *termine in terms) {
        NSString *valore = [termine objectForKey:@"descriptor"];
        NSString *language = [termine objectForKey:@"language"];
        NSMutableArray *array = [cat.terms objectForKey:language];
        [array addObject:valore];
    }
    
    // italiano
    NSArray *sortedArrayIT = [[cat.terms objectForKey:@"it"] sortedArrayUsingComparator:^NSComparisonResult(NSString *p1, NSString *p2){
        return [p1 compare:p2];
    }];
    [cat.terms setObject:sortedArrayIT forKey:@"it"];
    
    //inglese
    NSArray *sortedArrayEn = [[cat.terms objectForKey:@"en"] sortedArrayUsingComparator:^NSComparisonResult(NSString *p1, NSString *p2){
        return [p1 compare:p2];
    }];
    [cat.terms setObject:sortedArrayEn forKey:@"en"];
    
    NSLog(@"terms = %@", [cat.terms description]);
    
    return cat;
}

-(CategoryCard *) createCategoryCardWithFrame:(CGRect) frame {
    CategoryCard *card = [[CategoryCard alloc] initWithFrame:frame];
    card.categoria = self;
    [card render];
    return card;
}

@end
