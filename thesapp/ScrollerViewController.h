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

@interface ScrollerViewController : UIViewController<UIScrollViewDelegate, UISearchBarDelegate, CardController>
{
    int pageIndex, xOffset, numSchede, scrollWidth;
    float larghezza, altezza, padding;
    AFHTTPRequestOperationManager *manager;
    MMDrawerController *parent;
    NSMutableArray *listaDomini;
    NSMutableDictionary *cards;
}

-(void) getSingleTerm:(NSString *)term;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *search;

-(IBAction) openSearchMenu:(id)sender;
@end
