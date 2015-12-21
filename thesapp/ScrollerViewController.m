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
#define MULTIPLIER 1000

@implementation ScrollerViewController

@synthesize listaDomini;


#pragma mark - metodi del view controller

-(void) viewWillAppear:(BOOL)animated {

    NSLog(@"[viewWillAppear]");
    
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
    
    NSLog(@"[viewDidLoad]");
    
    //[self setNeedsStatusBarAppearanceUpdate]; non serve??
    //[self initView];
    //[self loadLayout]; //richiamato quando ruota
    
    [self initVars]; //indipendente
    [self initNavigationBar];  //indipendente
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

- (void)viewDidUnload {
    self.scrollView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - metodi notifiche push

-(void) onMessageReceived:(NSNotification *) notification {

    NSLog(@"[onMessageReceived]");
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];

    NSDictionary *dizionario = notification.userInfo;
    
    NSDictionary *aps = [dizionario objectForKey:@"aps"];
    NSDictionary *alert = [aps objectForKey:@"alert"];
    NSString *text = [alert objectForKey:@"body"];
    
    NSString *customNotification = [dizionario objectForKey:@"notification"];
    NSData *data = [customNotification dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    tempDomain = [json objectForKey:@"domain"];
    NSDictionary *localizations = [json objectForKey:@"localizations"];
    
    NSLog(@"localizations = %@", [localizations description]);
    
    if (state == UIApplicationStateActive) {
        
        NSString *cancelTitle = @"Accetta";  //TODO :localize
        NSString *showTitle = @"Rifiuta"; //TODO :localize
        
        NSString *message = [NSString stringWithFormat:@"\"%@\" \nDominio %@", text, tempDomain];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notifica ricevuta"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
        
    } else {
    
        [self reloadAfterNotification];
    }
    
}

-(void) reloadAfterNotification {
    
    NSLog(@"rreloadAfterNotification with %@", tempDomain);
    
    if (tempDomain == nil) return;
    
    Domain *dom = [Utils getDomainFromFile:tempDomain];
    
    if (dom != nil) {
        NSLog(@"Dominio locale trovato, scarico categorie dominio %@", dom.descriptor);
        [self getCategoriesByDomain:dom];
    }
    else {
        NSLog(@"Dominio locale non trovato, non faccio nulla");
    }
}

-(void) applicationReactivated {
}

#pragma mark - metodi delegati alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
    }
    else {
        [self reloadAfterNotification];
    }
}

#pragma mark - metodi di layout

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/* DEPRECATI
 
- (void) goBack {
}

-(void) loadLayout {
    
    //ci metto tutti i valori che dipendono dallo schermo
    
    /*
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        larghezza = screenWidth; // ceil(screenWidth * IPAD_SCREEN_SIZE);
        //padding = ((screenWidth - larghezza) / 2);
        larghezza = screenWidth - 2 * padding;
    }
    else {
        larghezza = screenWidth - 2 * padding;
    }
 

    NSLog(@"[ORIGNE] = %f", self.scrollView.frame.origin.x);
    NSLog(@"[LARGHEZZA] = %f", larghezza);
    NSLog(@"[PADDING] = %f", padding);
    */
    //uguale x tutti
    
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
//}

+ (InterfaceOrientationType)orientation{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize nativeSize = [UIScreen mainScreen].currentMode.size;
    CGSize sizeInPoints = [UIScreen mainScreen].bounds.size;
    
    InterfaceOrientationType result;
    
    if(scale * sizeInPoints.width == nativeSize.width){
        result = InterfaceOrientationTypePortrait;
    }else{
        result = InterfaceOrientationTypeLandscape;
    }
    
    return result;
}

