//
//  Term.m
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Term.h"
#import "Utils.h"

@implementation Term

+(Term *) createTermFromJson:(NSDictionary *) dict {
    
    if (dict == nil) return nil;
    
    Term *term = [Term new];

    NSLog(@"termine = %@", [dict description]);
    
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
    NSArray *localizations = [dict valueForKey:@"localizations"];
    NSArray *usedFor = [dict valueForKey:@"usedFor"];
    NSArray *useFor = [dict valueForKey:@"useFor"];
    
    term.categories = [Utils ordinaByDescriptor:categories];
    term.relatedTerms = [Utils ordinaByDescriptor:relatedTerms];
    term.narrowerTerms = [Utils ordinaByDescriptor:narrowerTerms];
    term.broaderTerms = [Utils ordinaByDescriptor:broaderTerms];
    term.localizations = [Utils ordinaByDescriptor:localizations];
    term.hierarchy = [Utils ordinaByDescriptor:hierarchy];
    term.usedFor = [Utils ordinaByDescriptor:usedFor];
    term.useFor = [Utils ordinaByDescriptor:useFor];
    
    return term;
}

-(TermCard *) createTermCard:(TermCard *) card {
    card.termine = self;
    [card render];
    return card;
}

@end
