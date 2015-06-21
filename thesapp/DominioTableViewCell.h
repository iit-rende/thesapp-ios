//
//  DominioTableViewCell.h
//  thesapp
//
//  Created by Paolo Burzacca on 18/06/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DominioTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titolo;
@property (nonatomic, strong) IBOutlet UILabel *descrizione;
@property (nonatomic, strong) IBOutlet UILabel *numero;
@end