-(void)viewDidLayoutSubviews {
    
    NSLog(@"viewDidLayoutSubviews");
    
    screenWidth = self.view.frame.size.width;
    larghezza = screenWidth - MARGIN;
    altezza = self.view.frame.size.height - MARGIN;
    
    [self prepareScrollView];
    
    BOOL curPortrait = ([ScrollerViewController orientation] == InterfaceOrientationTypePortrait);
    
    if (portrait != curPortrait) {
        
        NSLog(@"[ORIENTAMENTO] Cambiato");
        
        xOffset = 0;
        
        //xOffset = startIndex * screenWidth;
        
        int tot = 0;
        
        for (GenericScrollCard *vista in self.scrollView.subviews) {
            [[vista subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            
            
            /*
            if ([vista isKindOfClass:[DomainCard class]]) {
            
                NSLog(@"trovata DomainCard");
                vista.frame = [self makeCardFrame];
                [vista prepare];
                [vista render];                
                
            } else if ([vista isKindOfClass:[TermCard class]]) {
                NSLog(@"trovata TermCard");
                
                vista.frame = [self makeCardFrame];
                [vista prepare];
                [vista render];
            }
            else if  ([vista isKindOfClass:[DomainCategoryCard class]]) {
                NSLog(@"trovata DomainCategoryCard");
                
                vista.frame = [self makeCardFrame];
                [vista prepare];
                [vista render];
            }
            else if  ([vista isKindOfClass:[CategoryCard class]]) {
                NSLog(@"trovata CategoryCard");
                
                vista.frame = [self makeCardFrame];
                [vista prepare];
                [vista render];
            }
            */
            
            vista.frame = [self makeCardFrame];
            [vista prepare];
            [vista render];
            
            float CONTENT_SIZE_WIDTH = screenWidth + xOffset;
            //self.scrollView.contentSize = CGSizeMake(CONTENT_SIZE_WIDTH, CONTENT_SIZE_HEIGHT);
            [self updateContentSizeWithWidth:CONTENT_SIZE_WIDTH];
            
            vista.backgroundColor = [UIColor whiteColor];
            
            xOffset += screenWidth;
            tot++;
        }

        [self scrollToIndex:pageIndex];
    }
    else {
        NSLog(@"[ORIENTAMENTO] Non cambiato");
    }
    
    portrait = curPortrait;
}

#pragma mark - Init methods

/* DEPRECATO
-(void) initView {
    
    //self.topView.clipsToBounds = YES;
    //self.topView.layer.shadowOffset = CGSizeMake(0, 2);
    //self.topView.layer.shadowRadius =   4.0;
    //self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.topView.layer.shadowOpacity = 1.0;
    //self.topView.layer.masksToBounds = NO;
}
 */

-(void) prepareScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
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
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spacer.width = 20;
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:infoButton, spacer, historyButtonItem,spacer,  searchButton, nil];
}

-(void) initVars {
    padding = MARGIN / 2;
    screenWidth = self.view.frame.size.width;
    topPadding = MARGIN / 2;
    repo = [[Repository alloc] initWithProtocol:self];
    manager = [AFHTTPRequestOperationManager manager];
    cards = [[NSMutableDictionary alloc] init];
    parent = (MMDrawerController *) self.parentViewController.parentViewController;
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
        
        NSString *riferimento = [@"D_" stringByAppendingString:dominio.descriptor];
        
        NSLog(@"controllo se ho già scheda x rif = %@", riferimento);
       
        //rimuovo altre cards
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
                [self getCategoriesByDomain:dominio ];
            }
        }
    }
}

-(void) getCategoriesByDomain:(Domain *) dominio {
    
    NSLog(@"cerco cate per %@", [Global singleton].linguaInUso);
    
    [[Global singleton] setDominio:dominio];
    [self showHUDProgress:@"CATEGORIES_SEARCH"];
    BOOL esito = [repo getCategoriesByDomain:dominio forLanguage:[Global singleton].linguaInUso];
    
    if (esito) {
        NSLog(@"attendo");
        [self removeHUD]; //BOH
    }
    else {
        [self removeHUD];
    }
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

-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller
{
    return UIModalPresentationNone;
}

-(void) deleteHistory:(id)sender {
    
    NSLog(@"ci sono %d pagine", totPages);
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
        
        [side menuOpen:listaDomini];
    }];
}

