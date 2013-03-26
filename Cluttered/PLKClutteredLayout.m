//
//  PLKClutteredLayout.m
//  Cluttered
//
//  Created by Sean Pilkenton on 11/18/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "PLKClutteredLayout.h"
#import "PLKClutteredCell.h"
#import <QuartzCore/QuartzCore.h>

#define RANDOM_MAX 0x100000000

typedef enum {
  ClutteredSwipeIn,
  ClutteredSwipeOut
} ClutteredSwipeDirection;

@interface PLKClutteredLayout () <UIGestureRecognizerDelegate>

@end

@implementation PLKClutteredLayout {
  NSMutableArray *_insertedItems;
  NSMutableArray *_deletedItems;
  
  NSInteger _cellCount;
  CGRect _threshold;
  NSIndexPath *_selectedIndexPath;
  
  //  CGPoint _finalDestination;
  CGPoint _initialStartingPoint;
}

- (id)init
{
  self = [super init];
  if (self) {
    _insertedItems = [[NSMutableArray alloc] init];
    _deletedItems = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)prepareLayout {
  [super prepareLayout];
  static BOOL gesturized = NO;
  if (!gesturized) {
    [self setupGestures];
    
    _threshold = CGRectInset(self.collectionView.frame, 50.0, 55.0);
    
    gesturized = YES;
  }
  
  _cellCount = ([self.collectionView numberOfSections]) ? [self.collectionView numberOfItemsInSection:0] : 0;
}

- (CGSize)collectionViewContentSize {
  return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
  attributes.size = CGSizeMake(181.0, 250.0);
  attributes.center = CGPointMake(self.collectionView.frame.size.width / 2.0, self.collectionView.frame.size.height / 2.0);
  
  double r = arc4random_uniform(51);
  r -= 25;
  r /= 100;
  
  NSLog(@"r: %f", r);
  
  attributes.transform3D = CATransform3DMakeRotation(r, 0., 0., 1.);
  
  return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
  for (int i = 0; i < _cellCount; i++) {
    NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
    [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:ip]];
  }
  return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
  if ([_insertedItems containsObject:itemIndexPath]) {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    attributes.center = _initialStartingPoint;
    return attributes;
  } else {
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
  }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
  
  
  UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
  
  NSLog(@"final layout attributes for disappearing item: %@", itemIndexPath);
  
  if ([_deletedItems containsObject:itemIndexPath]) {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    
    attributes.center = _finalDestination;
    NSLog(@"final layout attributes for disappearing item -- DELETE: %@", NSStringFromCGPoint(attributes.center));
    return attributes;
  } else {
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
  }
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
  [super prepareForCollectionViewUpdates:updateItems];
  
  
  for (UICollectionViewUpdateItem *updateItem in updateItems) {
    NSLog(@"updateItem: %@", updateItem);
    
    if (updateItem.updateAction == UICollectionUpdateActionDelete) {
      NSLog(@"prepare for collection view updates -- DELETE: %@", updateItem.indexPathBeforeUpdate);
      
      [_deletedItems addObject:updateItem.indexPathBeforeUpdate];
    }
    else if (updateItem.updateAction == UICollectionUpdateActionInsert) {
      [_insertedItems addObject:updateItem.indexPathAfterUpdate];
      [CATransaction setCompletionBlock:^{
        PLKClutteredCell *cell = (PLKClutteredCell *)[self.collectionView cellForItemAtIndexPath:updateItem.indexPathAfterUpdate];
        NSLog(@"animation finished. %@", cell);
        [cell shadowize];
      }];
    }
  }
  
}

- (void)finalizeCollectionViewUpdates
{
  
  //  NSMutableArray *ma = [NSMutableArray array];
  //  for (NSIndexPath *ip in _insertedItems) {
  //    [ma addObject:cell];
  //  }
  //
  NSLog(@"finalize!");
  //  [CATransaction setCompletionBlock:^{
  //    for (PLKClutteredCell *c in ma) {
  ////      [c shadowize];
  //      NSLog(@"animation finished.");
  //    }
  //  }];
  
  [_insertedItems removeAllObjects];
  [_deletedItems removeAllObjects];
}

#pragma mark - Private

- (void)setupGestures
{
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(handlePan:)];
  panGestureRecognizer.delegate = self;
  [self.collectionView addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)pgr
{
  CGPoint initialPoint;
  static UICollectionViewCell *cell = nil;
  static ClutteredSwipeDirection swipeDirection;
  if (pgr.state == UIGestureRecognizerStateBegan) {
    
    initialPoint = [pgr locationInView:self.collectionView];
    _selectedIndexPath = [self.collectionView indexPathForItemAtPoint:initialPoint];
    cell = [self.collectionView cellForItemAtIndexPath:_selectedIndexPath];
    swipeDirection = (!CGRectContainsPoint(_threshold, initialPoint)) ? ClutteredSwipeIn : ClutteredSwipeOut;
    
  }
  
  if (_selectedIndexPath.row == [self.collectionView numberOfItemsInSection:0] - 1) {
    
    CGPoint t = [pgr translationInView:self.collectionView];
    cell.center = CGPointMake(cell.center.x + t.x, cell.center.y + t.y);
    [pgr setTranslation:CGPointZero
                 inView:self.collectionView];
    
  }
  
  if (pgr.state == UIGestureRecognizerStateEnded) {
    
    CGPoint v = [pgr velocityInView:self.collectionView];
    NSLog(@"v: %@", NSStringFromCGPoint(v));
    id<PLKClutteredDelegateLayout> delegate = (id<PLKClutteredDelegateLayout>)self.collectionView.delegate;
    
    if (swipeDirection == ClutteredSwipeOut) {
      
      float m = sqrtf((v.x * v.x) + (v.y * v.y));
      NSLog(@"m: %f", m);
      
      //      _finalDestination = self.collectionView.center;
      self.finalDestination = self.collectionView.center;
      
      if (m > 1000) {
        
        //        _finalDestination = CGPointMake(v.x - self.collectionView.center.x, v.y - self.collectionView.center.y);
        self.finalDestination = CGPointMake(v.x - self.collectionView.center.x, v.y - self.collectionView.center.y);
        
        if (_selectedIndexPath) {
          [delegate collectionView:self.collectionView itemAtIndexPathThrownOut:_selectedIndexPath];
        }
        
      } else {
        [UIView animateWithDuration:0.35
                         animations:^{
                           cell.center = _finalDestination;
                         }];
      }
      
    } else {
      
      
      
      float m = sqrtf((v.x * v.x) + (v.y * v.y));
      NSLog(@"m: %f", m);
      
      if (m > 1000) {
        
        float x = (v.x * -1) / 2;
        float y = (v.y * -1) / 2;
        NSLog(@"x: %f, y: %f", x, y);
        _initialStartingPoint = CGPointMake(x, y);
        [delegate swipeIn];
        
      }
      
    }
    
  }
}

@end
