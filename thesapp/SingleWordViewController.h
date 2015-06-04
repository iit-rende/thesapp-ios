//
//  SingleWordViewController.h
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 27/04/15.
//
//

#import <UIKit/UIKit.h>

@interface SingleWordViewController : UIViewController
{
    NSMutableArray *sinonimi, *correlati, *generici, *specifici;
}
//@property (weak, nonatomic) IBOutlet UIView *container;

@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *sinonimiContainer;
@property (weak, nonatomic) IBOutlet UIView *correlatiContainer;
@property (weak, nonatomic) IBOutlet UITextView *descrizione;
@property (weak, nonatomic) IBOutlet UILabel *titolo;
@property (weak, nonatomic) NSString *parola;

@end
