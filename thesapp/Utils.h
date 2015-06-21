//
//  Utils.h
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Domain.h"

@interface Utils : NSObject

+(NSString *) getServerBaseAddress;
+(NSString *) getCurrentLanguage;
+(NSString *) getChosenDomain;
+(UIColor *) getChosenDomainColor;
+(UIColor *) getTerminiColor;
+(UIColor *) getTermineCorrelatoColor;
+(UIColor *) getCategoriaColor;
+(UIColor *) getPiuSpecificoColor;
+(UIColor *) getPiuGenericoColor;
+(UIColor *) getTraduzioneColor;
+(UIColor *) getHeaderColor;

+ (void) setCurrentDomain:(Domain *) dominio;

+ (NSString*)WWWFormEncoded:(NSString *) string;

+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end
