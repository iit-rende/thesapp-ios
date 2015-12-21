//
//  GenericScrollCard.h
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Etichetta.h"
#import "Domain.h"
#import "TitoloLabel.h"
#import "CardName.h"
#import "CardController.h"
#import "Utils.h"
#import "Global.h"

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
-(NSString *) getKey;
@end
