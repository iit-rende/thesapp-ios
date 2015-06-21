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
#define SECTION_BOTTOM_PADDING 15
#define TITLE_PADDING_BOTTOM 5
#define BTN_PADDING_LEFT 10
#define TITOLI_FONT_SIZE 11.0f

@implementation TermCard
@synthesize colDx, colSx;

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

-(void) aggiungiTitoloSezione:(NSString *) title {
    
    CGRect catTitleFrame = CGRectMake(paddingLeft, top, fullWithPadding - 2 * paddingLeft, titleLabelHeight);
    UILabel *catTitle = [[UILabel alloc] initWithFrame:catTitleFrame];
    catTitle.textColor = [UIColor darkGrayColor];
    catTitle.font = [catTitle.font fontWithSize:TITOLI_FONT_SIZE];
    NSString *tradotto = NSLocalizedString(title, @"");
    catTitle.text = (tradotto != nil) ? tradotto : title;
    
    [colDx addSubview:catTitle];
    
    top += titleLabelHeight + TITLE_PADDING_BOTTOM;
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
    
    top += titleLabelHeight + SECTION_BOTTOM_PADDING;
    
    float header_height = header.frame.size.height;
    
    float newHeight = colDx.frame.size.height + top;
    
    NSLog(@"nuova altezza = %f", newHeight);
    
    CGSize nuovaSize = CGSizeMake(colDx.frame.size.width, newHeight - header_height);
    
    colDx.frame = CGRectMake(colDx.frame.origin.x, colDx.frame.origin.y, nuovaSize.width, nuovaSize.height - header_height);
    
    wrapper.frame = CGRectMake(wrapper.frame.origin.x, wrapper.frame.origin.y, nuovaSize.width, nuovaSize.height);
    self.contentSize = nuovaSize;
    
    //colDx.backgroundColor = [UIColor yellowColor];
}

