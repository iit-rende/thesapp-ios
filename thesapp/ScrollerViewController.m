//
//  ScrollerViewController.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 12/05/15.
//

#import "InfoViewController.h"
#import "ScrollerViewController.h"
#import "Utils.h"
#import "SideMenuTableViewController.h"

#define STARTING_CARD_NUM 1
#define CONTENT_SIZE_HEIGHT 300
#define BAR_BUTTON_SIZE 23
#define LOADER_SIZE 37
#define LABEL_HEIGHT 22
#define MARGIN 20
#define IPAD_SCREEN_SIZE 0.85

@implementation ScrollerViewController

@synthesize listaDomini ; //, dominioScelto;

-(void) viewWillAppear:(BOOL)animated {

    NSLog(@"lingua in uso = %@", [Global singleton].linguaInUso);
    NSString *nuova = [Utils getCurrentLanguage];
    
    NSLog(@"rileggo la lingua, nuova = %@", nuova);
    
    if (![nuova isEqualToString:[Global singleton].linguaInUso]) {

        NSLog(@"[LINGUA] lingua cambiata in %@", nuova);
        
        [Global singleton].linguaInUso = nuova;
        
        [self removeCards:YES];
        [self resetVars];
        [self removeMainCard];
        [self getDomains];
    }
}

-(void) viewDidAppear:(BOOL)animated {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delaysContentTouches = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [self initVars];
    [self initNavigationBar];
    [self initObjects];
    [self initView];
    [self loadLayout];
    
    [self getDomains];
    
    /*
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationReactivated)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
     */
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(onMessageReceived:)
                                                name:@"onMessageReceived"
                                              object:nil];
}

-(void) onMessageReceived:(NSNotification *) notification {

    NSLog(@"onMessageReceived");
    NSDictionary *dizionario = notification.userInfo;
    NSString *customNotification = [dizionario objectForKey:@"notification"];
    NSData *data = [customNotification dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *domain = [json objectForKey:@"domain"];
    Domain *dom = [Utils getDomainFromFile:domain];
    
    if (dom != nil) {
        NSLog(@"domnio locale trovato, scarico categorie dominio");
        [self getCategoriesByDomain:dom];
    }
    else {
        NSLog(@"Dominio locale non trovato, non faccio nulla");
    }
    
    // CONTROLLO LINGUA
    [self removeCards:YES];
    [self resetVars];
    [self getDomains];
}

-(void) applicationReactivated {
}

- (void)viewDidUnload {
    self.scrollView = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) goBack {
}

-(void) loadLayout {
    
    //ci metto tutti i valori che dipendono dallo schermo
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        larghezza = screenWidth; // ceil(screenWidth * IPAD_SCREEN_SIZE);
        padding = ((screenWidth - larghezza) / 2);
    }
    else {
        padding = MARGIN / 2;
        larghezza = screenWidth - 2 * padding;
    }
    
    //uguale x tutti
    altezza = self.view.frame.size.height - 2 * padding;
    
    scrollWidth = screenWidth;
    
   // for (UIView *vista in self.scrollView.subviews) {
        
        //TODO: non funziona
        
        /*
        float oldWidth = vista.frame.size.width;
        float oldHeight = vista.frame.size.height;
        //inverto altezza e larghezza
        //CGRect nuovoFrame = CGRectMake(vista.frame.origin.x, vista.frame.origin.y, oldWidth, oldHeight);
        CGRect nuovoFrame = CGRectMake(vista.frame.origin.y, vista.frame.origin.x, 50, 50);
        NSLog(@"vista = %@", [vista description]);
        NSLog(@"width = %f", nuovoFrame.size.width);
        NSLog(@"height = %f", nuovoFrame.size.height);
        vista.frame = nuovoFrame;
         */
        
   // }
}

