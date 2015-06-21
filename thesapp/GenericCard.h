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
#import "Utils.h"
#import "GenericScrollCard.h"

@interface GenericCard : UIView<CardName>
{
@protected
    float fullWidth, fullWithPadding, top, btnHeight, paddingLeft, titleLabelHeight;
    UIView *header;
    UIButton *back;
    UILabel *titolo;
}

@property (nonatomic, strong) id<CardController> controller;
@property (nonatomic, strong) Domain *dominio;
-(void) addSectionTitle:(NSString *) title;
-(void) openTerm:(Etichetta *) btn;
-(void) categoryClick:(Etichetta *) btn;
-(float) getHeaderHeightAndPadding;
-(void) prepare;
@end