#pragma mark - metodi per card

-(TermCard *) createTermCard {
    NSLog(@"createCard con altezza = %f", altezza);
    NSLog(@"e xOffset = %d", xOffset);
    TermCard *card = [[TermCard alloc] initWithFrame:[self makeCardFrame]];
    card.tag = numSchede * MULTIPLIER;
    return card;
}

-(CGRect) makeCardFrame {
    float xFrame = padding + xOffset;
    
    //xFrame = xOffset; //TEMP
    
    NSLog(@"xFrame = %f", xFrame);
    NSLog(@"xOffset = %d", xOffset);
    
    return CGRectMake(xFrame, topPadding, larghezza, altezza); //era padding + xOffset
}

#pragma mark - metodi rimozione card

-(void) removeMainCard {
    NSArray *subviews = [self.scrollView subviews];
    int totViews = (int) [subviews count];
    
    NSLog(@"ci sono %d subviews", totViews);
    if (totViews < 1) return;
    [[subviews objectAtIndex:0] removeFromSuperview];
    xOffset = 0;
    
    [cards removeAllObjects];
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
    
    float width = 5 + xOffset;
    
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
}

-(void) removeCard:(int) cardNum {

    NSLog(@"removeCard %d", cardNum);
    
    NSArray *subviews = [self.scrollView subviews];
    NSLog(@"ci sono %d subviews", (int) [subviews count]);
    
    UIView *vista = [subviews objectAtIndex:cardNum];
    
    int indice = (int) vista.tag;
    NSLog(@"vista con tag = %d", indice);
    
    int tot = (int) subviews.count;

    int index = indice / MULTIPLIER;
    
    for (int i = index; i < tot; i++) {
        NSLog(@"itero vista %d", i);
        UIView *view = [subviews objectAtIndex:i];
        CGRect rect = view.frame;
        rect.origin.x -= larghezza + 2*padding;
        view.frame = rect;
    }
    
    [vista removeFromSuperview];
}

-(void) addCardToStoryboard:(GenericScrollCard *) scheda forType:(CardType) cardtype {
    
    NSString *riferimento = [scheda getKey];
    
    if (riferimento == nil) return;
    
    NSLog(@"addCardToStoryboard, chiave = %@", riferimento);
    
    if (cards != nil) {
        int cardIndex = [[cards objectForKey:riferimento] intValue];
        
        NSLog(@"[Indice = %d]", cardIndex);
        
        if (cardIndex > 0) {
            NSLog(@"Trovata card con indice = %d", cardIndex);
            [self scrollToIndex:cardIndex];
        }
        else {
            totPages++;
            NSLog(@"[Card non trovata] Creo card Num %d", totPages);
            [cards setValue:[NSNumber numberWithInt:totPages-1] forKey:riferimento];
            [self insertCard:scheda];
            [self scrollToIndex:totPages - 1];
        }
    }
    
    [scheda becomeFirstResponder];
}

-(void) insertCard:(GenericScrollCard *) scheda {
    
    NSLog(@"prima di appendere width = %f",  self.scrollView.frame.size.width);
    
    NSLog(@"scheda width = %f",  scheda.frame.size.width);
    
    [self.scrollView addSubview:scheda];
    
    float X = scheda.frame.origin.x;
    
    NSLog(@"appesa X a  %f", X);
    
    float CONTENT_SIZE_WIDTH = screenWidth + xOffset;
    [self updateContentSizeWithWidth:CONTENT_SIZE_WIDTH];
    
    xOffset += screenWidth;
    scheda.controller = self;
}

-(void) updateContentSizeWithWidth:(float) width {
    
    NSLog(@"content size passa a %f", width);
    self.scrollView.contentSize = CGSizeMake(width, CONTENT_SIZE_HEIGHT);
}

#pragma mark - metodi di scroll

-(void) scrollLeft {
    if (pageIndex >= 1) {
        [self scrollToIndex:pageIndex-1];
    }
}

