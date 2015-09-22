//
//  Utils.m
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString *) getCurrentLanguage {
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lingua = [myDefaults stringForKey:@"language"];
    NSLog(@"[getCurrentLanguage] %@", lingua);
    return lingua;
}

+(NSString *) getServerBaseAddress {
    return @"http://146.48.65.88";
}

+(UIColor *) getTermineCorrelatoColor {
    return [Utils colorFromHexString:@"#009688"];
}

+(UIColor *) getTerminiColor {
    return [Utils colorFromHexString:@"#5677FC"];
}

+(UIColor *) getCategoriaColor {
    return [Utils colorFromHexString:@"#1B9C17"];
}

+(UIColor *) getPiuSpecificoColor {
     return [Utils colorFromHexString:@"#FF5606"];
}

+(UIColor *) getPiuGenericoColor {
    return [Utils colorFromHexString:@"#FF9800"];
}

+(UIColor *) getTraduzioneColor {
    return [Utils colorFromHexString:@"#E51C23"];
}

+(UIColor *) getHeaderColor {
    return [Utils colorFromHexString:@"#9E9E9E"];
}

+(UIColor *) getDefaultColor {
    return [Utils colorFromHexString:@"#03A9F4"];
}

+(NSArray *) ordinaByDescriptor:(NSArray *) inputArray {
    if (inputArray == nil) return nil;
    if  ([inputArray isKindOfClass:[NSArray class]]) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descriptor" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [inputArray sortedArrayUsingDescriptors:sortDescriptors];
        return sortedArray;
    }
    return nil;
}

+(UIColor *) getChosenDomainColor {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *color = [def valueForKey:@"chosen_domain_color"];
    if (color != nil) return [Utils colorFromHexString:color];
    return nil;
}

+(NSString *) getChosenDomain {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *name = [def valueForKey:@"chosen_domain_name"];
    return [Utils WWWFormEncoded:name];
}

+ (void) setCurrentDomain:(Domain *) dominio {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:dominio.descriptor forKey:@"chosen_domain_name"];
    [def setValue:dominio.color forKey:@"chosen_domain_color"];
    NSLog(@"salvo colore %@", dominio.color);
    [def synchronize];
}

+ (NSString*)WWWFormEncoded:(NSString *) string {
    NSMutableCharacterSet *chars = NSCharacterSet.alphanumericCharacterSet.mutableCopy;
    [chars addCharactersInString:@" "];
    NSString* encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:chars];
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return encodedString;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