-(void)viewDidLayoutSubviews {

    BOOL curPortrait;
    
    if(screenWidth > self.view.frame.size.height) {
        //landscape
        curPortrait = NO;
    }
    else {
        //portrait
        curPortrait = YES;
    }
    
    if (curPortrait != portrait) {
        screenWidth = self.view.frame.size.width;
        [self loadLayout];
    }
    
    portrait = curPortrait;
}

#pragma mark - Init methods

-(void) initView {
    
    self.topView.clipsToBounds = YES;
    //self.topView.layer.shadowOffset = CGSizeMake(0, 2);
    //self.topView.layer.shadowRadius =   4.0;
    //self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.topView.layer.shadowOpacity = 1.0;
    //self.topView.layer.masksToBounds = NO;
    //self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
    
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    //[self.scrollView setContentSize:CGSizeMake(2000, self.view.frame.size.height)];
}

-(void) initNavigationBar {
    
    [self updateNavBarColor:[Utils getDefaultColor]];
    
    backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevCard:)];
    
    //titleButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"THESAPP", @"app title") style:UIBarButtonItemStylePlain target:self action:nil];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    lbl.text = NSLocalizedString(@"THESAPP", @"app title");
    lbl.textColor = [UIColor whiteColor];
    titleButton = [[UIBarButtonItem alloc] initWithCustomView:lbl];
    
    self.navigationItem.leftBarButtonItem = titleButton;
    
    UIBarButtonItem *searchButton         = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                             target:self
                                             action:@selector(openSearchMenu:)];
    
    UIView* historyButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)];
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    historyButton.backgroundColor = [UIColor clearColor];
    historyButton.frame = historyButtonView.frame;
    [historyButton setImage:[UIImage imageNamed:@"clock_icon"] forState:UIControlStateNormal];
    historyButton.autoresizesSubviews = YES;
    historyButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [historyButton addTarget:self action:@selector(deleteHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyButtonView addSubview:historyButton];
    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc]initWithCustomView:historyButtonView];
    
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    leftButton.autoresizesSubviews = YES;
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [leftButton addTarget:self action:@selector(openInfoPage:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    UIBarButtonItem* infoButton = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:infoButton, historyButtonItem, searchButton, nil];
}

-(void) initObjects {
    manager = [AFHTTPRequestOperationManager manager];
    cards = [[NSMutableDictionary alloc] init];
    parent = (MMDrawerController *) self.parentViewController.parentViewController;
}

-(void) initVars {
    screenWidth = self.view.frame.size.width;
    topPadding = MARGIN / 2;
    repo = [[Repository alloc] initWithProtocol:self];
    [self resetVars];
}

-(void) resetVars {
    pageIndex = 0; //pagina corrente
    totPages = 0;
    xOffset = 0;
    numSchede = 0;
}

-(void) appendRetryButton {
    
    NSString *downloadMsg = NSLocalizedString(@"DOWNLOAD_DOMAINS", @"scaricamento domini");
    
    downloadMsg = NSLocalizedString(@"RETRY", @"riprova");
    
    float top = (self.view.frame.size.height - 66) / 2 - LABEL_HEIGHT;
    float width = screenWidth - 2 * MARGIN;
    
    retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN, top, width, LABEL_HEIGHT)];
    [retryBtn setTintColor:[UIColor darkGrayColor]];
    [retryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [retryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [retryBtn setTitle:downloadMsg forState:UIControlStateNormal];
    [retryBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    
    [retryBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retryBtn];
}

-(void) removeRetryButton {
    [retryBtn removeFromSuperview];
}

-(void) reload {
    [self removeRetryButton];
    [self getDomains];
}

-(void) getDomains {
    listaDomini = nil;
    
    [self showHUDProgress:@"DOMAIN_SEARCH"];
    [repo getDomainsForLanguage:[Global singleton].linguaInUso];
}

// DEPRECATO
-(void) initDomainLoader {
    NSString *downloadMsg = NSLocalizedString(@"DOWNLOAD_DOMAINS", @"scaricamento domini");
    
    float top = (self.view.frame.size.height - 66) / 2 - LABEL_HEIGHT - LOADER_SIZE;
    float width = screenWidth - 2 * MARGIN;
    
    dwnLbl = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, top, width, LABEL_HEIGHT)];
    dwnLbl.text = downloadMsg;
    dwnLbl.textAlignment = NSTextAlignmentCenter;
    dwnLbl.textColor = [UIColor darkGrayColor];
    [dwnLbl setFont:[UIFont systemFontOfSize:16.f]];
    
    float metaY = top + LOADER_SIZE;
    float metaX = width / 2;
    
    loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(metaX, metaY, LOADER_SIZE, LOADER_SIZE)];
    [loader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loader setTintColor:[UIColor darkGrayColor]];
    [loader setColor:[UIColor darkGrayColor]];
    loader.hidesWhenStopped = YES;
    [self.view addSubview:loader];
    [loader startAnimating];
    [self.view addSubview:dwnLbl];
}

