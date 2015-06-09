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
    cat.terms = terms;
    return cat;
}

-(CategoryCard *) createCategoryCardWithFrame:(CGRect) frame {
    CategoryCard *card = [[CategoryCard alloc] initWithFrame:frame];
    card.categoria = self;
    [card render];
    return card;
}

@end
