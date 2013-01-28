//
//  CViewController.m
//  Cluttered
//
//  Created by Sean Pilkenton on 9/30/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "CViewController.h"
#import "CAuthorListViewController.h"
#import "ListsDataModel.h"
#import "List.h"
#import "CListViewController.h"
#import "PLKClutteredCell.h"
#import "PLKClutteredLayout.h"
#import "CAuthoringUnwindSegue.h"

@interface CViewController () <PLKClutteredDelegateLayout>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
- (void)setLists;
- (void)addButton;
- (void)removeButton:(void (^)(void))completion;
@end

@implementation CViewController {
  NSFetchedResultsController *_fetchedResultsController;
  NSMutableArray *_lists;
  NSMutableArray *_swipedLists;
  
  // UI Elements
  UIButton *_addButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.collectionView.collectionViewLayout = [[PLKClutteredLayout alloc] init];
  
  [self loadLists];
  _swipedLists = [[NSMutableArray alloc] init];
  
  
  NSLog(@"main view frame: %@", self.view);
  NSLog(@"main view frame: %@", NSStringFromCGRect(self.view.bounds));
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self addButton];
  
}

- (void)viewDidDisappear:(BOOL)animated
{
  
  [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadLists {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[List entityName]];
  fetchRequest.fetchBatchSize = 40;
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
  fetchRequest.sortDescriptors = @[sortDescriptor];
  _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:[[ListsDataModel sharedDataModel] mainContext]
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:nil];
  NSError *err = nil;
  if ([_fetchedResultsController performFetch:&err]) {
    NSLog(@"fetch success");
    [self setLists];
  } else {
    NSLog(@"fetch failed: %@ %@", [err localizedDescription], [err userInfo]);
  }
}

- (void)setLists
{
  _lists = [NSMutableArray arrayWithArray:_fetchedResultsController.fetchedObjects];
}

- (void)addButton
{
  if (!_addButton) {
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton addTarget:self
                   action:@selector(transitionToAuthorList)
         forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTitle:@"+"
                forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addButton.frame = CGRectMake(self.collectionView.bounds.size.width - 30.0, -20.0, 20.0, 20.0);
    [self.collectionView addSubview:_addButton];
    
    _addButton.alpha = 0.0;
    [UIView animateWithDuration:0.25
                          delay:0.25
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       _addButton.alpha = 1.0;
                       _addButton.center = CGPointMake(_addButton.center.x,
                                                       _addButton.center.y + 30.0);
                     } completion:nil];
  }
}

- (void)removeButton:(void (^)(void))completion
{
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     _addButton.center = CGPointMake(_addButton.center.x,
                                                     _addButton.center.y - 30.0);
                     _addButton.alpha = 0.0;
                   }
                   completion:^(BOOL finished) {
                     [_addButton removeFromSuperview];
                     _addButton = nil;
                     completion();
                   }];
}



#pragma mark - Public



#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  int count = _lists.count;
  NSLog(@"number of items in section %d: %d", section, count);
  return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  int ns = (_lists.count) ? 1 : 0;
  NSLog(@"number of sections: %d", ns);
  
  return 1;
  
  return ns;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PLKClutteredCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
  
  List *list = _lists[indexPath.row];
  cell.titleLabel.text = list.name;
  
  return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  List *list = [_fetchedResultsController objectAtIndexPath:indexPath];
  [self performSegueWithIdentifier:@"ViewList" sender:list];
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//  NSLog(@"did select item at indexpath: %@", indexPath);
//}

#pragma mark - PLKClutteredDelegateLayout

- (void)swipeIn
{
  
  if (_swipedLists.count) {
    List *swipedInList = _swipedLists[0];
    
    [_swipedLists removeObject:swipedInList];
    [_lists addObject:swipedInList];
    
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.collectionView numberOfItemsInSection:0]
                                                                      inSection:0]]];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
itemAtIndexPathThrownOut:(NSIndexPath *)indexPath
{
  if (_lists.count) {
    List *swipedOutList = [_lists objectAtIndex:indexPath.row];
    
    [_swipedLists insertObject:swipedOutList atIndex:0];
    [_lists removeObject:swipedOutList];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
  }
}

#pragma mark - CAddListViewControllerDelegate

- (void)dismiss:(BOOL)newList
{
  [self dismissViewControllerAnimated:YES completion:^{
    if (newList) {
      [self loadLists];
      [self.collectionView reloadData];
    }
  }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"AddNewList"]) {
    CAuthorListViewController *destinationViewController = segue.destinationViewController;
//    [destinationViewController setDelegate:self];
    
  } else if ([segue.identifier isEqualToString:@"ViewList"]) {
    CListViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.list = sender;
  }
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier
{
  if ([identifier isEqualToString:@"cancelAuthoring"]) {
    return [[CAuthoringUnwindSegue alloc] initWithIdentifier:identifier
                                                      source:fromViewController
                                                 destination:toViewController];
  }
  
  return [super segueForUnwindingToViewController:toViewController
                               fromViewController:fromViewController
                                       identifier:identifier];
}

- (void)transitionToAuthorList
{
  [self removeButton:^{
    NSLog(@"button removed");
    [self testRemoval];
  }];
}

- (void)testRemoval
{
  NSLog(@"test removal");
  
  CGPoint x = CGPointMake(self.collectionView.center.x - (self.collectionView.bounds.size.width + 50),
                          self.collectionView.center.y);
  
  int index = _lists.count - 1;
  NSLog(@"index: %d", index);
  UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                              inSection:0]];
  if (index != -1) {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                       NSLog(@"animating");
                       
                       
                       NSLog(@"cell.name: %@", ((PLKClutteredCell *)cell).titleLabel.text);
                       cell.center = x;
                     } completion:^(BOOL finished) {
                       if (_lists.count) {
                         [_lists removeObjectAtIndex:index];
                         [self testRemoval];
                       } else {
//                       [_lists removeAllObjects];
//                       [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
//
//                       [self performSegueWithIdentifier:@"AddNewList" sender:nil];
                       }
                     }];
  }
  else {
    [_lists removeAllObjects];
//    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    [self.collectionView reloadData];
    
    [self performSegueWithIdentifier:@"AddNewList" sender:nil];
  }
}

- (IBAction)cancelAuthoringUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"cancel authoring unwind");
  [self setLists];
  [self.collectionView reloadData];
}

- (IBAction)goBackUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"return home.");
}

@end
