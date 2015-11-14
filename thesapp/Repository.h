//
//  Repository.h
//  thesapp
//
//  Created by Paolo Burzacca on 22/09/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>
#import "Utils.h"
#import "DomainCard.h"
#import "Term.h"
#import "Categoria.h"
#import "TimelineDelegate.h"

@interface Repository : NSObject
{
    AFHTTPRequestOperationManager *manager;
}

@property (nonatomic, strong) id<TimelineDelegate> timelineDelegate;

-(id) initWithProtocol:(id<TimelineDelegate>) delegato;
-(void) getSingleTerm:(NSString *)term withDomain:(Domain *) dominio andLanguage:(NSString *)lang;
-(void) getDomainsForLanguage:(NSString *) linguaggio;
-(void) getCategoriesByDomain:(Domain *) dominio forLanguage:(NSString *) linguaggio;
-(void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio forLanguage:(NSString *) lingua;

@end
