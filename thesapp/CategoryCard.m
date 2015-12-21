//
//  CategoryCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "CategoryCard.h"

#define PADDING_BTN 6
#define BTN_HEIGHT 33
#define BTN_WIDTH 50
#define TITLE_LABEL_HEIGHT 20
#define PADDING_LEFT 10
#define BTN_PADDING_LEFT 15
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
    
    lingua = (self.categoria.selectedLanguage != nil) ? self.categoria.selectedLanguage : [Utils getCurrentLanguage];
    
    /*
     TEMP
    self.layer.cornerRadius = 3;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 4.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    */
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.clipsToBounds = NO;
    
    titolo.text = self.categoria.descriptor.descriptor;
    [titolo sizeToFit];
    //[header sizeToFit];
    
    float titoloTop = titolo.frame.origin.y + titolo.frame.size.height;
    
    header.frame = CGRectMake(
                              header.frame.origin.x,
                              header.frame.origin.y,
                              header.frame.size.width,
                              titoloTop + 20);
    
    
    //categorie
    top = [self getHeaderHeightAndPadding];
    
    //NSLog(@"[TOP] = %d", top);
    
    // estraggo i termini in lingua
    NSArray *termini = [self.categoria.terms objectForKey:lingua];
    
    NSLog(@"ci sono %d categorie per la lingua %@", (int) termini.count, lingua);

    if (termini.count > 0) {
        
        [self addSectionTitle:@"TERMS"];

        BOOL primo = YES;
        
        float left = 0;
        NSString *lastChar;
        float finalHeight = top;
        float lastLabelTop = 0;
        
        for (NSString *categoria in termini) {
            CGRect lblFrame = CGRectMake(BTN_PADDING_LEFT + left, top, BTN_WIDTH, TITLE_LABEL_HEIGHT);
            if (categoria == nil) continue;
            
            NSString *firstChar = [categoria substringToIndex:1];
            if (![firstChar isEqualToString:lastChar]) {
                //cambio carattere
                lastChar = firstChar;
                
                top += 10;
                if (!primo) {
                    top += BTN_HEIGHT;
                }
                
                primo = NO;
                
                CGRect rect = CGRectMake(BTN_PADDING_LEFT, top, 100, TITLE_LABEL_HEIGHT);
                
                top += 30;
                
                UILabel *par = [[UILabel alloc] initWithFrame:rect];
                par.text = [firstChar uppercaseString];
                par.textColor = [UIColor darkGrayColor];
                [par sizeToFit];
                [wrapper addSubview:par];
                
                finalHeight += par.frame.size.height;
                
                left = 0;
                lblFrame = CGRectMake(BTN_PADDING_LEFT, top, BTN_WIDTH, TITLE_LABEL_HEIGHT);
            }
            
            Etichetta *lbl = [Etichetta createTermineLabel:categoria withFrame:lblFrame];
            
            if (lbl.frame.size.width + lbl.frame.origin.x > fullWithPadding) {
                top += BTN_HEIGHT;
                [lbl setFrame:CGRectMake(BTN_PADDING_LEFT, top, lbl.frame.size.width, lbl.frame.size.height)];
                //self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height + altezzaBtn);
            }
            
            float maxLabelWidth = fullWithPadding - 2 * BTN_PADDING_LEFT;
            
            if (lbl.frame.size.width > maxLabelWidth) {
                [lbl setFrame:CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, maxLabelWidth, lbl.frame.size.height)];
            }
            
            left = lbl.frame.size.width + lbl.frame.origin.x;
            
            [lbl addTarget:self action:@selector(openTerm:) forControlEvents:UIControlEventTouchUpInside];
            
            [wrapper addSubview:lbl];
            
            finalHeight += lbl.frame.size.height;
            
            lastLabelTop = lbl.frame.origin.y + lbl.frame.size.height;
        }
        
        lastLabelTop += PADDING_LEFT;
        
        NSLog(@"altezza finale = %f", finalHeight);
        NSLog(@"lastLabelTop = %f", lastLabelTop);
        
        //cambio contentsize alla fine
        CGRect newFrame = CGRectMake(0, 0, wrapper.frame.size.width, lastLabelTop);
        
        //CGRect newScrollViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, wrapper.frame.size.width, lastLabelTop);
        
        wrapper.frame = newFrame;
        self.contentSize = CGSizeMake(wrapper.frame.size.width, lastLabelTop);
        
        //self.frame = newScrollViewFrame; //se ci metto questo non scrolla
    }
}

-(NSString *) getName {
    if (self.categoria != nil) return self.categoria.descriptor.descriptor;
    return @"categoria generica";
}

-(NSString *) getPrefix {
    return @"C_";
}

@end
