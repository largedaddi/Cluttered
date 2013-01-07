//
//  CListViewController.m
//  Cluttered
//
//  Created by Sean Pilkenton on 11/10/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "CListViewController.h"
#import "List.h"
#import "ListItem.h"
#import "CListItemCell.h"

@interface CListViewController ()
- (void)pan:(UIPanGestureRecognizer *)pgr;
@end

@implementation CListViewController {
  NSArray *listItems;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  listItems = [self.list.listItems allObjects];
  
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  panGestureRecognizer.maximumNumberOfTouches = 1;
  [self.tableView addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"ListItemCell";
  CListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  ListItem *listItem = [listItems objectAtIndex:indexPath.row];
  cell.textLabel.text = listItem.details;
  cell.detailTextLabel.text = [listItem.complete stringValue];
  
  return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

#pragma mark - Private

- (void)pan:(UIPanGestureRecognizer *)pgr
{
  CGPoint point = [pgr locationInView:self.tableView];
  static CListItemCell *cell;
  static BOOL valid = NO;
  if (pgr.state == UIGestureRecognizerStateBegan) {
    cell = (CListItemCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:point]];
    valid = [cell startSlashAtPoint:point];
  }
  
  if (cell && valid) {
    if (pgr.state == UIGestureRecognizerStateChanged) {
      CGPoint translation = [pgr translationInView:self.tableView];
      [cell drawSlashWithTranslation:translation];
      [pgr setTranslation:CGPointZero
                   inView:self.tableView];
    }
    else if (pgr.state == UIGestureRecognizerStateEnded) {
      CGPoint velocity = [pgr velocityInView:self.tableView];
      CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
      [cell endSlashAtPoint:point
              withMagnitude:magnitude];
    }
  }
}

@end


