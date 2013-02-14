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
- (void)handleListSwipe:(UIPanGestureRecognizer *)pgr;
- (void)handleTwoFingerUnwind:(UISwipeGestureRecognizer *)sgr;
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
  
  UISwipeGestureRecognizer *twoFingerUnwindGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerUnwind:)];
  twoFingerUnwindGestureRecognizer.numberOfTouchesRequired = 2;
  twoFingerUnwindGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  twoFingerUnwindGestureRecognizer.delaysTouchesBegan = YES;
  [self.tableView addGestureRecognizer:twoFingerUnwindGestureRecognizer];
  
//  [self addListSwipingGesture];
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleListSwipe:)];
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

- (void)handleListSwipe:(UIPanGestureRecognizer *)pgr
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

- (void)handleTwoFingerUnwind:(UISwipeGestureRecognizer *)sgr
{
  NSUInteger touches = sgr.numberOfTouchesRequired;
  NSLog(@"number of touches: %d", touches);
  if (touches == 2) {
    [self performSegueWithIdentifier:@"goBack"
                              sender:nil];
  }
}

#pragma mark - Segues

- (IBAction)viewNewListUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"view new list unwindSegue");
}

@end


