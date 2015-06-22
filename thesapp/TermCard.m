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
#define BTN_HEIGHT 40
#define DESC_HEIGHT 30
#define LABEL_HEIGHT 20
#define SECTION_BOTTOM_PADDING 15
#define TITLE_PADDING_BOTTOM 5
#define BTN_PADDING_LEFT 10
#define TITOLI_FONT_SIZE 11.0f
#define DESC_FONT_SIZE 13.0f

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
    
    CGRect catTitleFrame = CGRectMake(paddingLeft, top, colDx.frame.size.width - 2 * paddingLeft, titleLabelHeight);
    UILabel *catTitle = [[UILabel alloc] initWithFrame:catTitleFrame];
    catTitle.textColor = [UIColor darkGrayColor];
    catTitle.font = [catTitle.font fontWithSize:TITOLI_FONT_SIZE];
    NSString *tradotto = NSLocalizedString(title, @"");
    catTitle.text = (tradotto != nil) ? tradotto : title;
    
    [colDx addSubview:catTitle];
    
    top += titleLabelHeight + TITLE_PADDING_BOTTOM;
}

#pragma mark - Rendering

-(void) adaptViewSize {

    NSLog(@"######################");
    NSLog(@"current top = %f", top);
    NSLog(@"colDx height = %f", colDx.frame.size.height);
    NSLog(@"wrapper height = %f", wrapper.frame.size.height);
    NSLog(@"######################");
    
    if (top > colDx.frame.size.height) {
        float header_height = header.frame.size.height;
        
        float wrapperNewHeight = top + header_height;
        wrapper.frame = CGRectMake(wrapper.frame.origin.x, wrapper.frame.origin.y, wrapper.frame.size.width, wrapperNewHeight);
        
        colDx.frame = CGRectMake(colDx.frame.origin.x, colDx.frame.origin.y, colDx.frame.size.width, top);
        
        NSLog(@"nuova wrapper height = %f", wrapperNewHeight);
        
        CGSize nuovaSize = CGSizeMake(self.contentSize.width, wrapperNewHeight);
        self.contentSize = nuovaSize;
    }
    
}

