//
//  CAuthorListSegue.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/13/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CAuthorListSegue.h"

@implementation CAuthorListSegue

- (void)perform
{
  UIViewController *source = self.sourceViewController;
  UIViewController *destination = self.destinationViewController;
  [source presentViewController:destination animated:NO completion:nil];
}

@end

