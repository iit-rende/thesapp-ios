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

extern NSString * const LANGUAGE;

@interface Utils : NSObject

+ (NSString *) getServerBaseAddress;
+ (NSString *) getCurrentLanguage;
+ (NSString *) getChosenDomain;
+ (UIColor *) getChosenDomainColor;
+ (UIColor *) getTerminiColor;
+ (UIColor *) getTermineCorrelatoColor;
+ (UIColor *) getCategoriaColor;
+ (UIColor *) getPiuSpecificoColor;
+ (UIColor *) getPiuGenericoColor;
+ (UIColor *) getTraduzioneColor;
+ (UIColor *) getHeaderColor;
+ (UIColor *) getDefaultColor;
+ (void) setCurrentDomain:(Domain *) dominio;
+ (NSArray *) ordinaByDescriptor:(NSArray *) inputArray;
+ (NSString*)WWWFormEncoded:(NSString *) string;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (BOOL) saveJsonToDisk:(NSString *)json withName:(NSString *)nome;
+ (Domain *) getDomainFromFile:(NSString *) domaiName;
+ (BOOL) saveLanguage:(NSString *) lingua;
+ (NSString *) getDeviceLanguage;
@end
