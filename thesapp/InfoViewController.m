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
@synthesize testo;

- (void)viewDidLoad {
    [super viewDidLoad];

    //[testo sizeThatFits:testo.bounds.size];
    
    //[testo sizeToFit];
    
    CGFloat fixedWidth = testo.frame.size.width;
    CGSize newSize = [testo sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = testo.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    testo.frame = newFrame;
    testo.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
