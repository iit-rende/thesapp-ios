//
//  TimelineDelegate.h
//  thesapp
//
//  Created by Paolo Burzacca on 22/09/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Term;
@protocol TimelineDelegate <NSObject>

-(void) singleTermReceived:(Term *) term;
-(void) singleTermNotReceived:(NSString *) error;

-(void) domainReceived:(NSArray *) domainlist;
-(void) domainNotReceived:(NSString *) error;

-(void) domainCategoriesReceived:(NSArray *) categoriesList forDomain:(Domain *) dominio;
-(void) domainCategoriesNotReceived:(NSString *) error;

-(void) domainCategoryReceived:(Categoria *) category fromDomain:(Domain *) dominio;
-(void) domainCategoryNotReceived:(NSString *) error;

@end
