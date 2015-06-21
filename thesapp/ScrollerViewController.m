//
//  ScrollerViewController.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 12/05/15.
//
//

#import "InfoViewController.h"
#import "ScrollerViewController.h"
#import "Utils.h"
#import "SideMenuTableViewController.h"

#define STARTING_CARD_NUM 1
#define CONTENT_SIZE_HEIGHT 300

@interface ScrollerViewController ()

@end

@implementation ScrollerViewController
@synthesize listaDomini, dominioScelto;

-(void) didRotateFromInterfaceOrientation {
    NSLog(@"didRotateFromInterfaceOrientation");
}

-(void) reloadLayout {
    NSLog(@"ricarico layout");
    //ci metto tutti i valori che dipendono dallo schermo
    larghezza = self.view.frame.size.width - 2 * padding;
    altezza = self.view.frame.size.height - 2 * padding; // - 60;
    scrollWidth = self.view.frame.size.width;
    
    for (UIView *vista in self.scrollView.subviews) {
        NSLog(@"ricreo vista");
        
        float oldWidth = vista.frame.size.width;
        float oldHeight = vista.frame.size.height;
        //inverto altezza e larghezza
        //CGRect nuovoFrame = CGRectMake(vista.frame.origin.x, vista.frame.origin.y, oldWidth, oldHeight);
        CGRect nuovoFrame = CGRectMake(vista.frame.origin.y, vista.frame.origin.x, 50, 50);
        NSLog(@"vista = %@", [vista description]);
        NSLog(@"width = %f", nuovoFrame.size.width);
        NSLog(@"height = %f", nuovoFrame.size.height);
        vista.frame = nuovoFrame;
        //[vista layoutIfNeeded];
    }
}

-(void)viewDidLayoutSubviews {
    //NSLog(@"[SVC] viewDidLayoutSubviews");
    
    BOOL curPortrait;
    
    if(self.view.frame.size.width > self.view.frame.size.height) {
        //NSLog(@"Landscape");
        curPortrait = NO;
    }
    else {
        //NSLog(@"Portrait");
        curPortrait = YES;
    }
    
    if (curPortrait != portrait) {
        NSLog(@"RUOTATO");
        [self reloadLayout];
    }
    
    portrait = curPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    lingua = [Utils getCurrentLanguage];
    
    pageIndex = 0; //pagina corrente
    totPages = 0;
    
    self.navigationController.navigationBar.barTintColor = [Utils getDefaultColor]; 
    
    backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevCard:)];
    
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"ThesApp" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.leftBarButtonItem = start;

    
    UIBarButtonItem *searchButton         = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                             target:self
                                             action:@selector(openSearchMenu:)];
    
    /*UIBarButtonItem *infoButton          = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                            target:self action:@selector(openInfoPage:)];
    */

    UIView* historyButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    historyButton.backgroundColor = [UIColor clearColor];
    historyButton.frame = historyButtonView.frame;
    [historyButton setImage:[UIImage imageNamed:@"clock_icon"] forState:UIControlStateNormal];
    historyButton.autoresizesSubviews = YES;
    historyButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [historyButton addTarget:self action:@selector(deleteHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyButtonView addSubview:historyButton];
    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc]initWithCustomView:historyButtonView];
    
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:@"info_icon"] forState:UIControlStateNormal];
    leftButton.autoresizesSubviews = YES;
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [leftButton addTarget:self action:@selector(openInfoPage:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    UIBarButtonItem* infoButton = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:infoButton, historyButtonItem, searchButton, nil];
    
    //self.navigationItem.leftBarButtonItem = doneBtn;
    
    manager = [AFHTTPRequestOperationManager manager];

    cards = [[NSMutableDictionary alloc] init];
    
    parent = (MMDrawerController *) self.parentViewController.parentViewController;
    
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

    xOffset = 0;
    padding = 10;
    numSchede = 0;
    
    [self reloadLayout];
    [self getDomains];
}

-(void) getDominio:(Domain *)dominio {

    if (dominio != nil) {
        
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
                NSLog(@"Trovata card con indice = %d", cardIndex);
                [self scrollToIndex:cardIndex];
            }
            else {
                //pageIndex++;
                NSLog(@"non c'è, scarico dominio");
                [self getCategoriesByDomain:dominio];
            }
        }
    }
}

