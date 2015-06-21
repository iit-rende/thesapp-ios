//
//  CategoryCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "CategoryCard.h"

#define PADDING_BTN 6
#define TITLE_LABEL_HEIGHT 20
#define PADDING_LEFT 10
#define BTN_FONT_SIZE 11.0f

@implementation CategoryCard

-(id) init {
    NSLog(@"[CategoryCard] init");
    self = [super init];
    if (self) {
        //[self render];
    }
    return self;
}

-(void) render {
    
    NSLog(@"[CategoryCard] render");
    
    lingua = [Utils getCurrentLanguage];
    
    self.layer.cornerRadius = 3;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 4.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
    
    //self.scrollView.clipsToBounds = NO;
    
    //////////////////////////////////////////////////////////////
    //title label
    titolo.text = self.categoria.descriptor.descriptor;
    [titolo sizeToFit];
    //[titolo layoutIfNeeded]; //serve?
    
    //////////////////////////////////////////////////////////////
    //categorie
    
    top = [self getHeaderHeightAndPadding];
    
    // estraggo i termini in lingua
    NSArray *termini = [self.categoria.terms objectForKey:lingua];
    
    NSLog(@"ci sono %d categorie per la lingua %@", (int) termini.count, lingua);

    if (termini.count > 0) {
        
        [self addSectionTitle:@"TERMS"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        NSString *lastChar;
        float finalHeight = top;
        float lastLabelTop = 0;
        
        for (NSString *categoria in termini) {
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            if (categoria == nil) continue;
            
            NSString *firstChar = [categoria substringToIndex:1];
            if ([firstChar isEqualToString:lastChar]) {
            }
            else {
                //cambio carattere
                lastChar = firstChar;
                top += 10  + altezzaBtn;
                CGRect rect = CGRectMake(10, top, 100, 21);
                top += 30;
                UILabel *par = [[UILabel alloc] initWithFrame:rect];
                par.text = [firstChar uppercaseString];
                par.textColor = [UIColor darkGrayColor];
                [par sizeToFit];
                [wrapper addSubview:par];
                
                finalHeight += par.frame.size.height;
                
                left = 0;
                lblFrame = CGRectMake(btnPaddingLeft, top, 50, etichettaHeight);
            }
            
            Etichetta *lbl = [Etichetta createTermineLabel:categoria withFrame:lblFrame];
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += altezzaBtn;
                [lbl setFrame:CGRectMake(btnPaddingLeft, top, lbl.frame.size.width, lbl.frame.size.height)];
                //self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            
            left = lbl.frame.size.width + lbl.frame.origin.x;
            
            [lbl addTarget:self action:@selector(openTerm:) forControlEvents:UIControlEventTouchUpInside];
            [wrapper addSubview:lbl];
            finalHeight += lbl.frame.size.height;
            i++;
            
            lastLabelTop = lbl.frame.origin.y + lbl.frame.size.height;
        }
        
        lastLabelTop += paddingLeft;
        
        NSLog(@"altezza finale = %f", finalHeight);
        NSLog(@"lastLabelTop = %f", lastLabelTop);
        
        //cambio contentsize alla fine
        CGRect newFrame = CGRectMake(0, 0, wrapper.frame.size.width, lastLabelTop);
        
        CGRect newScrollViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, wrapper.frame.size.width, lastLabelTop);
        
        wrapper.frame = newFrame;
        
        NSLog(@"wrapper = %f", wrapper.frame.size.height);
        
        self.contentSize = CGSizeMake(wrapper.frame.size.width, lastLabelTop);
        
        //self.frame = newScrollViewFrame; //se ci metto questo non scrolla
    }
    else {
        NSLog(@"ZERO CATEGORIE");
        
    }
}

-(NSString *) getName {
    if (self.categoria != nil) return self.categoria.descriptor.descriptor;
    return @"categoria generica";
}

@end
