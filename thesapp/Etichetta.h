//
//  Etichetta.h
//  ThesApp
//
//  Created by Paolo Burzacca on 15/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Etichetta : UIButton

+(Etichetta *) createCategoriaLabel:(NSString *) title withFrame:(CGRect) frame;
+(Etichetta *) createAltraLinguaLabel:(NSString *) title withFrame:(CGRect) frame;
+(Etichetta *) createTermineCorrelatoLabel:(NSString *) title withFrame:(CGRect) frame;
+(Etichetta *) createTerminePiuGenericoLabel:(NSString *) title withFrame:(CGRect) frame;
+(Etichetta *) createTerminePiuSpecificoLabel:(NSString *) title withFrame:(CGRect) frame;

@end
