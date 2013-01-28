//
//  CAuthorListSegue.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/13/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CAuthorListSegue.h"
#import "CAuthorListViewController.h"

@implementation CAuthorListSegue

- (void)perform
{
  UIViewController *source = self.sourceViewController;
  UIViewController *destination = self.destinationViewController;
  
  UIView *sourceView = source.view;
  NSLog(@"sourceView: %@", sourceView);
  NSLog(@"sourceView.center: %@", NSStringFromCGPoint(sourceView.center));
  
  UIView *destinationView = destination.view;
  NSLog(@"destinationView: %@", destinationView);
  NSLog(@"destinationView: %@", NSStringFromClass([destinationView class]));
  NSLog(@"destinationView.center: %@", NSStringFromCGPoint(destinationView.center));
  
  destinationView.center = CGPointMake(destinationView.center.x,
                                       destinationView.center.y - destinationView.bounds.size.height);
  
  [sourceView addSubview:destinationView];
  
  [UIView animateWithDuration:0.75
                        delay:0.0
                      options:UIViewAnimationCurveEaseOut
                   animations:^{
//                     destinationView.center = sourceView.center;
                     destinationView.center = CGPointMake(sourceView.center.x, sourceView.center.y - 20.0);
//                     destinationView.center = CGPointMake(sourceView.center.x, sourceView.center.y);
                   } completion:^(BOOL finished) {
                     [destinationView removeFromSuperview];
                     [source presentViewController:destination animated:NO completion:nil];
                     NSLog(@"destinationViewControler.view: %@", destination.view);
                     
                     [((CAuthorListViewController *)destination).authoringTextView becomeFirstResponder];
                     
            NSLog(@"destinationView.center: %@", NSStringFromCGPoint(destination.view.center));
                     
                     [((CAuthorListViewController *)destination) insertCancelAndSave];
                     
                   }];
  
}

@end

