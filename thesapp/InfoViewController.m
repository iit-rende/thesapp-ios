//
//  InfoViewController.m
//  thesapp
//
//  Created by Paolo Burzacca on 19/06/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize testo, cnr, iit, labdoc;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.title = NSLocalizedString(@"THESAPP", @"titolo");
    
    CGFloat fixedWidth = testo.frame.size.width;
    CGSize newSize = [testo sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = testo.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    testo.frame = newFrame;
    testo.scrollEnabled = NO;
    
    UITapGestureRecognizer *cnrTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCNRLink)];
    
    [cnr addGestureRecognizer:cnrTap];
    
    
    UITapGestureRecognizer *iitTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openIITLink)];
    
    [iit addGestureRecognizer:iitTap];
    
    UITapGestureRecognizer *labdocTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openLabdocLink)];
    
    [labdoc addGestureRecognizer:labdocTap];
}

-(void) openCNRLink {
    
}

-(void) openIITLink {
    
}

-(void) openLabdocLink {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