// DEPRECATO
-(void) removeDomainLoader {
    NSLog(@"removeDomainLoader");
    [dwnLbl removeFromSuperview];
    [loader removeFromSuperview];
}

#pragma mark - Download methods

-(void) getDominio:(Domain *)dominio {

    if (dominio != nil) {
        
        [[Global singleton] setDominio:dominio];
        
        //self.dominioScelto = dominio; //NUOVO
        
        NSLog(@"dominio scelto = %@", [Global singleton].activeDomain.descriptor);
        
        //controllo se già esiste, altrimenti scarico
        
        NSString *riferimento = dominio.descriptor;
        
        NSLog(@"controllo se ho già scheda x rif = %@", riferimento);
       
        //rimuovo altre cards
        NSLog(@"controllo se cancellare altre cards...");
        //DEVO FARLO SOLO SE STO CAMBIANDO E NON E' PRIMO AVVIO
        [self removeCards:YES];
        
        if (cards != nil) {
            int cardIndex = [[cards objectForKey:riferimento] intValue];
            if (cardIndex > 0) {
                NSLog(@"[2] Trovata card con indice = %d", cardIndex);
                [self scrollToIndex:cardIndex];
            }
            else {
                //pageIndex++;
                NSLog(@"non c'è, scarico dominio");
                [self getCategoriesByDomain:dominio ];
            }
        }
    }
}

-(void) getCategoriesByDomain:(Domain *) dominio {
    
    [[Global singleton] setDominio:dominio];
    [self showHUDProgress:@"CATEGORIES_SEARCH"];
    [repo getCategoriesByDomain:dominio forLanguage:[Global singleton].linguaInUso];
}

