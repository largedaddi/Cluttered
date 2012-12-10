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
#import "PLKClutteredLayout.h"
#import "PLKClutteredListCell.h"

@interface CViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CAddListViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
- (void)loadLists;
@end

@implementation CViewController {
  NSFetchedResultsController *_fetchedResultsController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.collectionView.collectionViewLayout = [[PLKClutteredLayout alloc] init];
  
  [self loadLists];
  
  [self.collectionView reloadData];
  
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
  } else {
    NSLog(@"fetch failed: %@ %@", [err localizedDescription], [err userInfo]);
  }
}

#pragma mark - Public

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
  NSLog(@"number of items in section %d", [sectionInfo numberOfObjects]);
  return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  NSLog(@"number of sections: %d", [[_fetchedResultsController sections] count]);
  return [[_fetchedResultsController sections] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"cell for item and index path");
  PLKClutteredListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
  
  cell.backgroundColor = [UIColor lightGrayColor];
  
  List *list = [_fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.titleLabel.text = list.name;
  NSLog(@"list.name: %@", list.name);
  NSLog(@"list.details: %@", list.details);
  
  return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  List *list = [_fetchedResultsController objectAtIndexPath:indexPath];
  [self performSegueWithIdentifier:@"ViewList" sender:list];
}
//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//  
//}

#pragma mark - UICollectionView Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(50, 40, 50, 40);
}

#pragma mark - CAddListViewControllerDelegate

- (void)dismiss {
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"done.");
  }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UINavigationController *navigationViewController = segue.destinationViewController;
  if ([segue.identifier isEqualToString:@"AddNewList"]) {
    UIViewController *destinationViewController = [[navigationViewController viewControllers] objectAtIndex:0];
    [(CAddListViewController *)destinationViewController setDelegate:self];
  } else if ([segue.identifier isEqualToString:@"ViewList"]) {
    CListViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.list = sender;
  }
}

@end