-(void) drawLefTree {

    float leftTop = paddingLeft;
    
    CGRect catTitleFrame = CGRectMake(paddingLeft, leftTop, fullWithPadding - 2 * paddingLeft, titleLabelHeight);
    UILabel *catTitle = [[UILabel alloc] initWithFrame:catTitleFrame];
    catTitle.textColor = [UIColor darkGrayColor];
    catTitle.font = [catTitle.font fontWithSize:TITOLI_FONT_SIZE];
    catTitle.text = NSLocalizedString(@"BROWSE_THESAURUS", @"naviga thesaurus");
    
    [colSx addSubview:catTitle];
    
    leftTop += catTitle.frame.size.height + paddingLeft;
    
    BOOL drawTree = self.termine.hierarchy.count > 0;
    
    NSMutableArray *gerarchia;
    
    NSMutableDictionary *lastTermine = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.termine.descriptor.descriptor, @"descriptor", nil];
    
    if (!drawTree) {
        
        if (self.termine.narrowerTerms.count > 0) {
            //non bisogna indentare
            gerarchia = [[NSMutableArray alloc] init];
            [gerarchia addObject:lastTermine];
            [gerarchia addObjectsFromArray:self.termine.narrowerTerms];
        }
    }
    else {
        //bisogna indentare
        gerarchia = [[NSMutableArray alloc] initWithArray:self.termine.hierarchy];
        
        [gerarchia addObject:lastTermine];
        
        //aggiungo i narrower terms
        
        if (self.termine.narrowerTerms.count > 0) {
            //non bisogna indentare
            [gerarchia addObjectsFromArray:self.termine.narrowerTerms];
        }
        
    }
    
    if (gerarchia.count > 0) {
        
        int i = 0;
        float btnPaddingLeft = 2;
        float left = 0;
        int indent = 0;
        BOOL sameLevel = NO;
        NSString *dot = @" · ";
        
        for (NSDictionary *categoria in gerarchia) {
            
            CGRect lblFrame = CGRectMake(btnPaddingLeft, leftTop, 50, LABEL_HEIGHT);

            NSString *catTitle = [categoria objectForKey:@"descriptor"];
            
            BOOL questo = [catTitle isEqualToString:self.termine.descriptor.descriptor];
            
            if (questo) sameLevel = YES;
            
            NSString *wildcards = @"";
            
            if (!sameLevel) {
                indent++;
                for (int c=0; c<indent-1; c++) {
                    wildcards = [wildcards stringByAppendingString:dot];
                }
            }
            else {
            
                for (int c=0; c<indent; c++) {
                    wildcards = [wildcards stringByAppendingString:dot];
                }
                
                if (questo) indent++;
            }
            
            wildcards = [wildcards stringByAppendingString:dot];
            
            //NSString *catTitle = [wildcards stringByAppendingString:[categoria objectForKey:@"descriptor"]];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTermineGerarchiaLabel:catTitle withFrame:lblFrame];
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            //lbl.titleLabel.text = [wildcards stringByAppendingString:lbl.titleLabel.text];
            [lbl setTitle:[wildcards stringByAppendingString:lbl.titleLabel.text] forState:UIControlStateNormal];
            [lbl sizeToFit];
            
            //if  (i < gerarchia.count -1) {
            if (!questo) {
                //[lbl setTintColor:[UIColor brownColor]];
                //lbl.titleLabel.textColor = [UIColor brownColor];
                [lbl setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            }
            
            [colSx addSubview:lbl];
            left += 20;
            
            leftTop += LABEL_HEIGHT + 15;
            i++;
        }
    }
    
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
        
        float COL_WIDTH = size / 2 - 1;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            NSLog(@"IPAD ORIZZONTALE");
            
            colDx.frame = CGRectMake(size / 2, header.frame.size.height, COL_WIDTH , wrapper.frame.size.height);
            
            NSLog(@"x = %f", colDx.frame.origin.x);
            NSLog(@"y = %f", colDx.frame.origin.y);
            
            colSx = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height, COL_WIDTH, wrapper.frame.size.height)];
            
            //colSx.clipsToBounds = YES;
            [wrapper addSubview:colSx];
            
            //separator
            
            float sepHeight = colDx.frame.size.height - header.frame.size.height - 2 * BTN_PADDING_LEFT;
            float sepY = header.frame.size.height + BTN_PADDING_LEFT;
            
            CGRect sepFrame = CGRectMake(colSx.frame.size.width, sepY, 1, sepHeight);
            sep = [[UIView alloc] initWithFrame:sepFrame];
            sep.backgroundColor = [UIColor lightGrayColor];
            [wrapper addSubview:sep];
            
            [self drawLefTree];
            
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
    
    //top = [self getHeaderHeightAndPadding];
  
    //////////////////////////////////////////////////////////////
    //description textview
    
    top = paddingLeft * 2;
    
    //float descrizione_padding_top = 0; //paddingLeft + top;
    
    if (self.termine.scopeNote != nil) {
    
        if (self.termine.scopeNote.length > 0) {
            
            float descWidth = colDx.frame.size.width - 2 * paddingLeft;
            
            [self aggiungiTitoloSezione:@"DESCRIPTION"];
            
            CGRect descrizioneFrame = CGRectMake(paddingLeft, top, descWidth, DESC_HEIGHT);
            
            descrizione = [[UITextView alloc] initWithFrame:descrizioneFrame];
            descrizione.text = self.termine.scopeNote;
            descrizione.textColor = [UIColor blackColor];
            descrizione.font = [descrizione.font fontWithSize: DESC_FONT_SIZE];
            descrizione.editable = NO;
            descrizione.selectable = NO;
            descrizione.bounces = NO;
            descrizione.bouncesZoom = NO;
            
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
        
        float left = 0;
        
        for (NSDictionary *categoria in self.termine.categories) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, LABEL_HEIGHT);
            NSString *catTitle = [categoria objectForKey:@"descriptor"];
            //NSString *language = [categoria objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createCategoriaLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            left = [self getLabelLeft:lbl];

            [lbl addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
        }
        
        top += titleLabelHeight + SECTION_BOTTOM_PADDING;
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //altre lingue
    
    NSLog(@"ci sono %d localitazions", (int) self.termine.localizations.count);
    
    if (self.termine.localizations.count > 0) {
        
        [self aggiungiTitoloSezione:@"LOCALIZATIONS"];
        
        float left = 0;
        
        for (NSDictionary *parola in self.termine.localizations) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, LABEL_HEIGHT);
            
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createAltraLinguaLabel:catTitle withFrame:lblFrame];
            lbl.lingua = language;
            
            left = [self getLabelLeft:lbl];
            
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
        }
        
        top += titleLabelHeight + SECTION_BOTTOM_PADDING;

        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //sinonimi
    
    NSLog(@"ci sono %d sinonimi", (int) self.termine.useFor.count);
    
    if (self.termine.useFor.count > 0) {
        
        [self aggiungiTitoloSezione:@"SINOMINI"];
        
        float left = 0;
        
        for (NSDictionary *parola in self.termine.useFor) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, LABEL_HEIGHT);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            //NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTermineSinonimo:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            left = [self getLabelLeft:lbl];
            
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
        }
        
        top += titleLabelHeight + SECTION_BOTTOM_PADDING;
        
        [self adaptViewSize];
    }    
    
    //////////////////////////////////////////////////////////////
    //termini più generici
    
    NSLog(@"ci sono %d broaderTerms", (int) self.termine.broaderTerms.count);
    
    if (self.termine.broaderTerms.count > 0) {
        
        [self aggiungiTitoloSezione:@"BROADER_TERMS"];
        
        float left = 0;
        
        for (NSDictionary *parola in self.termine.broaderTerms) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, LABEL_HEIGHT);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTerminePiuGenericoLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            NSLog(@"aggiungo termine più generico %@ in lingua %@", catTitle, language);
            
            left = [self getLabelLeft:lbl];
            
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
        }
        
        top += titleLabelHeight + SECTION_BOTTOM_PADDING;
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //termini più specifici
    
    NSLog(@"ci sono %d narrowerTerms", (int) self.termine.narrowerTerms.count);
    
    if (self.termine.narrowerTerms.count > 0) {
        
        [self aggiungiTitoloSezione:@"NARROWER_TERMS"];
        
        float left = 0;
        
        for (NSDictionary *parola in self.termine.narrowerTerms) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, LABEL_HEIGHT);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            //NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTerminePiuSpecificoLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            left = [self getLabelLeft:lbl];
            
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
        }
        
        top += titleLabelHeight + SECTION_BOTTOM_PADDING;
        
        [self adaptViewSize];
    }
    
    //////////////////////////////////////////////////////////////
    //termini correlati
    
    NSLog(@"ci sono %d relatedTerms", (int) self.termine.relatedTerms.count);
    
    if (self.termine.relatedTerms.count > 0) {
        
        [self aggiungiTitoloSezione:@"RELATED_TERMS"];
        
        float left = 0;
        
        for (NSDictionary *parola in self.termine.relatedTerms) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, 50, LABEL_HEIGHT);
            NSString *catTitle = [parola objectForKey:@"descriptor"];
            //NSString *language = [parola objectForKey:@"language"];
            
            if (catTitle == nil) continue;
            
            Etichetta *lbl = [Etichetta createTermineCorrelatoLabel:catTitle withFrame:lblFrame];
            //lbl.lingua = language;
            
            left = [self getLabelLeft:lbl];
            
            [lbl addTarget:self action:@selector(openLocalizedTerm:) forControlEvents:UIControlEventTouchUpInside];
            [colDx addSubview:lbl];
        }
        
        top += titleLabelHeight + SECTION_BOTTOM_PADDING;
        
        [self adaptViewSize];
    }
    
    //colSx la faccio alta come colDx (in realtà andrebbe presa la più lunga)
    if (colSx != nil) colSx.frame = CGRectMake(
                                               colSx.frame.origin.x,
                                               colSx.frame.origin.y,
                                               colSx.frame.size.width,
                                               colDx.frame.size.height
                                               );
    
    float nuovaSepHeight = colDx.frame.size.height - 2 * BTN_PADDING_LEFT;
    
    sep.frame = CGRectMake(sep.frame.origin.x, sep.frame.origin.y, sep.frame.size.width, nuovaSepHeight);
    
    
    //[self setContentOffset: CGPointMake(0, -self.contentInset.top) animated:YES];
    
    //float contentHeight = 2000; //colDx.frame.size.height + header.frame.size.height;
    //CGSize nuovaSize = CGSizeMake(colDx.frame.size.width, contentHeight);
    //wrapper.frame = CGRectMake(wrapper.frame.origin.x, wrapper.frame.origin.y, nuovaSize.width, nuovaSize.height);
    //self.contentSize = nuovaSize;
    
    //self.clipsToBounds = YES;
}

-(float) getLabelLeft:(Etichetta *)lbl {

    if (lbl.frame.size.width + lbl.frame.origin.x > colDx.frame.size.width ) {
        top += BTN_HEIGHT;
        [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
        self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + BTN_HEIGHT);
    }
    
    return lbl.frame.size.width + lbl.frame.origin.x;
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

@end
