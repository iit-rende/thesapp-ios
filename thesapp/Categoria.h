//
//  Categoria.h
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Descriptor.h"
#import "Domain.h"
#import "CategoryCard.h"

@class CategoryCard;
@interface Categoria : NSObject

@property (nonatomic, strong) Descriptor *descriptor;
@property (nonatomic, strong) Domain *domain;
@property (nonatomic, strong) NSMutableDictionary *terms;
@property (nonatomic, strong) NSString *selectedLanguage;

+(Categoria *) createFromJson:(NSDictionary *) dict;

-(CategoryCard *) createCategoryCardWithFrame:(CGRect) frame;

@end