-(void) render {
    
    if (self.termine == nil) {
        NSLog(@"termine mancante");
        return;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    wrapper.backgroundColor = [UIColor whiteColor];
    
    float size = wrapper.frame.size.width;
    float altezza = wrapper.frame.size.height - header.frame.size.height;
    
    colDx = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height, size, altezza)];
    
    colDx.backgroundColor = [UIColor clearColor];
    
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
    
        //orizzontale
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            NSLog(@"IPAD ORIZZONTALE");
            
            colDx.frame = CGRectMake(size / 2, header.frame.size.height, size / 2, wrapper.frame.size.height);
            colDx.backgroundColor = [UIColor orangeColor];
            colSx = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height, size / 2, wrapper.frame.size.height)];
            colSx.backgroundColor = [UIColor greenColor];
            [wrapper addSubview:colSx];
        }
        else NSLog(@"IPHONE ORIZZONTALE");
        
    }
    
    [wrapper addSubview:colDx];
    
    self.dominio = self.termine.domain;
    
    //self.clipsToBounds = YES;
    //[self createFlowLayout];
    //self.backgroundColor = [UIColor whiteColor];
    //[back addTarget:self action:@selector(dietro:) forControlEvents:UIControlEventTouchUpInside];
    
    //////////////////////////////////////////////////////////////
    //title label
    titolo.text = self.termine.descriptor.descriptor;
    [titolo sizeToFit];
    
    lingua = self.termine.language;
    

    top = [self getHeaderHeightAndPadding];    
    
    //////////////////////////////////////////////////////////////
    //albero
    
    //TODO: Albero tolto
    if (self.termine.hierarchy.count > 0 && 5==4) {
        
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
            [colDx addSubview:lbl];
            left += 20;
            
            top += etichettaHeight + 15;
        }
    }
    
    //////////////////////////////////////////////////////////////
    //description textview
    
    top = paddingLeft * 2;
    
    NSLog(@"top = %f", top);
    
    //float descrizione_padding_top = 0; //paddingLeft + top;
    float descrizioneHeight = 30;
    float descWidth = fullWithPadding - paddingLeft;
    
    if (self.termine.scopeNote != nil) {
    
        if (self.termine.scopeNote.length > 0) {
            
            [self aggiungiTitoloSezione:@"DESCRIPTION"];
            
            CGRect descrizioneFrame = CGRectMake(paddingLeft, top, descWidth, descrizioneHeight);
            
            descrizione = [[UITextView alloc] initWithFrame:descrizioneFrame];
            descrizione.text = self.termine.scopeNote;
            descrizione.textColor = [UIColor blackColor];
            descrizione.font = [descrizione.font fontWithSize: 13.0f];
            descrizione.editable = NO;
            descrizione.selectable = NO;
            descrizione.bounces = NO;
            descrizione.bouncesZoom = NO;
            //descrizione.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
            //[descrizione setTextContainerInset:UIEdgeInsetsMake(10, 0, 10, 0)];
            [descrizione sizeToFit];
     
            [colDx addSubview:descrizione];
            
            top = descrizione.frame.size.height + descrizione.frame.origin.y + paddingLeft * 2;
        }
    }
    
    //top = descrizione.frame.origin.y + paddingLeft * 2;
    
    //////////////////////////////////////////////////////////////
    //categorie

    NSLog(@"ci sono %d categorie", (int) self.termine.categories.count);
    
    if (self.termine.categories.count > 0) {
    
        [self aggiungiTitoloSezione:@"CATEGORIES"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *categoria in self.termine.categories) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, etichettaHeight);
            NSString *catTitle = [categoria objectForKey:@"descriptor"];
            NSString *language = [categoria objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createCategoriaLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //altre lingue
    
    NSLog(@"ci sono %d localitazions", (int) self.termine.localizations.count);
    
    if (self.termine.localizations.count > 0) {
        
        [self aggiungiTitoloSezione:@"LOCALIZATIONS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.localizations) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, etichettaHeight);
            
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createAltraLinguaLabel:catTitle withFrame:lblFrame];
            lbl.lingua = language;
            
            NSLog(@"IMPOSTO ETICHETTA %@ IN %@", language, catTitle);
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
            i++;
        }

        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //sinonimi
    
    NSLog(@"ci sono %d sinonimi", (int) self.termine.useFor.count);
    
    if (self.termine.useFor.count > 0) {
        
        [self aggiungiTitoloSezione:@"SINOMINI"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.useFor) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTermineSinonimo:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }    
    
    //////////////////////////////////////////////////////////////
    //termini più generici
    
    NSLog(@"ci sono %d broaderTerms", (int) self.termine.broaderTerms.count);
    
    if (self.termine.broaderTerms.count > 0) {
        
        [self aggiungiTitoloSezione:@"BROADER_TERMS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.broaderTerms) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTerminePiuGenericoLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            NSLog(@"aggiungo termine più generico %@ in lingua %@", catTitle, language);
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //termini più specifici
    
    NSLog(@"ci sono %d narrowerTerms", (int) self.termine.narrowerTerms.count);
    
    if (self.termine.narrowerTerms.count > 0) {
        
        [self aggiungiTitoloSezione:@"NARROWER_TERMS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.narrowerTerms) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTerminePiuSpecificoLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //termini correlati
    
    NSLog(@"ci sono %d relatedTerms", (int) self.termine.relatedTerms.count);
    
    if (self.termine.relatedTerms.count > 0) {
        
        [self aggiungiTitoloSezione:@"RELATED_TERMS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float left = 0;
        float etichettaHeight = 20;
        
        for (NSDictionary *parola in self.termine.relatedTerms) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, etichettaHeight);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTermineCorrelatoLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            left = lbl.frame.size.width + lbl.frame.origin.x;
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
            i++;
        }
        
        [self adaptViewSize];
    }
    
    //[self setContentOffset: CGPointMake(0, -self.contentInset.top) animated:YES];
    
    //float contentHeight = 2000; //colDx.frame.size.height + header.frame.size.height;
    //CGSize nuovaSize = CGSizeMake(colDx.frame.size.width, contentHeight);
    //wrapper.frame = CGRectMake(wrapper.frame.origin.x, wrapper.frame.origin.y, nuovaSize.width, nuovaSize.height);
    //self.contentSize = nuovaSize;
    
    //self.clipsToBounds = YES;
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