-(void) getDomainCategory:(NSString *) categoria fromDomain:(Domain *) dominio {

    if (categoria == nil) {
        NSLog(@"categoria nulla");
        return;
    }
    
    if (dominio == nil) {
        NSLog(@"dominio nullo");
        return;
    }
    
    if (dominio.descriptor == nil) {
        NSLog(@"dominio descriptor nullo");
        return;   
    }
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/hierarchy?category="];
    NSString *termine = [Utils WWWFormEncoded:categoria];
    NSString *dom = [Utils WWWFormEncoded:dominio.descriptor];
    domainPath = [[[domainPath stringByAppendingString:termine] stringByAppendingString:@"&domain="] stringByAppendingString:dom];
    
    NSLog(@"chiamo %@ con lingua %@", domainPath, lingua);
    
    [manager.requestSerializer setValue:lingua forHTTPHeaderField:@"accept-language"];
    
    [manager GET:domainPath parameters:nil
     
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             /*
             NSDictionary *json = (NSDictionary *)responseObject;
             NSDictionary *dominioJson = [json objectForKey:@"domain"];
             NSString *language = [json objectForKey:@"language"];
             NSString *descriptor = [json objectForKey:@"descriptor"];
             NSArray *termsArray = [json objectForKey:@"terms"];
             Domain *dominio = [Domain getDomainFromJson:dominioJson];
             NSLog(@"array = %d", (int)[termsArray count]);
             */
             
             NSDictionary *json = (NSDictionary *)responseObject;
             
             if (json != nil) {
                 Categoria *cat = [Categoria createFromJson:json];
                 if (cat != nil) {
                     
                     NSLog(@"creo card per categoria");
                     CGRect cardFrame = CGRectMake(padding + xOffset, padding, larghezza, altezza);
                     CategoryCard *card = [cat createCategoryCardWithFrame:cardFrame];
                     card.tag = numSchede * 1000;
                     [card render];
                     [self addCardToStoryboard:card];
                 }
             }
             
         }
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione"
                                                               message:error.localizedDescription
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
             
             [message show];
         }
     ];
}

-(void) getCategoriesByDomain:(Domain *) dominio {
    
    if (dominio == nil) return;
    
    if (dominio.descriptor == nil) return;
    
    dominioScelto = dominio;
    [Utils setCurrentDomain:dominio];
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/hierarchy?domain="];
    NSString *termine = [Utils WWWFormEncoded:dominio.descriptor];
    
    if (termine == nil) return;
    
    domainPath = [domainPath stringByAppendingString:termine];
    
    [manager GET:domainPath parameters:nil
     
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
             NSDictionary *json = (NSDictionary *)responseObject;
             
             //contiene dominio linguaggio e categorie
             
             NSArray *categorie  = [json objectForKey:@"categories"];
             
             NSLog(@"trovate %d categorie", (int) categorie.count);
             
             //creo card
             CGRect domCatFrame = CGRectMake(padding + xOffset, padding, larghezza, altezza);
             DomainCategoryCard *card = [[DomainCategoryCard alloc] initWithFrame:domCatFrame];
             card.tag = numSchede * 1000;
             card.categorie = categorie;
             card.dominio = dominio;
             [card render];
             [self addCardToStoryboard:card];
             UIColor *colore = [Utils colorFromHexString:card.dominio.color];
             NSLog(@"colore = %@", [colore description]);
             [self.navigationController.navigationBar setBarTintColor:colore];
         }
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

-(void) getDomains {

    NSString *downloadMsg = NSLocalizedString(@"DOWNLOAD_DOMAINS", @"scaricamento domini");
    
    float height = 22;
    float top = (self.view.frame.size.height - 66) / 2 - height - 37;
    float leftMargin = 20;
    float width = self.view.frame.size.width - 2*leftMargin;
    
    UILabel *dwnLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin,top,width,height)];
    dwnLbl.text = downloadMsg;
    dwnLbl.textAlignment = NSTextAlignmentCenter;
    dwnLbl.textColor = [UIColor darkGrayColor];
    [dwnLbl setFont:[UIFont systemFontOfSize:16.f]];
    
    float metaY = top + 37;
    float metaX = width / 2;
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(metaX, metaY, 37, 37)];
    [loader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loader setTintColor:[UIColor darkGrayColor]];
    [loader setColor:[UIColor darkGrayColor]];
    loader.hidesWhenStopped = YES;
    [self.view addSubview:loader];
    [loader startAnimating];
    [self.view addSubview:dwnLbl];
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/domains"];
    
    [manager GET:domainPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        NSLog(@"json");
        NSLog(@"%@", [json description]);
        NSArray *domini = [json objectForKey:@"domains"];
        
        if (domini.count > 0) {
            
            listaDomini = [[NSMutableArray alloc] init];
            
            for (NSDictionary *domain in domini) {
                Domain *dominio = [Domain getDomainFromJson:domain];
                [listaDomini addObject:dominio];
            }
            
            //Domain *dominio = [Domain new];
            //dominio.descriptor = @"Turismo"; // DOVREBBE SCEGLIERE UTENTE
            //all'avvio creo DomainCard
            
            [dwnLbl removeFromSuperview];
            [loader removeFromSuperview];
            
            CGRect domainFrame = CGRectMake(padding + xOffset, padding, larghezza, altezza);
            DomainCard *mainCard = [[DomainCard alloc] initWithFrame:domainFrame]; //[DomainCard createWithDomain:dominio];
            mainCard.tag = numSchede * 1000;
            mainCard.domini = listaDomini;
            [mainCard render];
            [self addCardToStoryboard:mainCard];
            
            NSLog(@"trovati %d domini", (int) listaDomini.count);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [dwnLbl removeFromSuperview];
        [loader removeFromSuperview];
    }];
    
}

