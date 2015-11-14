//
//  Global.m
//  thesapp
//
//  Created by Paolo Burzacca on 21/07/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Global.h"

@implementation Global
@synthesize activeDomain;

+(Global *) singleton {
    
    static Global *single = nil;
    
    @synchronized(self)
    {
        if (!single)
        {
            single = [Global new];
            single.activeDomain = [Domain new];
            single.linguaInUso = nil;
        }
    }
    
    return single;
}

-(void) restoreLastDomain {
    
    if (self.pendingDomain == nil) {
        NSLog(@"nessun pending domain");
        return;
    }
    
    NSLog(@"ultimo dominio era %@", self.pendingDomain.descriptor);
    self.activeDomain = self.pendingDomain;
}

-(void) setDominio:(Domain *) dominio {
    BOOL nullo = dominio == nil;
    if (nullo) NSLog(@"setDominio nullo");
    else NSLog(@"setDominio = %@", dominio.descriptor);
    if (nullo) self.pendingDomain = self.activeDomain;
    self.activeDomain = dominio;
}

@end
