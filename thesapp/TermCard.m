//
//  Card.m
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "TermCard.h"
#import "CustomCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define PADDING_BTN 8

@implementation TermCard

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"[TermCard] initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        [self render];
    }
    return self;
}

-(id) init {
    NSLog(@"[TermCard] init");
    self = [super init];
    if (self) {
        [self render];
    }
    return self;
}

#pragma mark - Collection View Delegates

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"ritorno %d", (int) self.categorie.count);
    
    return [self.categorie count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (indexPath.row %2 == 0) {
     size = CGSizeMake(50, 20);
    }
    else size = CGSizeMake(100, 20);
    return size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"customCell" forIndexPath:indexPath];
    
    NSLog(@"cellForItemAtIndexPath %d", (int) indexPath.row);
    
    cell.testo.text = [self.categorie objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectItemAtIndexPath %d", (int) indexPath.row);

}

#pragma mark - Rendering

-(void) adaptViewSize {
    
    top += titleLabelHeight + 60;
    
    float newHeight = wrapper.frame.size.height + top;
    CGSize nuovaSize = CGSizeMake(wrapper.frame.size.width, newHeight);
    self.contentSize = nuovaSize;
}

-(void) render {
    
    if (self.termine == nil) {
        NSLog(@"termine mancante");
        return;
    }
    
    self.dominio = self.termine.domain;
    
    //self.clipsToBounds = YES;
    
    //[self createFlowLayout];

    //self.backgroundColor = [UIColor whiteColor];
    [back addTarget:self action:@selector(dietro:) forControlEvents:UIControlEventTouchUpInside];
    
    //////////////////////////////////////////////////////////////
    //title label
    titolo.text = self.termine.descriptor.descriptor;
    [titolo sizeToFit];

    top = [self getHeaderHeightAndPadding];    
    
    //////////////////////////////////////////////////////////////
    //albero
    
    if (self.termine.hierarchy.count > 0) {
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *categoria in self.termine.hierarchy) {
            
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            NSString *catTitle = [categoria objectForKey:@"descriptor"];
            if (catTitle == nil) continue;
            Etichetta *lbl = [Etichetta createCategoriaLabel:catTitle withFrame:lblFrame];
            [lbl addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [wrapper addSubview:lbl];
            left += 20;
            
            top += etichettaHeight + 15;
        }
    }
    
    //////////////////////////////////////////////////////////////
    //description textview
    
    float descrizione_padding_top = paddingLeft + top;
    float descrizioneHeight = 30;
    float descWidth = fullWithPadding - paddingLeft;
    
    CGRect descrizioneFrame = CGRectMake(paddingLeft, descrizione_padding_top, descWidth, descrizioneHeight);
    descrizione = [[UITextView alloc] initWithFrame:descrizioneFrame];
    descrizione.text = self.termine.scopeNote;
    descrizione.textColor = [UIColor blackColor];
    descrizione.font = [descrizione.font fontWithSize: 13.0f];
    descrizione.editable = NO;
    descrizione.selectable = NO;
    descrizione.bounces = NO;
    descrizione.bouncesZoom = NO;
    [descrizione sizeToFit];
    
    [wrapper addSubview:descrizione];
    
    //////////////////////////////////////////////////////////////
    //categorie

    top = descrizione.frame.size.height + descrizione.frame.origin.y + paddingLeft * 2;
    
    NSLog(@"ci sono %d categorie", (int) self.termine.categories.count);
    
    if (self.termine.categories.count > 0) {
    
        [self addSectionTitle:@"CATEGORIES"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *categoria in self.termine.categories) {
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            NSString *catTitle = [categoria objectForKey:@"descriptor"];
            if (catTitle == nil) continue;
            Etichetta *lbl = [Etichetta createCategoriaLabel:catTitle withFrame:lblFrame];
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(btnPaddingLeft, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //altre lingue
    
    NSLog(@"ci sono %d localitazions", (int) self.termine.localitazions.count);
    
    if (self.termine.localitazions.count > 0) {
        
        [self addSectionTitle:@"LOCALIZATIONS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.localitazions) {
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            if (catTitle == nil) continue;
            Etichetta *lbl = [Etichetta createAltraLinguaLabel:catTitle withFrame:lblFrame];
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(btnPaddingLeft, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openTerm:) forControlEvents:UIControlEventTouchUpInside];
            [wrapper addSubview:lbl];
            i++;
        }

        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //termini più generici
    
    NSLog(@"ci sono %d broaderTerms", (int) self.termine.broaderTerms.count);
    
    if (self.termine.broaderTerms.count > 0) {
        
        [self addSectionTitle:@"BROADER_TERMS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.broaderTerms) {
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            if (catTitle == nil) continue;
            Etichetta *lbl = [Etichetta createTerminePiuGenericoLabel:catTitle withFrame:lblFrame];
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(btnPaddingLeft, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openTerm:) forControlEvents:UIControlEventTouchUpInside];
            [wrapper addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //termini più specifici
    
    NSLog(@"ci sono %d narrowerTerms", (int) self.termine.narrowerTerms.count);
    
    if (self.termine.narrowerTerms.count > 0) {
        
        [self addSectionTitle:@"NARROWER_TERMS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.narrowerTerms) {
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            if (catTitle == nil) continue;
            Etichetta *lbl = [Etichetta createTerminePiuSpecificoLabel:catTitle withFrame:lblFrame];
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(btnPaddingLeft, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openTerm:) forControlEvents:UIControlEventTouchUpInside];
            [wrapper addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    [self setContentOffset: CGPointMake(0, -self.contentInset.top) animated:YES];
    
    self.contentSize = wrapper.frame.size;
}

-(NSString *) getName {
    if (self.termine != nil) return self.termine.descriptor.descriptor;
    return @"termine generico";
}

- (void)commonInit
{
    
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TermCard"
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [wrapper addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

/*
- (void)updateConstraints
{
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
