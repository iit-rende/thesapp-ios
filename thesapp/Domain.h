//
//  Domain.h
//  ThesApp
//
//  Created by Paolo Burzacca on 14/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Domain : NSObject

@property (nonatomic, strong) NSString *descriptor;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *localization;
@property (nonatomic, strong) NSMutableDictionary *localizations;


+(Domain *) getDomainFromJson:(NSDictionary *) json;

@end
