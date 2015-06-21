//
//  CategoryCard.h
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "GenericScrollCard.h"
#import "Categoria.h"
#import "Utils.h"

@class Categoria;

@interface CategoryCard : GenericScrollCard
@property (nonatomic, strong) Categoria *categoria;

-(void) render;

@end
