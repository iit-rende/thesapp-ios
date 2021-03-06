//
//  GenericCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "GenericCard.h"

#define PADDING_BTN 8
#define HEADER_HEIGHT 150
#define HEADER_BOTTOM_PADDING 15

#define TITOLI_FONT_SIZE 13.0f
#define TITLE_PADDING_BOTTOM 10
#define TITLE_PADDING_TOP 25

@implementation GenericCard

-(id) init {
    NSLog(@"[GenericCard] init");
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

-(void) initVars {
    btnHeight = 30;
    paddingLeft = 10;
    titleLabelHeight = 20;
}

-(void) prepare {
    
    NSLog(@"[GenericCard] prepare");
    
    self.clipsToBounds = YES;
    
    [self initVars];
    
    fullWidth = self.frame.size.width;
    if (fullWidth < 1) fullWidth = [[UIScreen mainScreen] bounds].size.width;
    fullWithPadding = fullWidth - 2 * PADDING_BTN;
    
    float titleHeight = 30;
    float btnWidth = 30;
    float titleFontSize = 30.0f;
    
    //////////////////////////////////////////////////////////////
    //preparo scheda
    
    self.backgroundColor = [UIColor redColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 4.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    
    //////////////////////////////////////////////////////////////
    //disegno header
    CGRect headerFrame = CGRectMake(0, 0, fullWithPadding, HEADER_HEIGHT);
    header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:header];
    
    //////////////////////////////////////////////////////////////
    //back button
    CGRect buttonFrame = CGRectMake(PADDING_BTN, PADDING_BTN, btnWidth, btnHeight);
    back = [[UIButton alloc] initWithFrame:buttonFrame];
    //back.backgroundColor = [UIColor clearColor];
    [back setTitle:@"<" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [header addSubview:back];
    
    //////////////////////////////////////////////////////////////
    //title label
    float title_padding_top = PADDING_BTN + btnHeight + TITLE_PADDING_TOP;
    CGRect titleFrame = CGRectMake(PADDING_BTN, title_padding_top, fullWithPadding, titleHeight);
    titolo = [[UILabel alloc] initWithFrame:titleFrame];
    titolo.backgroundColor = [UIColor clearColor];
    titolo.font = [titolo.font fontWithSize: titleFontSize];
    titolo.textColor = [UIColor whiteColor];
    titolo.numberOfLines = 0;
    [header addSubview:titolo];
}

-(float) getHeaderHeightAndPadding {
    return header.frame.origin.y + header.frame.size.height + HEADER_BOTTOM_PADDING;
}

-(NSString *) getName {
    return @"generico";
}

-(void) categoryClick:(Etichetta *) btn {
    NSLog(@"categoryClick");
    NSString *value = [btn titleLabel].text;
    [self.controller addCategoryCard:value withDomain:self.dominio];
}

-(void) openTerm:(Etichetta *) btn {
    NSString *value = [btn titleLabel].text;
    NSLog(@"openTerm: %@", value);
    [self.controller getTerm:value inLanguage:@"it"]; //TODO
}

-(void) dietro:(UIButton *) btn {
    NSLog(@"dietro");
    [self.controller goBack];
}

-(void) addSectionTitle:(NSString *) title {
    
    CGRect catTitleFrame = CGRectMake(paddingLeft, top, fullWithPadding, titleLabelHeight);
    UILabel *catTitle = [[UILabel alloc] initWithFrame:catTitleFrame];
    catTitle.textColor = [UIColor darkGrayColor];
    catTitle.font = [catTitle.font fontWithSize:TITOLI_FONT_SIZE];
    NSString *tradotto = NSLocalizedString(title, @"");
    catTitle.text = (tradotto != nil) ? tradotto : title;
    [self addSubview:catTitle];
    
    top += titleLabelHeight + TITLE_PADDING_BOTTOM;
}

@end
