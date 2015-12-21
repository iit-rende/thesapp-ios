//
//  CardController.h
//  thesapp
//
//  Created by Paolo Burzacca on 22/09/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CardController <NSObject>

- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom inLanguage:(NSString *)lang;
- (void) getTerm:(NSString *) term inLanguage:(NSString *) lang;
- (void) getDominio:(Domain *) dominio;
- (void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio;

@optional
- (void) goBack;
@end