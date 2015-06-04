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
    
    [back addTarget:self action:@selector(dietro:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor cyanColor];
    
    //////////////////////////////////////////////////////////////
    //title label
    titolo.text = self.categoria.descriptor.descriptor;
    [titolo sizeToFit];
    //[titolo layoutIfNeeded]; //serve?
    
    //////////////////////////////////////////////////////////////
    //categorie
    
    self.clipsToBounds = YES;
    
    top = [self getHeaderHeightAndPadding];
    
    NSLog(@"TOP = %f", top);
    
    NSLog(@"ci sono %d categorie", (int) self.categoria.terms.count);

    if (self.categoria.terms.count > 0) {
        
        [self addSectionTitle:@"CATEGORIES"];
        
        int i = 0;
        float altezzaBtn = 15 + 3 * PADDING_BTN;
        float btnPaddingLeft = 2;
        float left = 0;
        float etichettaHeight = 20;
        
        NSString *lastChar;
        
        float finalHeight = top;
        
        for (NSDictionary *categoria in self.categoria.terms) {
            CGRect lblFrame = CGRectMake(btnPaddingLeft + left, top, 50, etichettaHeight);
            NSString *catTitle = [categoria objectForKey:@"descriptor"];
            if (catTitle == nil) continue;
            
            NSString *firstChar = [catTitle substringToIndex:1];
            NSLog(@"FirstChar = %@", firstChar);
            if ([firstChar isEqualToString:lastChar]) {
                NSLog(@"uguale");
            }
            else {
                NSLog(@"diverso x %@", catTitle);
                //cambio carattere
                lastChar = firstChar;
                top += altezzaBtn + 20;
                CGRect rect = CGRectMake(10, top, 100, 21);
                top += 30;
                UILabel *par = [[UILabel alloc] initWithFrame:rect];
                par.text = firstChar;
                par.textColor = [UIColor darkGrayColor];
                [par sizeToFit];
                [wrapper addSubview:par];
                
                finalHeight += par.frame.size.height;
                
                left = 0;
                lblFrame = CGRectMake(btnPaddingLeft, top, 50, etichettaHeight);
            }
            
            Etichetta *lbl = [Etichetta createCategoriaLabel:catTitle withFrame:lblFrame];
            
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
        }
        
        NSLog(@"altezza finale = %f", finalHeight);
        
        //cambio contentsize alla fine
        //CGRect newFrame = CGRectMake(0, 0, wrapper.frame.size.width, finalHeight);
        //wrapper.frame = newFrame;
        //self.contentSize = CGSizeMake(wrapper.frame.size.width, finalHeight);
    }
}

-(NSString *) getName {
    if (self.categoria != nil) return self.categoria.descriptor.descriptor;
    return @"categoria generica";
}

@end
