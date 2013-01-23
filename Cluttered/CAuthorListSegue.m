//
//  CAuthorListSegue.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/13/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CAuthorListSegue.h"
#import "CAddListViewController.h"

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
  NSLog(@"destinationView.center: %@", NSStringFromCGPoint(destinationView.center));
  
//  destinationView.frame = sourceView.bounds;
  
//  destinationView.frame = CGRectMake(sourceView.bounds.origin.x,
//                                     sourceView.bounds.origin.y - sourceView.bounds.size.height,
//                                     sourceView.bounds.size.width,
//                                     sourceView.bounds.size.height);
  
//  destinationView.frame = CGRectMake(destinationView.bounds.origin.x,
//                                     destinationView.bounds.origin.y - sourceView.bounds.size.height,
//                                     destinationView.bounds.size.width,
//                                     destinationView.bounds.size.height);
  
  destinationView.center = CGPointMake(sourceView.bounds.size.width / 2,
                                       -sourceView.bounds.size.height / 2);
  
  
//  destinationView.center = CGPointMake(destinationView.center.x,
//                                       destinationView.center.y - destinationView.bounds.size.height);
  [sourceView addSubview:destinationView];
  
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationCurveEaseOut
                   animations:^{
//                     destinationView.center = sourceView.center;
                     destinationView.center = CGPointMake(sourceView.center.x, sourceView.center.y - 20.0);
                   } completion:^(BOOL finished) {
                     [destinationView removeFromSuperview];
                     [source presentViewController:destination animated:NO completion:nil];
                     NSLog(@"destinationViewControler.view: %@", destination.view);
                     [((CAddListViewController *)destination).authoringTextView becomeFirstResponder];
                     
            NSLog(@"destinationView.center: %@", NSStringFromCGPoint(destination.view.center));
                     
                   }];
  
}

@end

