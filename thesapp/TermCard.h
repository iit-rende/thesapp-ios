//
//  Card.h
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Term.h"
#import "GenericScrollCard.h"

@class TermCard;
@class Term;


@interface TermCard : GenericScrollCard<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    @private
    UITextView *descrizione;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *categorie; //test x flow layout
@property (nonatomic, strong) Term *termine;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

-(void) render;

@end
