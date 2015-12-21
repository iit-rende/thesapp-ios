//
//  CardName.h
//  thesapp
//
//  Created by Paolo Burzacca on 22/09/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CardName <NSObject>
    - (NSString *) getName;
    - (NSString *) getPrefix;
    - (NSString *) getKey;
    - (void) render;
    - (UIColor *) getBarColor;
@end