- (void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio {
    [self showHUDProgress:@"CATEGORIES_SEARCH"];
    [repo getDomainCategory:categoria fromDomain:dominio forLanguage:[Global singleton].linguaInUso];
}

-(void) openInfoPage:(id) sender {
    
    /*
    UIStoryboard * st =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *infoVCsid = @"infoVCsid";
    InfoViewController *infoVC = (InfoViewController *) [st instantiateViewControllerWithIdentifier:infoVCsid];
    if (infoVC != nil) [self.navigationController pushViewController:infoVC animated:YES];
     */
    
    PopoverViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverView"];
    
    controller.delegato = self;
    
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popover = controller.popoverPresentationController;
    
    controller.preferredContentSize = CGSizeMake(150, 100);
    
    popover.delegate = self;
    popover.sourceView = self.view;
    popover.sourceRect = CGRectMake(self.view.frame.size.width - 50, 10, 0, 0);
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void) closeMenuWithSID:(NSString *)sid {
    NSLog(@"sid = %@", sid);
    
    UIStoryboard * st =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *infoVC = (UIViewController *) [st instantiateViewControllerWithIdentifier:sid];
    
    if (infoVC != nil) [self.navigationController pushViewController:infoVC animated:YES];
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {

    NSLog(@"DIMESSO 1");
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {

    NSLog(@"DIMESSO");
    
}

-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller
{
    return UIModalPresentationNone;
}

-(void) deleteHistory:(id)sender {
    
    NSLog(@"ci sono %d pagine", totPages);
    NSLog(@"itero");
    
    int indice = 0;
    
    for (UIView *vista in self.scrollView.subviews) {
        float x = vista.frame.origin.x;
        float width = vista.frame.size.width;
        NSLog(@"pagina %d ha X = %f e width = %f", indice, x, width);
        indice++;
    }
    
    [self removeCards:NO];
}

-(void) openSearchMenu:(id)sender {
    
    if (listaDomini == nil || listaDomini.count == 0) return;
    
    [parent openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        SideMenuTableViewController *side = (SideMenuTableViewController *) parent.rightDrawerViewController;

        NSLog(@"PAOLO - apro menu con lista di %d domini", listaDomini.count);
        
        [side menuOpen:listaDomini];
    }];
}

-(TermCard *) createTermCard {
    NSLog(@"createCard con altezza = %f", altezza);
    NSLog(@"e xOffset = %d", xOffset);
    TermCard *card = [[TermCard alloc] initWithFrame:[self makeCardFrame]];
    card.tag = numSchede * 1000;
    return card;
}

-(CGRect) makeCardFrame {
    float xFrame = padding + xOffset;
    
    NSLog(@"xFrame = %f", xFrame);
    NSLog(@"xOffset = %d", xOffset);
    
    return CGRectMake(xFrame, topPadding, larghezza, altezza); //era padding + xOffset
}

-(void) removeMainCard {
    NSArray *subviews = [self.scrollView subviews];
    int totViews = (int) [subviews count];
    
    NSLog(@"ci sono %d subviews", totViews);
    if (totViews < 1) return;
    [[subviews objectAtIndex:0] removeFromSuperview];
    xOffset = 0;
    
    NSLog(@"Cards = %@", [cards description]);
    [cards removeAllObjects];
    NSLog(@"Cards = %@", [cards description]);
    totPages = 0;
    pageIndex = 0;
}

-(void) removeCards:(BOOL) all {
    
    NSArray *subviews = [self.scrollView subviews];
    int totViews = (int) [subviews count];
    
    NSLog(@"ci sono %d subviews", totViews);
    
    if (totViews < 2) {
        NSLog(@"esco...");
        return;
    }
    
    int startIndex = (all) ? 1 : 2;
    
    for (int i = startIndex; i < totViews; i++) {
        [[subviews objectAtIndex:i] removeFromSuperview];
        NSLog(@"cancellato view %d", i);
    }
    
    NSLog(@"ora ci sono %d subviews", (int) [[self.scrollView subviews] count]);
    
    [self scrollToIndex:(startIndex - 1)];
    
    xOffset = startIndex * screenWidth;
    
    //NSLog(@"QUI");
    //NSLog(@"scrollWidth = %f", scrollWidth);
    //NSLog(@"screenWidth = %f",screenWidth);
    
    float width = 5 + xOffset; //scrollWidth * startIndex;
    
    [self updateContentSizeWithWidth:width];
    
    NSLog(@"prima] cards = %@", [cards description]);
    
    NSMutableArray *removeKeys = [[NSMutableArray alloc] init];
    
    for (NSString *key in cards) {
        int value = [[cards objectForKey:key] intValue];
        if (value > 0) [removeKeys addObject:key];
    }
    
    NSLog(@"rimuovo %@", [removeKeys description]);
    
    for (NSString *chiave in removeKeys) {
        [cards removeObjectForKey:chiave];
    }
    
    totPages = startIndex;
    pageIndex = startIndex - 1;
    
    //lingua = defaultLanguage;
    
    NSLog(@"dopo] cards = %@", [cards description]);
}

-(void) removeCard:(int) cardNum {

    NSLog(@"removeCard %d", cardNum);
    
    NSArray *subviews = [self.scrollView subviews];
    NSLog(@"ci sono %d subviews", (int) [subviews count]);
    
    UIView *vista = [subviews objectAtIndex:cardNum];
    
    int indice = (int) vista.tag;
    NSLog(@"vista con tag = %d", indice);
    
    int tot = (int) subviews.count;

    int index = indice / 1000;
    
    for (int i = index; i < tot; i++) {
        NSLog(@"itero vista %d", i);
        UIView *view = [subviews objectAtIndex:i];
        CGRect rect = view.frame;
        rect.origin.x -= larghezza + 2*padding;
        view.frame = rect;
    }
    
    [vista removeFromSuperview];
}

-(void) addCardToStoryboard:(GenericScrollCard *) scheda {
    
    NSString *riferimento = [scheda getName];
    
    if (riferimento == nil) return;
    
    NSLog(@"addCardToStoryboard rif = %@", riferimento);
    
    if (cards != nil) {
        int cardIndex = [[cards objectForKey:riferimento] intValue];
        
        NSLog(@"[Indice = %d]", cardIndex);
        
        if (cardIndex > 0) {
            NSLog(@"Trovata card con indice = %d", cardIndex);
            [self scrollToIndex:cardIndex];
        }
        else {
            //pageIndex++;
            totPages++;
            NSLog(@"[Card non trovata] Creo card Num %d", totPages);
            [cards setValue:[NSNumber numberWithInt:totPages-1] forKey:riferimento];
            [self insertCard:scheda];
            [self scrollToIndex:totPages - 1];
        }
    }
}

-(void) updateContentSizeWithWidth:(float) width {
    
    NSLog(@"content size passa a %f", width);
    self.scrollView.contentSize = CGSizeMake(width, CONTENT_SIZE_HEIGHT);
}

-(void) insertCard:(GenericScrollCard *) scheda {
    
    [self.scrollView addSubview:scheda];
    
    float X = scheda.frame.origin.x;
    
    NSLog(@"appesa X a  %f", X);
    
    float CONTENT_SIZE_WIDTH = scrollWidth + xOffset;
    [self updateContentSizeWithWidth:CONTENT_SIZE_WIDTH];
    
    xOffset += screenWidth; //aumento offset
    scheda.controller = self;
}

-(void) scrollLeft {
    if (pageIndex >= 1) {
        [self scrollToIndex:pageIndex-1];
    }
}

-(void) scrollToIndex:(int) indice {
    float offset = indice * scrollWidth;
    //NSLog(@"vado a offset = %f", offset);
    [self scrollToPoint:CGPointMake(offset, 0)];
}

-(void) scrollRight {
    //[self scrollToPoint:CGPointMake(xOffset - scrollWidth, 0)];
   [self scrollToIndex:pageIndex+1];
}

-(void) scrollToPoint:(CGPoint) punto {
    
    manuale = YES;
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.scrollView.contentOffset = punto;
        
        NSLog(@"x diventa %f", self.scrollView.contentOffset.x);
        
        pageIndex = punto.x / scrollWidth;
        NSLog(@"PAGINA [1] = %d", pageIndex);
        
        if (pageIndex == 0) {
            backButtonItem.style = UIBarButtonItemStylePlain;
            backButtonItem.enabled = false;
            backButtonItem.title = nil;

            NSLog(@"torno a pagina iniziale, tolgo dominio");
            
            [[Global singleton] setDominio:nil];
        }
        else {
            
            if ([Global singleton].activeDomain == nil) {
                NSLog(@"recupero ultimo dominio");
                [[Global singleton] restoreLastDomain];
            }
            
            backButtonItem.style = UIBarButtonItemStylePlain;
            backButtonItem.enabled = true;
            UIImage *img = [UIImage imageNamed:@"left_arrow_white"];
            backButtonItem.image = img;
            
            //UIImage *backButtonImage = [UIImage imageNamed:@"left_arrow_white"];
            //CGRect frameimg = CGRectMake(0, 0, 24, 24);
            //UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
            //[someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
            //[backButtonItem setCustomView:someButton];
        }
        
    } completion:NULL];
}

