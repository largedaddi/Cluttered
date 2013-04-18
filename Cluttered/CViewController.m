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
- (void)updateLists;
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
  
  NSLog(@"CViewController loaded.");
  
  self.collectionView.collectionViewLayout = [[PLKClutteredLayout alloc] init];
  
  [self fetchLists];
  _swipedLists = [[NSMutableArray alloc] init];
  
  double delayInSeconds = 1.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    _lists = [[NSMutableArray alloc] init];
    [self groupInsert];
  });
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



- (void)updateLists
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

- (void)fetchLists {
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
    
//    [self updateLists];
    
  } else {
    NSLog(@"fetch failed: %@ %@", [err localizedDescription], [err userInfo]);
  }
}

- (void)groupInsert
{
  if (_lists.count) {
    [_lists removeAllObjects];
  }
  
  for (int i = 0; i < _fetchedResultsController.fetchedObjects.count; i++) {
    [self performSelector:@selector(insertListWithIndex:) withObject:@(i) afterDelay:0.25 * i];
  }
}

- (void)insertListWithIndex:(NSNumber *)index
{
  NSInteger i = [index integerValue];
  NSLog(@"INSERTING FETCHED OBJECT WITH INDEX: %d", i);
  [_lists addObject:_fetchedResultsController.fetchedObjects[i]];
  [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
}

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
  NSLog(@"list.imagePath: %@", list.imagePath);
  cell.preview.image = [UIImage imageWithContentsOfFile:list.imagePath];
  
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
      [self fetchLists];
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
    [self groupedRemoval];
  }];
}

- (void)groupedRemoval
{
  NSLog(@"test removal");
  
  int index = _lists.count - 1;
  if (index == -1) {
    //    No (more) cells to deal with
    [self performSegueWithIdentifier:@"AddNewList" sender:nil];
  } else {
    //    Cells to deal with
    CGPoint x = CGPointMake(self.collectionView.center.x - (self.collectionView.bounds.size.width + 50),
                            self.collectionView.center.y);
    
    ((PLKClutteredLayout *)self.collectionView.collectionViewLayout).finalDestination = x;
    
    
    [_lists removeObjectAtIndex:index];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    
    if (_lists.count) {
      [self groupedRemoval];
    } else {
      [self performSegueWithIdentifier:@"AddNewList" sender:nil];
    }
  }
}

- (IBAction)cancelAuthoringUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"cancel authoring unwind");
  [self updateLists];
  

//  [self.collectionView reloadData];
}

- (IBAction)goBackUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"return home.");
}

@end
