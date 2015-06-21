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

@implementation Etichetta

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


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
    self.titleLabel.font = [UIFont systemFontOfSize:11.0];
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

+(Etichetta *) createTermineLabel:(NSString *) title withFrame:(CGRect) frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[Utils getTerminiColor]];
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    return lbl;
}

+(Etichetta *) createCategoriaLabel:(NSString *) title withFrame:(CGRect)frame {
    
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[Utils getCategoriaColor]];
    
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    return lbl;
}

+(Etichetta *) createAltraLinguaLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[Utils getTraduzioneColor]];
    
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    
    return lbl;
}

+(Etichetta *) createTermineCorrelatoLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[Utils getTermineCorrelatoColor]];
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    
    return lbl;
}

+(Etichetta *) createTerminePiuGenericoLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[Utils getPiuGenericoColor]];
    
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    
    return lbl;
}

+(Etichetta *) createTerminePiuSpecificoLabel:(NSString *) title withFrame:(CGRect)frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[Utils getPiuSpecificoColor]];
    
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    
    return lbl;
}

+(Etichetta *) createTermineSinonimo:(NSString *) title withFrame:(CGRect) frame {
    Etichetta *lbl = [Etichetta buttonWithType:UIButtonTypeCustom];
    [lbl setFrame:frame];
    [lbl setColor:[UIColor grayColor]];
    
    [lbl setTitle:title forState:UIControlStateNormal];
    [lbl sizeToFit];
    
    return lbl;
}

@end
