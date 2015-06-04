//
//  GPCMLPAutoCompleteDemoViewController.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Giorgio Piacentini on 05/07/14.
//
//

#import "GPCMLPAutoCompleteDemoViewController.h"
#import "PageRootViewController.h"

@interface GPCMLPAutoCompleteDemoViewController ()

@end

@implementation GPCMLPAutoCompleteDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MLPAutoCompleteTextFieldDelegate
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
        
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
        
        PageRootViewController *swvc = (PageRootViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"Root"];
        //swvc.parola = selectedString;
        //[self.navigationController pushViewController:swvc animated:YES];
        
        [self.navigationController presentViewController:swvc animated:YES completion:nil];
    }
}

@end
