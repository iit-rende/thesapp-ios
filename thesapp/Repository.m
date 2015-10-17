//
//  Repository.m
//  thesapp
//
//  Created by Paolo Burzacca on 22/09/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import "Repository.h"

@implementation Repository

-(id) initWithProtocol:(id<TimelineDelegate>) delegato {
    self = [self init];
    self.timelineDelegate = delegato;
    manager = [AFHTTPRequestOperationManager manager];
    return self;
}

-(void) getSingleTerm:(NSString *)term withDomain:(Domain *) dominio andLanguage:(NSString *)lang {
    
    NSLog(@"[REPOSITORY] getSingleTerm");
    
    if (term == nil) {
        NSLog(@"Termine mancante, esco");
        return;
    }
    
    if (dominio == nil) {
        NSLog(@"Dominio mancante, esco");
        return;
    }
    
    term = [Utils WWWFormEncoded:term];
    
    NSLog(@"getSingleTerm = %@", term);
    
    NSString *dom = [Utils WWWFormEncoded:dominio.descriptor];
    
    if (dom == nil) {
        NSLog(@"Dominio non impostato");
        return;
    }
    
    NSString *domain = [@"&domain=" stringByAppendingString:dom];
    NSString *prefix = @"/terms?descriptor=";
    
    NSString *termRequest = [[[[Utils getServerBaseAddress] stringByAppendingString:prefix] stringByAppendingString:term] stringByAppendingString:domain];
    
    if (manager == nil) return;
    
    NSLog(@"termRequest = %@", termRequest);
    
    [manager.requestSerializer setValue:lang forHTTPHeaderField:@"accept-language"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:termRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        Term *term = [Term createTermFromJson:json];
        
        if (term != nil) {
            NSLog(@"RISPOSTA POSITIVA");
            [self.timelineDelegate singleTermReceived:term];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"RISPOSTA NEGATIVA");
        [self.timelineDelegate singleTermNotReceived:error.localizedDescription];
    }];
    
}

/* 
    GET DOMAINS
*/

-(void) getDomainsForLanguage:(NSString *) linguaggio {
    
    NSLog(@"[REPOSITORY] getDomainsForLanguage");
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/domains"];
    
    [manager.requestSerializer setValue:linguaggio forHTTPHeaderField:@"accept-language"];
        
    NSLog(@"Scarico domini da domainPath = %@", domainPath);
    
    [manager GET:domainPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        NSArray *domini = [json objectForKey:@"domains"];
        
        if (domini == nil) {
            NSLog(@"Domini non trovati");
            [self.timelineDelegate domainNotReceived:@"Nessun dominio trovato"];            
            return;
        }
        
        if (domini.count > 0) {
            [self.timelineDelegate domainReceived:domini];
        }
        else
            [self.timelineDelegate domainNotReceived:@"Nessun dominio trovato"];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.timelineDelegate domainNotReceived:error.localizedDescription];
        
    }];
    
}

/*
 getCategoriesByDomain
 */

-(void) getCategoriesByDomain:(Domain *) dominio {
    
    NSLog(@"[REPOSITORY] getCategoriesByDomain");
    
    if (dominio == nil) return;
    
    if (dominio.descriptor == nil) return;
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/hierarchy?domain="];
    NSString *termine = [Utils WWWFormEncoded:dominio.descriptor];
    
    if (termine == nil) return;
    
    domainPath = [domainPath stringByAppendingString:termine];
        
    [manager GET:domainPath parameters:nil
     
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *json = (NSDictionary *)responseObject;
             
             NSArray *categorie  = [json objectForKey:@"categories"];
             
             if (categorie == nil) {
                 [self.timelineDelegate domainCategoriesNotReceived:@"Errore nel reperire le categorie"];
                 return;
             }
             
             if (categorie.count > 0) {
                 [self.timelineDelegate domainCategoriesReceived:categorie forDomain:dominio];
             }
             else {
                 [self.timelineDelegate domainCategoriesNotReceived:@"Nessuna car"];
             }
         }
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.timelineDelegate domainCategoriesNotReceived:error.localizedDescription];
         }
     ];
}

-(void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio forLanguage:(NSString *) lingua {
    
    NSLog(@"[REPOSITORY] getDomainCategory");
    
    if (categoria == nil) {
        NSLog(@"categoria nulla");
        return;
    }
    
    if (dominio == nil) {
        NSLog(@"dominio nullo");
        return;
    }
    
    if (dominio.descriptor == nil) {
        NSLog(@"dominio descriptor nullo");
        return;
    }
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/hierarchy?category="];
    NSString *termine = [Utils WWWFormEncoded:categoria];
    NSString *dom = [Utils WWWFormEncoded:dominio.descriptor];
    domainPath = [[[domainPath stringByAppendingString:termine] stringByAppendingString:@"&domain="] stringByAppendingString:dom];
    
    NSLog(@"chiamo %@ con lingua %@", domainPath, lingua);
    
    [manager.requestSerializer setValue:lingua forHTTPHeaderField:@"accept-language"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:domainPath parameters:nil
     
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *json = (NSDictionary *)responseObject;
             
             if (json != nil) {
                 Categoria *cat = [Categoria createFromJson:json];
                 if (cat != nil) {
                     [self.timelineDelegate domainCategoryReceived:cat fromDomain:dominio];
                 }
                 else {
                     [self.timelineDelegate domainCategoryNotReceived:@"Categoria non trovata"];
                 }
             }
             else
                 [self.timelineDelegate domainCategoryNotReceived:@"Il server ha risposto in maniera incomprensibile"];
         }
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.timelineDelegate domainCategoryNotReceived:error.localizedDescription];
         }
     ];
}

@end
