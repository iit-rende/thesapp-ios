//
//  SettingsViewController.m
//  thesapp
//
//  Created by Paolo Burzacca on 14/11/15.
//  Copyright © 2015 IIT Cnr. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utils.h"

@implementation SettingsViewController

-(void) viewWillAppear:(BOOL)animated {
    
    lingue = @[@"Italiano", @"Inglese"];
    locali = @[@"it", @"en"];
    NSString *cur = [Utils getCurrentLanguage];
    lingua = ([cur isEqualToString:@"it"]) ? 0 : 1;
    
    NSArray *visible       = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
    lastSelectedIndexPath = indexpath;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"Impostazioni";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lingue.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selezioanta riga %d, sezione %d", indexPath.row, indexPath.section);
    
    int riga = (int) lastSelectedIndexPath.row;
    
    if (riga == indexPath.row) {
        lastSelectedIndexPath = indexPath;
        return;
    }
    
    NSLog(@"arrivo qui");
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;

    NSLog(@"deseleziono riga %d, sezione %d", lastSelectedIndexPath.row, lastSelectedIndexPath.section);
    
    UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:lastSelectedIndexPath];
    
    //int altrariga = (riga) ? 0 : 1;
    
    NSLog(@"testo = %@", lastSelectedCell.textLabel.text);
    lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    lastSelectedIndexPath = indexPath;
    
    NSString *locale;
    
    NSString *vecchioTopic = [[Global singleton] getTopicName];
    
    NSLog(@"vecchiotopic = %@", vecchioTopic);
    
    if (vecchioTopic != nil && appDelegate != nil) {

        
        locale = locali[indexPath.row];
        NSString *newTopic = [[Global singleton] getTopicByLanguage:locale];
        
        NSLog(@"unsubscribeTopic e subriscre to %@", newTopic);
        
        [appDelegate unsubscribeTopic:vecchioTopic andSubcribeTopic:newTopic];
    }
    
    [Utils saveLanguage:locale];
    
    [[Global singleton] setNewTopicName];
    
    //NSString *nuovoTopic = [[Global singleton] getTopicName];
    //if (nuovoTopic != nil && appDelegate != nil) [appDelegate subscribeToTopic:nuovoTopic];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" Scegli la lingua";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"cella";
    
    int riga = (int) indexPath.row;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = lingue[indexPath.row];
    
    if (lingua == riga) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastSelectedIndexPath = indexPath;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [cell.contentView addSubview:lineView];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
