//
//  Global.h
//  thesapp
//
//  Created by Paolo Burzacca on 21/07/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Domain.h"
#import <Google/CloudMessaging.h>

@interface Global : NSObject

@property (nonatomic, strong) Domain *activeDomain;
@property (nonatomic, strong) Domain *pendingDomain;
@property (nonatomic, strong) NSString *linguaInUso;
@property (nonatomic, strong) NSString *currentTopicName;
@property (nonatomic, strong) NSDictionary *mappings;
@property (nonatomic, strong) NSMutableDictionary *mappingsITA;
@property (nonatomic, strong) NSMutableDictionary *mappingsENG;

+(Global *) singleton;

-(BOOL) isItalian;
-(NSString *) getTopicName;
-(NSString *) getTopicByLanguage:(NSString *) locale;
-(void) setDominio:(Domain *) dominio;
-(void) setNewTopicName;
-(void) restoreLastDomain;
-(NSString *) getLocalizedString:(NSString *) stringa forLanguage:(NSString *) lingua;

@end