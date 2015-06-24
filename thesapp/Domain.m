//
//  Domain.m
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Domain.h"
#import "Localization.h"

@implementation Domain

+(Domain *) getDomainFromJson:(NSDictionary *) json {

    if (json == nil) return nil;
    
    Domain *dominio = [Domain new];
    
    dominio.descriptor = [json valueForKey:@"descriptor"];
    dominio.icon = [json valueForKey:@"icon"];
    dominio.color = [json valueForKey:@"color"];

    NSArray *localizations = [json valueForKey:@"localizations"];
    
    dominio.localization = [json valueForKey:@"localization"];
    dominio.localizations = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *loc in localizations) {
        Localization *localiz = [[Localization alloc] init];
        localiz.termCount = [[loc objectForKey:@"termCount"] intValue];
        localiz.descriptor = [loc objectForKey:@"descriptor"];
        localiz.descrizione = [loc objectForKey:@"description"];
        NSString *lingua = [loc objectForKey:@"language"];
        localiz.language = lingua;
        
        [dominio.localizations setObject:localiz forKey:lingua];
    }
    
    return dominio;
}

@end
