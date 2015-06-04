//
//  Domain.m
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Domain.h"

@implementation Domain

+(Domain *) getDomainFromJson:(NSDictionary *) json {

    if (json == nil) return nil;
    
    Domain *dominio = [Domain new];
    
    dominio.descriptor = [json valueForKey:@"descriptor"];
    dominio.icon = [json valueForKey:@"icon"]; //UIImage
    dominio.color = [json valueForKey:@"color"]; //UIColor

    dominio.localizations = nil; //todo
    
    return dominio;
}

@end