-(void) goToPrevCard:(UIBarButtonItem *) item {
    [self scrollLeft];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    scrollView.userInteractionEnabled = YES;

    if (manuale) {
        manuale = NO;
        return;
    }
    
    float nuovaX = self.scrollView.contentOffset.x;
    
    //NSLog(@"nuovaX = %f", nuovaX);
    //NSLog(@"rapporto = %f", nuovaX / scrollWidth);
    
    //pageIndex = nuovaX / scrollWidth;
    int ratio = lroundf(nuovaX / scrollWidth);
    
    pageIndex = ratio;
    
    NSLog(@"PAGINA [2] = %d", pageIndex);
    
    if (pageIndex == 0) {
        //home
        

        [self updateNavBarColor:[Utils getDefaultColor]];
        
        NSString *newTitle = NSLocalizedString(@"THESAPP", @"ThesApp");
        [titleButton setTitle:newTitle];
        
        NSLog(@"torno a pagina iniziale, tolgo dominio");
        
        [[Global singleton] setDominio:nil];
    }
    else {
        
        if ([Global singleton].activeDomain == nil) {
            //NSLog(@"recupero ultimo dominio");
            [[Global singleton] restoreLastDomain];
        }
        
        if ([Global singleton].activeDomain != nil) {
            
            [self updateNavBarColor:[Utils colorFromHexString:[Global singleton].activeDomain.color]];
            
             NSString *newTitle = [[NSLocalizedString(@"THESAPP", @"ThesApp") stringByAppendingString:@" - "] stringByAppendingString:[Global singleton].activeDomain.localization];
            
            [titleButton setTitle:newTitle];
        }
        
    }
}

