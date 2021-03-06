//
//  GenericCard.m
//  ThesApp
//
//  Created by Paolo Burzacca on 20/05/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "GenericScrollCard.h"
#import "Utils.h"

#define PADDING_BTN 8
#define HEADER_HEIGHT 110
#define HEADER_BOTTOM_PADDING 15

#define TITOLI_FONT_SIZE 12.0f
#define TITLE_PADDING_BOTTOM 5
#define TITLE_PADDING_TOP 25
#define TITLE_PADDING_LEFT 10
#define TITLE_HEIGHT 20
#define TITLE_FONT_SIZE 30

@implementation GenericScrollCard

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}

-(id) init {
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

-(void) initVars {
    paddingLeft = TITLE_PADDING_LEFT;
    titleLabelHeight = TITLE_HEIGHT;
}

-(void) prepare {
    
     NSLog(@"[GenericScrollCard] prepare");
    
    [self initVars];
    
    //scroll view
    self.bouncesZoom = NO;
    self.bounces = NO;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = YES;
    self.delaysContentTouches = YES;
    self.canCancelContentTouches = YES;
    
    CGRect wrapperFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    wrapper = [[UIView alloc] initWithFrame:wrapperFrame];
    [self addSubview:wrapper];
     
    fullWidth = wrapper.frame.size.width;
    if (fullWidth < 1) fullWidth = [[UIScreen mainScreen] bounds].size.width;
    fullWithPadding = fullWidth; // - 2 * PADDING_BTN;

    float titleHeight = 35;
    float titleFontSize = TITLE_FONT_SIZE;
    
    //////////////////////////////////////////////////////////////
    //preparo scheda
    
    wrapper.backgroundColor = [UIColor whiteColor];
    wrapper.clipsToBounds = YES;
    wrapper.layer.cornerRadius = 3;
    
    self.layer.cornerRadius = 3;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 4.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    
    //////////////////////////////////////////////////////////////
    //disegno header
    CGRect headerFrame = CGRectMake(0, 0, fullWithPadding, HEADER_HEIGHT);
    header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [Utils getHeaderColor];
    [wrapper addSubview:header];
    
    //////////////////////////////////////////////////////////////
    
    /*
    //back button
    CGRect buttonFrame = CGRectMake(PADDING_BTN, PADDING_BTN, btnWidth, btnHeight);
    back = [[UIButton alloc] initWithFrame:buttonFrame];
    //back.backgroundColor = [UIColor clearColor];
    [back setTitle:@"<" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [header addSubview:back];
    */
    
    //////////////////////////////////////////////////////////////
    //title label
    float title_padding_top = PADDING_BTN + TITLE_PADDING_TOP;
    CGRect titleFrame = CGRectMake(PADDING_BTN, title_padding_top, fullWithPadding, titleHeight);
    titolo = [[TitoloLabel alloc] initWithFrame:titleFrame];
    titolo.backgroundColor = [UIColor clearColor];
    titolo.font = [titolo.font fontWithSize: titleFontSize];
    titolo.textColor = [UIColor whiteColor];
    titolo.numberOfLines = 0;
    [header addSubview:titolo];
}

-(void) addCardTitle:(NSString *) title {
    titolo.text = title;
    [titolo sizeToFit];
    [header sizeToFit];
}

-(float) getHeaderHeightAndPadding {
    return header.frame.origin.y + header.frame.size.height + HEADER_BOTTOM_PADDING;
}

-(NSString *) getName {
    return @"generico";
}

-(void) categoryClick:(Etichetta *) btn {
    NSLog(@"categoryClick su %@", self.dominio.descriptor);
    
    if (btn.testo == nil) {
        NSLog(@"testo nullo, esco");
        return;
    }
    if (btn.testo.length == 0) {
        NSLog(@"testo 0, esco");
        return;
    }
    
    NSLog(@"continuo..");
    
    [self.controller addCategoryCard:btn.testo withDomain:self.dominio];
}

-(void) openLocalizedTerm:(Etichetta *) btn {
    
    if (btn.testo == nil) {
        NSLog(@"testo nullo, esco");
        return;
    }
    if (btn.testo.length == 0) {
        NSLog(@"testo 0, esco");
        return;
    }
    
    NSString *value = btn.testo;
    NSString *lang =  (btn.lingua != nil) ? btn.lingua : lingua;
    NSLog(@"openLocalizedTerm: %@ in lingua %@", value, lang);
    [self.controller getTerm:value inLanguage:lang];
}

-(void) openTerm:(Etichetta *) btn {
    NSString *value = [btn titleLabel].text;
    NSLog(@"openTerm: %@", value);
    [self.controller getTerm:value inLanguage:lingua];
}

-(void) dietro:(UIButton *) btn {
    [self.controller goBack];
}

-(void) addSectionTitle:(NSString *) title {
    
    CGRect catTitleFrame = CGRectMake(paddingLeft, top, fullWithPadding - 2 * paddingLeft, titleLabelHeight);
    UILabel *catTitle = [[UILabel alloc] initWithFrame:catTitleFrame];
    catTitle.textColor = [UIColor darkGrayColor];
    catTitle.font = [catTitle.font fontWithSize:TITOLI_FONT_SIZE];
    NSString *tradotto = NSLocalizedString(title, @"");
    catTitle.text = (tradotto != nil) ? tradotto : title;
    [wrapper addSubview:catTitle];
    top += titleLabelHeight + TITLE_PADDING_BOTTOM;
}

@end
