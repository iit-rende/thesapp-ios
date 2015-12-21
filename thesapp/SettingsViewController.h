//
//  SettingsViewController.h
//  thesapp
//
//  Created by Paolo Burzacca on 14/11/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "AppDelegate.h"

@interface SettingsViewController : UITableViewController
{
    NSIndexPath *lastSelectedIndexPath;
    NSArray *lingue, *locali;
    int lingua;
    AppDelegate *appDelegate;
}
@end