//
//  GenericCard.h
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Etichetta.h"
#import "Domain.h"
#import "TitoloLabel.h"

@protocol CardController
- (void) goBack;
- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom;
- (void) getTerm:(NSString *) term inLanguage:(NSString *) lang;
- (void) getDominio:(Domain *) dominio;
- (void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio;
@end

@protocol CardName <NSObject>

-(NSString *) getName;

@end

@interface GenericScrollCard : UIScrollView<CardName>
{
    @protected
    float fullWidth, fullWithPadding, top, paddingLeft, titleLabelHeight;
    UIView *header, *wrapper;
    UIButton *back;
    TitoloLabel *titolo;
    NSString *lingua;
}

@property (nonatomic, strong) id<CardController> controller;
@property (nonatomic, strong) Domain *dominio;

-(void) addSectionTitle:(NSString *) title;
-(void) addCardTitle:(NSString *) title;
-(void) openTerm:(Etichetta *) btn;
-(void) openLocalizedTerm:(Etichetta *) btn;
-(void) categoryClick:(Etichetta *) btn;
-(float) getHeaderHeightAndPadding;
-(void) prepare;
@end
