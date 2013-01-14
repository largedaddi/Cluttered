//
//  CAuthoringUnwindSegue.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/13/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CAuthoringUnwindSegue.h"

@implementation CAuthoringUnwindSegue

- (void)perform
{
  [self.destinationViewController dismissViewControllerAnimated:NO
                                                     completion:nil];
}

@end
