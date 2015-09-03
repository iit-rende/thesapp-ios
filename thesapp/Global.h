//
//  Global.h
//  thesapp
//
//  Created by Paolo Burzacca on 21/07/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Domain.h"

@interface Global : NSObject

@property (nonatomic, strong) Domain *activeDomain;
@property (nonatomic, strong) Domain *pendingDomain;

+(Global *) singleton;

-(void) setDominio:(Domain *) dominio;
-(void) restoreLastDomain;
@end
