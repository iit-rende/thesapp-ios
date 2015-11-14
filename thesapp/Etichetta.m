//
//  Etichetta.m
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Etichetta.h"
#import "Utils.h"
#define PADDING_BTN 5
#define LBL_BORDER_WIDTH 1
#define LBL_FONT_SIZE 11

@implementation Etichetta

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    Etichetta *button = [super buttonWithType:buttonType];
    [button postButtonWithTypeInit];
    return button;
}

-(void) postButtonWithTypeInit {
    UIEdgeInsets titleInsets            = UIEdgeInsetsMake(0.0f, PADDING_BTN, 0.0f, -PADDING_BTN);
    UIEdgeInsets contentInsets          = UIEdgeInsetsMake(PADDING_BTN, 0.0f, PADDING_BTN, 0.0f);
    CGFloat extraWidthRequiredForTitle  = titleInsets.left - titleInsets.right;
    contentInsets.right += extraWidthRequiredForTitle;
    [self setTitleEdgeInsets:titleInsets];
    [self setContentEdgeInsets:contentInsets];
    [self sizeToFit];
    self.titleLabel.font = [UIFont systemFontOfSize:LBL_FONT_SIZE];
    self.layer.borderWidth = LBL_BORDER_WIDTH;
}

- (void) setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = self.tintColor;
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

-(void) setColor:(UIColor *) color {
    [self setTintColor:color];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.textColor = color;
    self.layer.borderColor = color.CGColor;
    
    UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [self.titleLabel setFont:boldFont];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

-(void) initLabel:(NSString *) title withFrame:(CGRect) frame {

    self.testo = title;
    [self setFrame:frame];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self setTitle:title forState:UIControlStateNormal];
    [self sizeToFit];
}

-(void) adaptSizeToMax:(float) maxSize {
    
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxSize - 20, self.frame.size.height + 10);
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self setFrame:newFrame];
}

+(Etichetta *) createTermineLabel:(NSString *) title withFrame:(CGRect) frame {
    
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[Utils getTerminiColor]];
    [lbl initLabel:title withFrame:frame];
    
    return lbl;
}

+(Etichetta *) createTermineGerarchiaLabel:(NSString *) title withFrame:(CGRect) frame {
    
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    
    UIColor *colore = [UIColor grayColor];
    
    [lbl setTintColor:colore];
    [lbl setTitleColor:colore forState:UIControlStateNormal];
    lbl.titleLabel.textColor = colore;
    lbl.layer.borderWidth = 0;
    
    UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [lbl.titleLabel setFont:boldFont];
    [lbl setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [lbl initLabel:title withFrame:frame];
    return lbl;
}

+(Etichetta *) createCategoriaLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[Utils getCategoriaColor]];
    [lbl initLabel:title withFrame:frame];
    return lbl;
}

+(Etichetta *) createAltraLinguaLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[Utils getTraduzioneColor]];
    [lbl initLabel:title withFrame:frame];
    return lbl;
}

+(Etichetta *) createTermineCorrelatoLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[Utils getTermineCorrelatoColor]];
    [lbl initLabel:title withFrame:frame];
    return lbl;
}

+(Etichetta *) createTerminePiuGenericoLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[Utils getPiuGenericoColor]];
    
    [lbl initLabel:title withFrame:frame];

    //[lbl sizeToFit];
    //CGSize maxSize = CGSizeMake(320, 100);
    //[lbl sizeThatFits:maxSize];
    return lbl;
}

+(Etichetta *) createTerminePiuSpecificoLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[Utils getPiuSpecificoColor]];
    [lbl initLabel:title withFrame:frame];
    return lbl;
}

+(Etichetta *) createTermineSinonimo:(NSString *) title withFrame:(CGRect) frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setColor:[UIColor grayColor]];
    [lbl initLabel:title withFrame:frame];
    return lbl;
}

@end
