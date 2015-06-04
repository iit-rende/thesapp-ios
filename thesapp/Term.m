//
//  Term.m
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Term.h"

@implementation Term

+(Term *) createTermFromJson:(NSDictionary *) dict {
    
    if (dict == nil) return nil;
    
    Term *term = [Term new];

    NSDictionary *domain = [dict valueForKey:@"domain"];
    
    Descriptor *desc = [Descriptor new];
    desc.descriptor = [dict valueForKey:@"descriptor"];
    
    term.descriptor = desc;
    term.language = [dict valueForKey:@"language"];
    term.scopeNote = [dict valueForKey:@"scopeNote"];
    term.domain = [Domain getDomainFromJson:domain];
    
    NSArray *categories = [dict valueForKey:@"categories"];
    NSArray *hierarchy = [dict valueForKey:@"hierarchy"];
    NSArray *relatedTerms = [dict valueForKey:@"relatedTerms"];
    NSArray *narrowerTerms = [dict valueForKey:@"narrowerTerms"];
    NSArray *broaderTerms = [dict valueForKey:@"broaderTerms"];
    NSArray *localitazions = [dict valueForKey:@"localitazions"];
    NSArray *usedFor = [dict valueForKey:@"usedFor"];
    NSArray *useFor = [dict valueForKey:@"useFor"];
    
    term.categories = categories;
    term.relatedTerms = relatedTerms;
    term.narrowerTerms = narrowerTerms;
    term.broaderTerms = broaderTerms;
    term.localitazions = localitazions;
    term.hierarchy = hierarchy;
    term.usedFor = usedFor;
    term.useFor = useFor;
    
    return term;
}

-(TermCard *) createTermCard:(TermCard *) card {
    card.termine = self;
    NSLog(@"termine card = %@", card.termine);
    [card render];
    return card;
}

@end
