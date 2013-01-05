//
//  PLKClutteredLayout.h
//  Cluttered
//
//  Created by Sean Pilkenton on 11/18/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLKClutteredLayout : UICollectionViewLayout
- (id)init;
- (void)awakeFromNib;
@end

@protocol PLKClutteredDelegateLayout <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPathThrownOut:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPathPulledIn:(NSIndexPath *)indexPath;
- (void)swipeIn;
@end
