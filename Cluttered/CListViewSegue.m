//
//  CListViewSegue.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/13/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CListViewSegue.h"
#import "CViewController.h"
#import "CListViewController.h"
#import "PLKClutteredCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CListViewSegue

- (void)perform
{
  CViewController *sourceViewController = (CViewController *)self.sourceViewController;
  CListViewController *destinationViewController = (CListViewController *)self.destinationViewController;
  PLKClutteredCell *cell = (PLKClutteredCell *)[sourceViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  
  UICollectionViewLayoutAttributes *la = [sourceViewController.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  
  
  
  
  NSLog(@"cell: %@", cell);
  
  if (!cell.preview) {
    NSLog(@"NO PREVIEW!!!");
  }
  
  UIImageView *transitionImageView = [[UIImageView alloc] initWithFrame:cell.frame];
  transitionImageView.image = cell.preview.image;
  [sourceViewController.collectionView addSubview:transitionImageView];
  
  transitionImageView.layer.transform = CATransform3DIdentity;
  
  [UIView animateWithDuration:0.75 delay:0.50 options:UIViewAnimationCurveEaseOut
                   animations:^{
                     
                     CGRect newBounds = cell.bounds;
                     newBounds.size = destinationViewController.view.bounds.size;
                     transitionImageView.bounds = newBounds;
                   } completion:^(BOOL finished) {
                     [transitionImageView removeFromSuperview];
                     [self.sourceViewController presentViewController:self.destinationViewController
                                                             animated:NO
                                                           completion:^{
                                                           }];
                   }];
}

@end
