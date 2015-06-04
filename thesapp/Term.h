//
//  Term.h
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Domain.h"
#import "TermCard.h"
#import "Descriptor.h"

@class TermCard;

@interface Term : NSObject

//strings
@property (nonatomic, strong) Descriptor *descriptor;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *scopeNote;

//object
@property (nonatomic, strong) Domain *domain;

//arrays
@property (nonatomic, strong) NSArray *relatedTerms;
@property (nonatomic, strong) NSArray *broaderTerms;
@property (nonatomic, strong) NSArray *narrowerTerms;
@property (nonatomic, strong) NSArray *localitazions;
@property (nonatomic, strong) NSArray *hierarchy;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *usedFor;
@property (nonatomic, strong) NSArray *useFor;

+(Term *) createTermFromJson:(NSDictionary *) dict;

-(TermCard *) createTermCard:(TermCard *) card;

@end
