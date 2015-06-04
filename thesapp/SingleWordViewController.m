//
//  SingleWordViewController.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 27/04/15.
//
//

#import "SingleWordViewController.h"
#import "WordButton.h"

@interface SingleWordViewController ()

@end

@implementation SingleWordViewController
@synthesize scroller, container, sinonimiContainer, correlatiContainer;

- (void)viewDidLayoutSubviews {
    //scroller.contentSize = CGSizeMake(320, 1800);
}

-(void) initArray {

    sinonimi = [[NSMutableArray alloc] initWithObjects:@"BBB", @"CCC", @"DDD", @"EEE",nil];
    correlati = [[NSMutableArray alloc] initWithObjects:@"DDD",@"EEE", nil];
    generici = [[NSMutableArray alloc] initWithObjects:@"FFF",@"GGG", nil];
    specifici = [[NSMutableArray alloc] initWithObjects:@"HHH",@"III", nil];
    
    if (sinonimi.count > 0) {
    
        float x = 10;
        float y = 10;
        
        for (NSString *parola in sinonimi) {
            NSLog(@"aggiungo parola = %@", parola);
            
            float width = 100;
            float height = 21;
            
            CGRect frame = CGRectMake(x, y, width, height);
            //WordLabel *lbl = [[WordLabel alloc] init];
            WordButton *lbl = [[WordButton alloc] initWithFrame:frame];
            [lbl setTitle:parola forState:UIControlStateNormal];
            lbl.titleLabel.text = parola;
            [lbl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            lbl.backgroundColor = [UIColor blueColor];
            lbl.titleLabel.textColor = [UIColor whiteColor];
            [lbl setTintColor:[UIColor whiteColor]];
            [lbl.titleLabel setTextColor:[UIColor redColor]];
            [sinonimiContainer addSubview:lbl];
            
            [lbl addTarget:self
                    action:@selector(btnClick:)
                    forControlEvents:UIControlEventTouchUpInside
             ];
            
            x += width + 10;
            //y += height + 10;
        }
    }
    
    if (correlati.count > 0) {
        
        float x = 10;
        float y = 10;
        
        for (NSString *parola in sinonimi) {
            NSLog(@"aggiungo parola = %@", parola);
            
            float width = 100;
            float height = 21;
            
            CGRect frame = CGRectMake(x, y, width, height);
            //WordLabel *lbl = [[WordLabel alloc] init];
            WordButton *lbl = [[WordButton alloc] initWithFrame:frame];
            [lbl setTitle:parola forState:UIControlStateNormal];
            lbl.backgroundColor = [UIColor blueColor];
            [correlatiContainer addSubview:lbl];
            
            x += width + 10;
            //y += height + 10;
        }
    }

}

-(void) btnClick:(UIButton *) btn{
    
    NSLog(@"btnClick, titolo = %@", btn.titleLabel.text);
    
    SingleWordViewController *swvc = (SingleWordViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SingleWord"];
    
    swvc.parola = btn.titleLabel.text;
    
    //[self.navigationController pushViewController:swvc animated:YES];
    
    UIPageViewController *parent =  (UIPageViewController *) self.parentViewController;
    
    NSArray *viewControllers = @[swvc];
    
    [parent setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {

        NSLog(@"fine");
        
    }];
    
    NSLog(@"parent = %@", [parent description]);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"[SingleWordViewController] viewDidLoad");
    
    [self initArray];
    
    scroller.clipsToBounds = YES;
    scroller.layer.cornerRadius = 3;
    scroller.layer.shadowOffset = CGSizeMake(-1, -1);
    scroller.layer.shadowRadius = 2;
    scroller.layer.shadowColor = [UIColor grayColor].CGColor;
    scroller.layer.shadowOpacity = 0.5;
    container.layer.borderWidth = 1.0f;
    container.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    container.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];

    NSLog(@"viewDidLoad");
    
    self.titolo.text = self.parola;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
