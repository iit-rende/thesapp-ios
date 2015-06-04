//
//  DomainCategoryCard.h
//  ThesApp
//
//  Created by Paolo Burzacca on 22/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "GenericScrollCard.h"

@interface DomainCategoryCard : GenericScrollCard<UITableViewDataSource, UITableViewDelegate>
{
    float tableHeight;
}
@property (nonatomic, strong) NSArray *categorie;
@property (nonatomic, strong) UITableView *tabellaCategorie;
-(void) render;

@end
