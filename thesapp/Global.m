//
//  Global.m
//  thesapp
//
//  Created by Paolo Burzacca on 21/07/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Global.h"
#import "Utils.h"

NSString *const SubscriptionTopicIT = @"/topics/IOS_TOPIC_IT";
NSString *const SubscriptionTopicEN = @"/topics/IOS_TOPIC_EN";

@implementation Global
@synthesize activeDomain, mappings, mappingsENG, mappingsITA;

+(Global *) singleton {
    
    static Global *single = nil;
    
    @synchronized(self)
    {
        if (!single)
        {
            single = [Global new];
            single.activeDomain = [Domain new];
            single.linguaInUso = nil;
            [single setLocalizedString];
            single.mappings = [[NSDictionary alloc] initWithObjectsAndKeys:single.mappingsITA,@"it", single.mappingsENG, @"en", nil];

        }
    }
    
    return single;
}

-(BOOL) isItalian {
    
    //self.linguaInUso = [Utils getCurrentLanguage];
    
    return ![self.linguaInUso isEqualToString:@"en"];
}

-(void) setNewTopicName {
    if ([self isItalian]) self.currentTopicName = SubscriptionTopicIT;
    else self.currentTopicName = SubscriptionTopicEN;
}

-(NSString *) getTopicByLanguage:(NSString *) locale {
    
    if (locale == nil) return SubscriptionTopicIT;
    
    if ([locale isEqualToString:@"it"]) {
        return SubscriptionTopicIT;
    }
    else {
        return SubscriptionTopicEN;
    }
}

-(NSString *) getTopicName {
    
    if (self.currentTopicName == nil) {
        self.currentTopicName = [self getTopicByLanguage:[Utils getCurrentLanguage]];
    }
    
    NSLog(@"get topic name = %@", self.currentTopicName);
    return self.currentTopicName;
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

-(NSString *) getLocalizedString:(NSString *) stringa forLanguage:(NSString *) lingua {
    
    if (lingua == nil) return stringa;
    
    NSDictionary *termini = [mappings objectForKey:lingua];
    
    NSLog(@"cerco traduzione per %@ in lingua %@", stringa, lingua);
    
    if (termini != nil) {
        NSString *traduzione = [termini objectForKey:stringa];
        
        if (traduzione != nil) {
            return traduzione;
        }
    }
    
    return stringa;
}

-(void) setLocalizedString {
    
    mappingsITA = [[NSMutableDictionary alloc] init];
    mappingsENG = [[NSMutableDictionary alloc] init];
    
    [mappingsITA setObject:@"Termini più specifici" forKey:@"NARROWER_TERMS"];
    [mappingsITA setObject:@"Termini più generici" forKey:@"BROADER_TERMS"];
    [mappingsITA setObject:@"Termini correlati" forKey:@"RELATED_TERMS"];
    [mappingsITA setObject:@"Termini" forKey:@"TERMS"];
    [mappingsITA setObject:@"Dominio" forKey:@"DOMAIN"];
    [mappingsITA setObject:@"Traduzioni" forKey:@"LOCALIZATIONS"];
    [mappingsITA setObject:@"Categorie" forKey:@"CATEGORIES"];
    [mappingsITA setObject:@"Sinonimi" forKey:@"SINOMINI"];
    [mappingsITA setObject:@"Descrizione" forKey:@"DESCRIPTION"];
    [mappingsITA setObject:@"Naviga il thesauro" forKey:@"BROWSE_THESAURUS"];
    
    [mappingsENG setObject:@"Narrower terms" forKey:@"NARROWER_TERMS"];
    [mappingsENG setObject:@"Broader terms" forKey:@"BROADER_TERMS"];
    [mappingsENG setObject:@"Related terms" forKey:@"RELATED_TERMS"];
    [mappingsENG setObject:@"Terms" forKey:@"TERMS"];
    [mappingsENG setObject:@"Domains" forKey:@"DOMAIN"];
    [mappingsENG setObject:@"Translations" forKey:@"LOCALIZATIONS"];
    [mappingsENG setObject:@"Categories" forKey:@"CATEGORIES"];
    [mappingsENG setObject:@"Synonyms" forKey:@"SINOMINI"];
    [mappingsENG setObject:@"Description" forKey:@"DESCRIPTION"];
    [mappingsENG setObject:@"Browse thesaurus" forKey:@"BROWSE_THESAURUS"];
}

#pragma mark - GCM Methods


@end