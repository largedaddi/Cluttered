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

@implementation CListViewSegue

- (void)perform
{
  CViewController *sourceViewController = (CViewController *)self.sourceViewController;
  CListViewController *destinationViewController = (CListViewController *)self.destinationViewController;
  PLKClutteredCell *cell = (PLKClutteredCell *)[sourceViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  
  NSLog(@"cell: %@", cell);
  
  [UIView animateWithDuration:0.75 delay:0.0 options:UIViewAnimationCurveEaseOut
                   animations:^{
                     CGAffineTransform rotate = CGAffineTransformMakeRotation(1);
                     cell.preview.transform = rotate;
                     CGRect newBounds = cell.bounds;
                     newBounds.size = destinationViewController.view.bounds.size;
                     cell.bounds = newBounds;
                   } completion:^(BOOL finished) {
                     [self.sourceViewController presentViewController:self.destinationViewController
                                                             animated:NO
                                                           completion:^{
                                                             
                                                           }];
                   }];
}

@end
