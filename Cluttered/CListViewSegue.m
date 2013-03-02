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
  
  
  
  UIImageView *transitionImageView = [[UIImageView alloc] initWithFrame:cell.preview.bounds];
  transitionImageView.center = cell.center;
  
  
  
  transitionImageView.image = cell.preview.image;
  
  transitionImageView.layer.transform = la.transform3D;
  transitionImageView.layer.shouldRasterize = YES;
  
  [self shadowize:transitionImageView];
  
  [sourceViewController.collectionView addSubview:transitionImageView];
  
  cell.hidden = YES;
  
  
  
  [UIView animateWithDuration:0.75 delay:1.50 options:UIViewAnimationCurveEaseOut
                   animations:^{
                     
                     //                     [self unshadowize:transitionImageView];
                     
                     transitionImageView.layer.transform = CATransform3DIdentity;
                     
                     
                   } completion:^(BOOL finished) {
                     
                     [UIView animateWithDuration:0.75
                                      animations:^{
                                        
                                        CGRect newBounds = cell.bounds;
                                        newBounds.size = destinationViewController.view.bounds.size;
                                        transitionImageView.bounds = newBounds;
                                        
                                      } completion:^(BOOL finished) {
                                        
                                        [transitionImageView removeFromSuperview];
                                        [self.sourceViewController presentViewController:self.destinationViewController
                                                                                animated:NO
                                                                              completion:^{
                                                                                cell.hidden = NO;
                                                                              }];
                                        
                                      }];
                   }];
}

- (void)shadowize:(UIView *)v
{
  v.layer.shadowOffset = CGSizeMake(0, 0);
  v.layer.shadowRadius = 5.0;
  v.layer.shadowColor = [UIColor blackColor].CGColor;
  v.layer.shadowOpacity = 0.5;
}

- (void)unshadowize:(UIView *)v
{
  v.layer.shadowOffset = CGSizeMake(0, 0);
  v.layer.shadowRadius = 0.0;
  v.layer.shadowColor = [UIColor blackColor].CGColor;
  v.layer.shadowOpacity = 0.0;
}


@end
