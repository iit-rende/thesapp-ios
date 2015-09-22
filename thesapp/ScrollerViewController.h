//
//  ScrollerViewController.h
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 12/05/15.
//
//

#import <UIKit/UIKit.h>
#import "TermCard.h"
#import "DomainCard.h"
#import "Term.h"
#import "Categoria.h"
#import <AFHTTPRequestOperationManager.h>
#import <MMDrawerController.h>
#import "DomainCategoryCard.h"
#import "Global.h"
#import "TimelineDelegate.h"
#import "Repository.h"
#import "CardController.h"

@interface ScrollerViewController : UIViewController<UIScrollViewDelegate, CardController, TimelineDelegate>
{
    int pageIndex, totPages, xOffset, numSchede;
    float larghezza, altezza, padding, topPadding, screenWidth, scrollWidth;
    AFHTTPRequestOperationManager *manager;
    MMDrawerController *parent;
    NSMutableDictionary *cards;
    UIBarButtonItem *backButtonItem;
    NSString *lingua, *defaultLanguage;
    BOOL portrait, manuale;
    UILabel *dwnLbl;
    UIButton *retryBtn;
    UIActivityIndicatorView *loader;
    UIBarButtonItem *titleButton;
    Repository *repo;
}

//-(void) getSingleTerm:(NSString *)term withDomain:(Domain *) dominio andLanguage:(NSString *)lang;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *listaDomini;
//@property (nonatomic, strong) Domain *dominioScelto;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *search;

-(IBAction) openSearchMenu:(id)sender;
@end