-(void) openInfoPage:(id) sender {
    NSLog(@"openInfoPage");
    
    UIStoryboard * st =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *infoVCsid = @"infoVCsid";
    
    InfoViewController *infoVC = (InfoViewController *) [st instantiateViewControllerWithIdentifier:infoVCsid];

    if (infoVC != nil) [self.navigationController pushViewController:infoVC animated:YES];
}

-(void) deleteHistory:(id)sender {
    NSLog(@"deleteHistory");
    
    NSLog(@"ci sono %d pagine", totPages);
    
    [self removeCards:NO];
    
    for (int i=totPages - 1; i > 1; i--){
        //[self removeCard:i];
    }
    
    //removeCard
    
}

-(void) openSearchMenu:(id)sender {
    NSLog(@"openSearchMenu");
    [parent openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        SideMenuTableViewController *side = (SideMenuTableViewController *) parent.rightDrawerViewController;
        [side menuOpen:listaDomini];
    }];
}

-(TermCard *) createTermCard {
    NSLog(@"createCard con altezza = %f", altezza);
    CGRect frame = CGRectMake(padding + xOffset, padding, larghezza, altezza);
    TermCard *card = [[TermCard alloc] initWithFrame:frame];
    card.tag = numSchede * 1000;
    return card;
}

-(void) removeCards:(BOOL) all {
    
    NSArray *subviews = [self.scrollView subviews];
    int totViews = (int) [subviews count];
    
    NSLog(@"ci sono %d subviews", totViews);
    
    if (totViews < 3) {
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
    
    xOffset = startIndex * self.view.frame.size.width;
    
    self.scrollView.contentSize = CGSizeMake(5 + scrollWidth * startIndex, CONTENT_SIZE_HEIGHT);
    
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
    
    lingua = @"it";
    
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
    
    //NSLog(@"subviews = %d", tot);
    
    int index = indice / 1000;
    
    for (int i = index; i < tot; i++) {
        NSLog(@"itero vista %d", i);
        UIView *view = [subviews objectAtIndex:i];
        CGRect rect = view.frame;
        rect.origin.x -= larghezza + 2*padding;
        view.frame = rect;
        //ricambiare i tag
    }
    
    [vista removeFromSuperview];
}

-(void) addCardToStoryboard:(GenericScrollCard *) scheda {
    
    NSString *riferimento = [scheda getName];
    
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
            [self.scrollView addSubview:scheda];
            self.scrollView.contentSize = CGSizeMake(5 + scrollWidth + xOffset, CONTENT_SIZE_HEIGHT);
            xOffset += self.view.frame.size.width;
            scheda.controller = self;
            [self scrollToIndex:totPages - 1];
        }
    }
    
    NSLog(@"############ cards = %@\n###########################", [cards description]);
}