-(void) scrollToIndex:(int) indice {
    float offset = indice * screenWidth;
    [self scrollToPoint:CGPointMake(offset, 0)];
}

-(void) scrollRight {
    //[self scrollToPoint:CGPointMake(xOffset - screenWidth, 0)];
   [self scrollToIndex:pageIndex+1];
}

-(void) scrollToPoint:(CGPoint) punto {
    
    manuale = YES;
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.scrollView.contentOffset = punto;
        
        NSLog(@"x diventa %f", self.scrollView.contentOffset.x);
        
        pageIndex = punto.x / screenWidth;
        NSLog(@"PAGINA [1] = %d", pageIndex);
        
        if (pageIndex == 0) {
            backButtonItem.style = UIBarButtonItemStylePlain;
            backButtonItem.enabled = false;
            backButtonItem.title = nil;

            [[Global singleton] setDominio:nil];
        }
        else {
            
            if ([Global singleton].activeDomain == nil) {
                NSLog(@"recupero ultimo dominio");
                [[Global singleton] restoreLastDomain];
            }
            
            GenericScrollCard *card = self.scrollView.subviews[pageIndex];
            UIColor *cardDomainColor = [card getBarColor];
            
            if (cardDomainColor != nil) [self updateNavBarColor:cardDomainColor];            
            
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

#pragma mark - metodi delegati scroll view

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {

    NSLog(@"scrollViewWillEndDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {

    NSLog(@"scrollViewDidEndDragging");
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scrollViewShouldScrollToTop");
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScrollToTop");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"scrollViewDidEndDecelerating");
    
    scrollView.userInteractionEnabled = YES;

    if (manuale) {
        manuale = NO;
        NSLog(@"esco qui");
        //return;
    }
    
    float nuovaX = self.scrollView.contentOffset.x;
    
    //NSLog(@"nuovaX = %f", nuovaX);
    //NSLog(@"rapporto = %f", nuovaX / screenWidth);
    
    //pageIndex = nuovaX / screenWidth;
    int ratio = (int)lroundf(nuovaX / screenWidth);
    
    pageIndex = ratio;
    
    NSLog(@"PAGINA [2] = %d", pageIndex);
    
    GenericScrollCard *card = self.scrollView.subviews[pageIndex];
    NSLog(@"card = %@", [card description]);
    
    UIColor *cardDomainColor = [card getBarColor];
    
    if (pageIndex == 0) {
        //home

        [self updateNavBarColor:[Utils getDefaultColor]];
        
        [titleButton setTitle:NSLocalizedString(@"THESAPP", @"ThesApp")];
        
        [[Global singleton] setDominio:nil];
    }
    else {
        
        if ([Global singleton].activeDomain == nil) {
            [[Global singleton] restoreLastDomain];
        }
        
        if ([Global singleton].activeDomain != nil) {
            
            //TEMP
            //[self updateNavBarColor:[Utils colorFromHexString:[Global singleton].activeDomain.color]];
            
            if (cardDomainColor != nil) {
                NSLog(@"CAMBIO COLORE BARRA");
                [self updateNavBarColor:cardDomainColor];
            }
            else {
                NSLog(@"NON CAMBIO COLORE BARRA");
            }
        
             NSString *newTitle = [[NSLocalizedString(@"THESAPP", @"ThesApp") stringByAppendingString:@" - "] stringByAppendingString:[Global singleton].activeDomain.localization];
            
            [titleButton setTitle:newTitle];
        }
        
    }
}

#pragma mark - Card Controller methods

- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom inLanguage:(NSString *)lang {
    
    if (catName == nil) return;
    if (catName.length < 1) return;
    if (dom == nil) return;
    
    [self showHUDProgress:@"CATEGORY_SEARCH"];
    [repo getDomainCategory:catName fromDomain:dom forLanguage:lang];
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
    
    NSLog(@"getTerm con lingua %@", lang);
    
    NSString *rif = [@"T_" stringByAppendingString:term];
    
    if (cards != nil) {
        int cardIndex = [[cards objectForKey:rif] intValue];
        if (cardIndex > 0) {

            [self scrollToIndex:cardIndex];
        }
        else {
            //self.dominioScelto = [Global singleton].activeDomain;
            NSLog(@"Card non trovata, scarico. Dominio scelto = %@", [Global singleton].activeDomain.descriptor);
            //[self getSingleTerm:term withDomain:[Global singleton].activeDomain andLanguage:lang]; OLD
            
            [self showHUDProgress:@"TERM_SEARCH"];
            
            NSLog(@"leggo dominio scheda corrente");
            
            GenericScrollCard *card = self.scrollView.subviews[pageIndex];
            
            Domain *dominio;
            
            if (card != nil) {
                dominio = card.dominio;
                NSLog(@"dominio = %@", dominio.descriptor);
            }

            if (dominio.descriptor == nil) {
                dominio = [Global singleton].activeDomain;
            }
            
            [repo getSingleTerm:term withDomain:dominio andLanguage:lang];
        }
    }
}

#pragma mark - Repository delegate methods

-(void) singleTermReceived:(Term *) term {

    [self showSuccessHUD:@""];
    
    [self updateNavBarColor:[Utils colorFromHexString:term.domain.color]];
    
    TermCard *card = [self createTermCard];
    card = [term createTermCard:card];
    card.dominio = term.domain;
    [self addCardToStoryboard:card forType:TermTile];
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
    
    [self showSuccessHUD:@""];
    
    listaDomini = [[NSMutableArray alloc] initWithArray:domainlist];
    
    DomainCard *mainCard = [[DomainCard alloc] initWithFrame:[self makeCardFrame]]; //[DomainCard createWithDomain:dominio];
    
    mainCard.tag = numSchede * MULTIPLIER;
    mainCard.domini = [Utils ordinaByDescriptor:listaDomini];
    [mainCard render];
    
    [self addCardToStoryboard:mainCard forType:DomainTile];
}

-(void) domainNotReceived:(NSString *) error {
    
    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:error
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
    
    [self appendRetryButton];
}

-(void) domainCategoriesReceived:(NSArray *) categoriesList forDomain:(Domain *) dominio {
    
    [self showSuccessHUD:@""];
    
    DomainCategoryCard *card = [[DomainCategoryCard alloc] initWithFrame:[self makeCardFrame]];
    card.tag = numSchede * MULTIPLIER;
    card.categorie = categoriesList;
    card.dominio = dominio;
    [card render];
    [self addCardToStoryboard:card forType:DomainCategoryTile];
    
    UIColor *colore = [Utils colorFromHexString:card.dominio.color];
    [self updateNavBarColor:colore];
    
    NSString *newTitle = [[NSLocalizedString(@"THESAPP", @"ThesApp") stringByAppendingString:@" - "] stringByAppendingString:card.dominio.localization];
    
    [titleButton setTitle:newTitle];
}

-(void) updateNavBarColor:(UIColor *) colore {
    if (colore != nil) [self.navigationController.navigationBar setBarTintColor:colore];
}

-(void) domainCategoriesNotReceived:(NSString *) error {
    
    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:NSLocalizedString(error, @"categorie non trovate")
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
}

-(void) domainCategoryReceived:(Categoria *) category fromDomain:(Domain *) dominio {
    [self showSuccessHUD:@""];
    
    NSLog(@"domainCategoryReceived");
    
    CategoryCard *card = [category createCategoryCardWithFrame:[self makeCardFrame]];
    card.tag = numSchede * MULTIPLIER;
    card.dominio = dominio; //TEMP, nuovo
    [card render];
    [self addCardToStoryboard:card forType:CategoryTile];
}

-(void) domainCategoryNotReceived:(NSString *) error {
    [self removeHUD];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"attenzione")
                                                        message:NSLocalizedString(error, @"errore")
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

/*
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willRotateToInterfaceOrientation");
    //primo
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
   // [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"viewWillTransitionToSize");
    //secondo
}
*/

@end