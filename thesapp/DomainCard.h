//
//  DomainCard.h
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "GenericScrollCard.h"
#import "Domain.h"
#import "Utils.h"
#import "Localization.h"

@interface DomainCard : GenericScrollCard<UITableViewDataSource, UITableViewDelegate>
{
    float tableHeight;
}
@property (nonatomic, strong) NSArray *domini;
@property (nonatomic, strong) UITableView *tabellaDomini;
//+(DomainCard *) createWithDomain:(Domain *) dominio;

-(void) render;

@end
