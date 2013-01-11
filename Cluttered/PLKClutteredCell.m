//
//  PLKClutteredListCell.m
//  Cluttered
//
//  Created by Sean Pilkenton on 11/26/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "PLKClutteredCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PLKClutteredCell ()
- (void)commonInit;
@end

@implementation PLKClutteredCell

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
}

#pragma mark - Private

- (void)commonInit
{
//  self.contentView.layer.cornerRadius = 5.0;
  self.layer.masksToBounds = NO;
  self.layer.shadowOffset = CGSizeMake(0, 0);
  self.layer.shadowRadius = 5.0;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.5;
  
  self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
  
//  self.layer.borderWidth = 1.0;
//  self.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.layer.opaque = YES;
  self.layer.shouldRasterize = YES;
  
//  self.contentView.layer.borderWidth = 1.0f;
//  self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
  self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
