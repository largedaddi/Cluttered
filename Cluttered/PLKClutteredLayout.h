//
//  PLKClutteredLayout.h
//  Cluttered
//
//  Created by Sean Pilkenton on 11/18/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLKClutteredDelegateLayout <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPathThrownOut:(NSIndexPath *)indexPath;
- (void)swipeIn;
@end

@interface PLKClutteredLayout : UICollectionViewLayout
- (id)init;
@property (nonatomic, assign) CGPoint finalDestination;
@end
