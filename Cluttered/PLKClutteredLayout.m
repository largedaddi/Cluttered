//
//  PLKClutteredLayout.m
//  Cluttered
//
//  Created by Sean Pilkenton on 11/18/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "PLKClutteredLayout.h"
#import <QuartzCore/QuartzCore.h>

#define RANDOM_MAX 0x100000000

@implementation PLKClutteredLayout {
  NSInteger _cellCount;
}

- (void)prepareLayout {
  [super prepareLayout];
  _cellCount = [self.collectionView numberOfItemsInSection:0];
}

- (CGSize)collectionViewContentSize {
  NSLog(@"collectionViewContentSize: %@", self.collectionView);
  
  return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
  double rotation = floorf(((double)arc4random() / RANDOM_MAX) * 100.0f);
//  attribute.transform3D = CATransform3DMakeRotation(rotation, 1.0f, 0.0f, 0.0f);
  attribute.transform3D = CATransform3DMakeRotation(1.0f, 1.0f, 0.0f, 0.0f);
  
  NSLog(@"la for item at index path: %@", attribute);
  
  return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
  for (int i = 0; i < _cellCount; i++) {
    NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
    [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:ip]];
  }
  NSLog(@"layoutAttributes: %@", layoutAttributes);
  return layoutAttributes;
}

//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//  
//}

//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//  
//}

@end
