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

@interface CListViewController () <UIGestureRecognizerDelegate>
- (void)pan:(UIPanGestureRecognizer *)pgr;
@end

@implementation CListViewController {
  NSArray *_listItems;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _listItems = [self.list.listItems allObjects];
  
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  panGestureRecognizer.maximumNumberOfTouches = 1;
  panGestureRecognizer.delegate = self;
  [self.tableView addGestureRecognizer:panGestureRecognizer];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"CListItemCell" bundle:nil]
       forCellReuseIdentifier:@"ListItemCell"];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  CGPoint translation = [gestureRecognizer translationInView:self.tableView];
  if (fabsf(translation.x) > fabsf(translation.y)) {
    return YES;
  }
  return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"ListItemCell";
  CListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  ListItem *listItem = [_listItems objectAtIndex:indexPath.row];
  cell.detailsLabel.text = listItem.details;
  
  return cell;
}

#pragma mark - Table view delegate


#pragma mark - Private

- (void)pan:(UIPanGestureRecognizer *)pgr
{
  CGPoint point = [pgr locationInView:self.tableView];
  static CListItemCell *cell;
  static BOOL valid = NO;
  static CGPoint start;
  if (pgr.state == UIGestureRecognizerStateBegan) {
    cell = (CListItemCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:point]];
    valid = [cell startSlashAtPoint:point];
    
    start = point;
  }
  
  if (cell && valid) {
    
    CGPoint translation = [pgr translationInView:self.tableView];
    [cell drawSlashWithTranslation:translation];
    
    NSLog(@"translation.x: %f", translation.x);
    
    [pgr setTranslation:CGPointZero
                 inView:self.tableView];
    
    if (pgr.state == UIGestureRecognizerStateEnded) {
      CGPoint velocity = [pgr velocityInView:self.tableView];
      CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
      [cell endSlashAtPoint:point
              withMagnitude:magnitude];
    }
  }
}

#pragma mark - Segues

- (IBAction)viewNewListUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"view new list unwindSegue");
}

@end


