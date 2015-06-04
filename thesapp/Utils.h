//
//  Utils.h
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+(NSString *) getServerBaseAddress;

+(NSString *) getChosenDomain;

+ (NSString*)WWWFormEncoded:(NSString *) string;

+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end