-(void) addCard:(UIButton *) btn {
    TermCard *card = [self createTermCard];
    [self addCardToStoryboard:card];
}

-(void) clicca:(UIButton *) btn {
    [self addCard:btn];
}

#pragma mark - Card Controller methods

- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom {
    
    if (catName == nil) {
        NSLog(@"Nome categoria nullo");
    }
    
    if (catName.length < 1) {
        NSLog(@"Nome categoria non valido");
    }
    
    if (dom == nil) {
        NSLog(@"Dominio non impostato");
    }
    
    [self showHUDProgress:@"CATEGORY_SEARCH"];
    [repo getDomainCategory:catName fromDomain:dom forLanguage:[Global singleton].linguaInUso];
}

#pragma mark - other methods

/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int pageWidth = 160;
    int pageX = pageIndex*pageWidth-scrollView.contentInset.left;
    if (targetContentOffset->x<pageX) {
        if (pageIndex>0) {
            pageIndex--;
        }
    }
    else if(targetContentOffset->x>pageX){
        if (pageIndex<3) {
            pageIndex++;
        }
    }
    targetContentOffset->x = pageIndex*pageWidth-scrollView.contentInset.left;
    NSLog(@"%d %d", pageIndex, (int)targetContentOffset->x);
}
*/

-(void) getTerm:(NSString *)term inLanguage:(NSString *)lang {
    
    //NSLog(@"[SVC] get Term, controllo se %@ esiste", term);
    
    if (cards != nil) {
        int cardIndex = [[cards objectForKey:term] intValue];
        if (cardIndex > 0) {

            [self scrollToIndex:cardIndex];
        }
        else {
            //self.dominioScelto = [Global singleton].activeDomain;
            NSLog(@"Card non trovata, scarico, dominio scelto = %@", [Global singleton].activeDomain.descriptor);
            //[self getSingleTerm:term withDomain:[Global singleton].activeDomain andLanguage:lang]; OLD
            
            [self showHUDProgress:@"TERM_SEARCH"];
            [repo getSingleTerm:term withDomain:[Global singleton].activeDomain andLanguage:lang];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Repository delegate methods

-(void) singleTermReceived:(Term *) term {
    NSLog(@"singleTermReceived");
    
    [self showSuccessHUD:@""];
    
    UIColor *colore = [Utils colorFromHexString:term.domain.color];
    [self updateNavBarColor:colore];
    
    TermCard *card = [self createTermCard];
    card = [term createTermCard:card];
    [self addCardToStoryboard:card];
}

-(void) singleTermNotReceived:(NSString *) error {
    
    NSLog(@"singleTermNotReceived");

    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:NSLocalizedString(@"NO_TERM_FOUND", @"termine non trovato")
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
}

-(void) domainReceived:(NSArray *) domainlist {
    
    NSLog(@"[domainReceived]");
    
    [self showSuccessHUD:@""];
    
    listaDomini = [[NSMutableArray alloc] initWithArray:domainlist];
    
    DomainCard *mainCard = [[DomainCard alloc] initWithFrame:[self makeCardFrame]]; //[DomainCard createWithDomain:dominio];
    
    mainCard.tag = numSchede * 1000;
    mainCard.domini = [Utils ordinaByDescriptor:listaDomini];
    [mainCard render];
    
    //[self removeDomainLoader];
    [self addCardToStoryboard:mainCard];
}

-(void) domainNotReceived:(NSString *) error {
    NSLog(@"domainNotReceived");
    
    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:error
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
    
    [self appendRetryButton];
}

-(void) domainCategoriesReceived:(NSArray *) categoriesList forDomain:(Domain *) dominio {
    
    NSLog(@"domainCategoriesReceived");
    
    [self showSuccessHUD:@""];
    
    //creo card
    DomainCategoryCard *card = [[DomainCategoryCard alloc] initWithFrame:[self makeCardFrame]];
    card.tag = numSchede * 1000;
    card.categorie = categoriesList;
    card.dominio = dominio;
    [card render];
    [self addCardToStoryboard:card];
    
    UIColor *colore = [Utils colorFromHexString:card.dominio.color];
    [self updateNavBarColor:colore];
    
    NSString *newTitle = [[NSLocalizedString(@"THESAPP", @"ThesApp") stringByAppendingString:@" - "] stringByAppendingString:card.dominio.localization];
    
    [titleButton setTitle:newTitle];
}

-(void) updateNavBarColor:(UIColor *) colore {
    if (colore != nil)
    [self.navigationController.navigationBar setBarTintColor:colore];
}

-(void) domainCategoriesNotReceived:(NSString *) error {
    
    NSLog(@"domainCategoriesNotReceived");
    
    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:NSLocalizedString(error, @"categorie non trovate")
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
}

-(void) domainCategoryReceived:(Categoria *) category fromDomain:(Domain *) dominio {
    NSLog(@"domainCategoryReceived");
    
    [self showSuccessHUD:@""];
    
    CategoryCard *card = [category createCategoryCardWithFrame:[self makeCardFrame]];
    card.tag = numSchede * 1000;
    [card render];
    [self addCardToStoryboard:card];
}

-(void) domainCategoryNotReceived:(NSString *) error {
    
    NSLog(@"domainCategoryNotReceived");
    
    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:error
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
}

#pragma mark - HUD methods

-(void) showHUDProgress:(NSString *) stringa {
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(stringa, @"avviso");
    HUD.mode = MBProgressHUDModeIndeterminate;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void) removeHUD {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUD hide:YES];
}

-(void) showSuccessHUD:(NSString *) testo {
    HUD.labelText = testo;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:0.1];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
    HUD = nil;
}

@end