-(void) scrollLeft {
    if (pageIndex >= 1) {
        [self scrollToIndex:pageIndex-1];
    }
}

-(void) scrollToIndex:(int) indice {
    float offset = (indice) * scrollWidth;
    NSLog(@"vado a offset = %f", offset);
    [self scrollToPoint:CGPointMake(offset, 0)];
}

-(void) scrollRight {
    //[self scrollToPoint:CGPointMake(xOffset - scrollWidth, 0)];
   [self scrollToIndex:pageIndex+1];
}

-(void) scrollToPoint:(CGPoint) punto {
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.scrollView.contentOffset = punto;
        
        pageIndex = punto.x / scrollWidth;
        NSLog(@"PAGINA [1] = %d", pageIndex);
        
        if (pageIndex == 0) {
            backButtonItem.style = UIBarButtonItemStylePlain;
            backButtonItem.enabled = false;
            backButtonItem.title = nil;
        }
        else {
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float nuovaX = self.scrollView.contentOffset.x;
    pageIndex = nuovaX / scrollWidth;
    NSLog(@"PAGINA [2] = %d", pageIndex);
    
    if (pageIndex == 0) {
        //home
        self.navigationController.navigationBar.barTintColor = [Utils getDefaultColor];
    }
    else {
        if (dominioScelto != nil) {
            self.navigationController.navigationBar.barTintColor = [Utils colorFromHexString:dominioScelto.color];
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
    
    //controllare se già esiste o se crere scheda
    //[self getCategory:catName];
    
    Domain *dominio = dom;
    [self getDomainCategory:catName fromDomain:dominio];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarShouldBeginEditing");
    
    [parent openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
    return NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked");
}
-(void) getTerm:(NSString *)term inLanguage:(NSString *)lang {
    
    NSLog(@"get Term, controllo se %@ esiste", term);
    
    if (cards != nil) {
        int cardIndex = [[cards objectForKey:term] intValue];
        if (cardIndex > 0) {
            NSLog(@"Trovata card con indice = %d", cardIndex);
            [self scrollToIndex:cardIndex];
        }
        else {
            NSLog(@"Card non trovata, scarico, dominio scelto = %@", dominioScelto.descriptor);
            
            [self getSingleTerm:term withDomain:dominioScelto andLanguage:lang];
        }
    }
}

-(void) getSingleTerm:(NSString *)term withDomain:(Domain *) dominio andLanguage:(NSString *)lang {

    NSLog(@"[ScrollerViewController] getSingleTerm");
    
    if (term == nil) return;
    
    if (dominio == nil) {
        NSLog(@"Dominio mancante, esco");
        return;
    }
    
    //term = @"Alberghi";
    
    term = [Utils WWWFormEncoded:term];
    
    NSLog(@"getSingleTerm = %@", term);
    
    NSString *dom = [Utils WWWFormEncoded:dominio.descriptor];
    
    if (dom == nil) {
        NSLog(@"Dominio non impostato");
        return;
    }
    
    NSString *domain = [@"&domain=" stringByAppendingString:dom];
    NSString *prefix = @"/terms?descriptor=";
    
    NSString *termRequest = [[[[Utils getServerBaseAddress] stringByAppendingString:prefix] stringByAppendingString:term] stringByAppendingString:domain];
    
    if (manager == nil) return;
    
     NSLog(@"termRequest = %@", termRequest);
    
    [manager.requestSerializer setValue:lang forHTTPHeaderField:@"accept-language"];
    
    [manager GET:termRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        Term *term = [Term createTermFromJson:json];
        
        if (term != nil) {

            //creo card vuota
            TermCard *card = [self createTermCard];
            
            //popolo card con i dati del term
            card = [term createTermCard:card];
            
            //inserisco card nella vista
            [self addCardToStoryboard:card];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSDictionary *userInfo = [error userInfo];
        
        NSInteger statusCode = operation.response.statusCode;
    
        NSString *msg = (statusCode == 404) ? @"Termine non trovato" : error.localizedDescription;
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione"
                                                          message:msg
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }];
    
}

@end
