//
//  CViewController.m
//  Cluttered
//
//  Created by Sean Pilkenton on 9/30/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "CViewController.h"
#import "CAddListViewController.h"
#import "ListsDataModel.h"
#import "List.h"
#import "CListViewController.h"
#import "PLKClutteredCell.h"
#import "PLKClutteredLayout.h"

@interface CViewController () <CAddListViewControllerDelegate, PLKClutteredDelegateLayout>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
- (void)loadLists;
@end

@implementation CViewController {
  NSFetchedResultsController *_fetchedResultsController;
  NSMutableArray *_lists;
  NSMutableArray *_swipedLists;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.collectionView.collectionViewLayout = [[PLKClutteredLayout alloc] init];
  
  [self loadLists];
  _swipedLists = [[NSMutableArray alloc] init];
  
  
  UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [addButton addTarget:self
                action:@selector(authorList)
      forControlEvents:UIControlEventTouchUpInside];
  [addButton setTitle:@"+"
             forState:UIControlStateNormal];
  [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  addButton.frame = CGRectMake(self.collectionView.bounds.size.width - 30.0, -20.0, 20.0, 20.0);
  [self.collectionView addSubview:addButton];
  
  addButton.alpha = 0.0;
  [UIView animateWithDuration:0.25
                        delay:0.25
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     addButton.alpha = 1.0;
                     addButton.center = CGPointMake(addButton.center.x,
                                                    addButton.center.y + 30.0);
                   } completion:nil];
  
  //  NSManagedObjectContext *ctx = [[ListsDataModel sharedDataModel] mainContext];
  //  if (ctx) {
  //    NSLog(@"context is ready.");
  //
  //
  //    List *list = [List insertInManagedObjectContext:ctx];
  //    list.name = @"hmmm";
  //
  //    [ctx save:nil];
  //
  //  } else {
  //    NSLog(@"nope. :(");
  //  }
  //
  //  [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ListCell"];
  
  //  self.view.translatesAutoresizingMaskIntoConstraints = NO;
  //  self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  
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
    _lists = [NSMutableArray arrayWithArray:_fetchedResultsController.fetchedObjects];
  } else {
    NSLog(@"fetch failed: %@ %@", [err localizedDescription], [err userInfo]);
  }
}

- (void)authorList
{
  [self performSegueWithIdentifier:@"AddNewList"
                            sender:nil];
}

#pragma mark - Public

- (IBAction)cancelAuthoringUnwindSegue:(id)sender
{
  NSLog(@"cancel authoring unwind");
  
}

- (IBAction)returnHomeUnwindSegue:(UIStoryboardSegue *)segue
{
  NSLog(@"return home.");
}


#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  //  id<NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
  //  NSLog(@"number of items in section %d", [sectionInfo numberOfObjects]);
  //  return [sectionInfo numberOfObjects];
  //  NSLog(@"number of item in section 0: %d", [_lists count]);
  
  return [_lists count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  //  NSLog(@"number of sections: %d", [[_fetchedResultsController sections] count]);
  //  return [[_fetchedResultsController sections] count];
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  //  NSLog(@"cell for item and index path");
  
  PLKClutteredCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
  
  List *list = _lists[indexPath.row];
  
  //  NSLog(@"cellforitematindexpath: list.name = %@ ", list.name);
  //  NSLog(@"cellforitematindexpath: indexpath.section: %d, .row: %d", indexPath.section, indexPath.row);
  
  cell.titleLabel.text = list.name;
  //  NSLog(@"list.name: %@", list.name);
  //  NSLog(@"list.details: %@", list.details);
  
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

//- (void)collectionView:(UICollectionView *)collectionView
//itemAtIndexPathPulledIn:(NSIndexPath *)indexPath
//{
//  NSLog(@"pulled in.");
//}

- (void)swipeIn
{
  
  if (_swipedLists.count) {
    List *swipedInList = _swipedLists[0];
    NSLog(@"swipedInList.name: %@", swipedInList.name);
    [_swipedLists removeObject:swipedInList];
    [_lists addObject:swipedInList];
    
    NSLog(@"_lists: %@", _lists);
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.collectionView numberOfItemsInSection:0]
                                                                      inSection:0]]];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
itemAtIndexPathThrownOut:(NSIndexPath *)indexPath
{
  
  //  NSLog(@"thrown out.");
  if (_lists.count) {
    List *swipedOutList = [_lists objectAtIndex:indexPath.row];
    //    NSLog(@"swipedOutList.name: %@", swipedOutList.name);
    
    [_swipedLists insertObject:swipedOutList atIndex:0];
    [_lists removeObject:swipedOutList];
    
    //    NSLog(@"_lists: %@", _lists);
    //    NSLog(@"indexpath: %@", indexPath);
    
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
    CAddListViewController *destinationViewController = segue.destinationViewController;
    [destinationViewController setDelegate:self];
  } else if ([segue.identifier isEqualToString:@"ViewList"]) {
    CListViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.list = sender;
  }
}

@end
