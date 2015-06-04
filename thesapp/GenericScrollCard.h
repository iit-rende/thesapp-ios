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

@protocol CardController
- (void) goBack;
- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom;
- (void) getTerm:(NSString *) term;
- (void) getDominio:(Domain *) dominio;
- (void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio;
@end

@protocol CardName <NSObject>

-(NSString *) getName;

@end

@interface GenericScrollCard : UIScrollView<CardName>
{
    @protected
    float fullWidth, fullWithPadding, top, btnHeight, paddingLeft, titleLabelHeight;
    UIView *header, *wrapper;
    UIButton *back;
    UILabel *titolo;
}

@property (nonatomic, strong) id<CardController> controller;
@property (nonatomic, strong) Domain *dominio;

-(void) addSectionTitle:(NSString *) title;
-(void) addCardTitle:(NSString *) title;
-(void) openTerm:(Etichetta *) btn;
-(void) categoryClick:(Etichetta *) btn;
-(float) getHeaderHeightAndPadding;
-(void) prepare;
@end
