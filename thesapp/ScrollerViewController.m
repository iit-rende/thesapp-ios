//
//  ScrollerViewController.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 12/05/15.
//
//

#import "ScrollerViewController.h"
#import "Utils.h"

#define STARTING_CARD_NUM 1
#define CONTENT_SIZE_HEIGHT 300

@interface ScrollerViewController ()

@end

@implementation ScrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    pageIndex = 0; //pagina corrente
    totPages = 0;
    
    backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevCard:)];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    //self.navigationItem.leftBarButtonItem = doneBtn;
    
    manager = [AFHTTPRequestOperationManager manager];

    cards = [[NSMutableDictionary alloc] init];
    
    [self getDomains];

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
    larghezza = self.view.frame.size.width - 2 * padding;
    altezza = self.view.frame.size.height - 2 * padding - 60;
    scrollWidth = self.view.frame.size.width;

    numSchede = 0;
}

-(void) getDominio:(Domain *)dominio {

    if (dominio != nil) {
        
        //controllo se già esiste, altrimenti scarico
        
        NSString *riferimento = dominio.descriptor;
        
        NSLog(@"controllo se ho già scheda x rif = %@", riferimento);
        
        if (cards != nil) {
            int cardIndex = [[cards objectForKey:riferimento] intValue];
            if (cardIndex > 0) {
                NSLog(@"Trovata card con indice = %d", cardIndex);
                [self scrollToIndex:cardIndex];
            }
            else {
                //pageIndex++;
                NSLog(@"scarico dominio");
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
    
    //http://146.48.65.88/hierarchy?category=Strutture&domain=Turismo
    
    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/hierarchy?category="];
    NSString *termine = [Utils WWWFormEncoded:categoria];
    NSString *dom = [Utils WWWFormEncoded:dominio.descriptor];
    domainPath = [[[domainPath stringByAppendingString:termine] stringByAppendingString:@"&domain="] stringByAppendingString:dom];
    
    NSLog(@"chiamo %@", domainPath);
    
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

    NSString *domainPath = [[Utils getServerBaseAddress] stringByAppendingString:@"/domains"];
    
    [manager GET:domainPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        NSLog(@"json");
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
    }];
    
}

-(IBAction) openSearchMenu:(id)sender {
    NSLog(@"openSearchMenu");
    [parent openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(TermCard *) createTermCard {
    NSLog(@"createCard");
    CGRect frame = CGRectMake(padding + xOffset, padding, larghezza, altezza);
    TermCard *card = [[TermCard alloc] initWithFrame:frame];
    card.tag = numSchede * 1000;
    return card;
}

-(void) removeCard:(UIButton *) btn {
    NSLog(@"cliccato");
    
    NSArray *subviews = [self.scrollView subviews];
    
    UIView *vista = [subviews objectAtIndex:btn.tag];
    int indice = (int) vista.tag;
    NSLog(@"vista con tag = %d", indice);
    
    int tot = (int) subviews.count;
    
    NSLog(@"subviews = %d", tot);
    
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
            [cards setValue:[NSNumber numberWithInt:pageIndex] forKey:riferimento];
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
    NSLog(@"goToPrevCard");
    [self scrollLeft];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    float nuovaX = self.scrollView.contentOffset.x;
    NSLog(@"X = %f", nuovaX);
    
    pageIndex = nuovaX / scrollWidth;
    NSLog(@"PAGINA [2] = %d", pageIndex);
}

-(void) addCard:(UIButton *) btn {
    
    NSLog(@"addCard");
    TermCard *card = [self createTermCard];
    [self addCardToStoryboard:card];
}

-(void) clicca:(UIButton *) btn {
    
    NSLog(@"cliccato");
    [self addCard:btn];
}

#pragma mark - Card Controller methods

- (void) addCategoryCard:(NSString *) catName withDomain:(Domain *) dom {
    NSLog(@"[ScrollView] addCard con cat = %@", catName);
    
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
-(void) getTerm:(NSString *)term {
    NSLog(@"get Term, controllo se %@ esiste", term);
    
    if (cards != nil) {
        int cardIndex = [[cards objectForKey:term] intValue];
        if (cardIndex > 0) {
            NSLog(@"Trovata card con indice = %d", cardIndex);
            [self scrollToIndex:cardIndex];
        }
        else {
            NSLog(@"Card non trovata, scarico");
            [self getSingleTerm:term];
        }
    }
}

-(void) getSingleTerm:(NSString *)term {

    if (term == nil) return;
    
    //term = @"Alberghi";
    
    term = [Utils WWWFormEncoded:term];
    
    NSLog(@"getSingleTerm = %@", term);
    
    NSString *domain = [@"&domain=" stringByAppendingString:[Utils getChosenDomain]];
    NSString *prefix = @"/terms?descriptor=";
    
    NSString *termRequest = [[[[Utils getServerBaseAddress] stringByAppendingString:prefix] stringByAppendingString:term] stringByAppendingString:domain];
    
    if (manager == nil) return;
    
     NSLog(@"getSingleTerm = %@", termRequest);    
    
    [manager GET:termRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        Term *term = [Term createTermFromJson:json];
        
        if (term != nil) {

            //creo card vuota
            TermCard *card = [self createTermCard];
            
            NSLog(@"create term card");
            //popolo card con i dati del term
            card = [term createTermCard:card];
            
            //inserisco card nella vista
            [self addCardToStoryboard:card];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Errore: %@", error);
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione"
                                                          message:error.localizedDescription
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }];
    
}

@end
