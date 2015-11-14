//
//  PopoverViewController.h
//  thesapp
//
//  Created by Paolo Burzacca on 14/11/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverMenuControls.h"

@interface PopoverViewController : UITableViewController
{
    NSArray *settings, *storyboardIDs;
}

@property (nonatomic, strong) id<PopoverMenuControls> delegato;
@end
