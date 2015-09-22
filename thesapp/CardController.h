//
//  CardController.h
//  thesapp
//
//  Created by Paolo Burzacca on 22/09/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CardController <NSObject>

- (void) goBack;
- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom;
- (void) getTerm:(NSString *) term inLanguage:(NSString *) lang;
- (void) getDominio:(Domain *) dominio;
- (void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio;

@end
