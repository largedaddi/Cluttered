//
//  CListItemCell.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/6/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CListItemCell.h"
#import <QuartzCore/QuartzCore.h>

#define SLASH_PADDING 20.0

@implementation CListItemCell {
  CAShapeLayer *_slash;
  CGPoint _slashStartingPoint;
  CGPoint _slashEndingPoint;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    NSLog(@"initwith style");
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    NSLog(@"initWithCoder");
    [self commonInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    NSLog(@"initWithFrame");
    [self commonInit];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  
}

#pragma mark - Public

- (BOOL)startSlashAtPoint:(CGPoint)p
{
  if (p.x > self.frame.size.width / 3) {
    NSLog(@"not slashing");
    return NO;
  }
  
  if (!_slash) {
    [self initSlash];
  } else {
    [self resetSlash];
  }
  
  NSLog(@"_slashStartingPoint: %@", NSStringFromCGPoint(_slashStartingPoint));
  UIBezierPath *slashPath = [UIBezierPath bezierPath];
  [slashPath moveToPoint:_slashStartingPoint];
  
  if (p.x > _slashStartingPoint.x) {
    CGPoint current = CGPointMake(p.x, _slashStartingPoint.y);
    [slashPath addLineToPoint:current];
  }
  
  _slash.path = slashPath.CGPath;
  return YES;
}

- (void)drawSlashWithTranslation:(CGPoint)t
{
  UIBezierPath *slashPath = [UIBezierPath bezierPathWithCGPath:_slash.path];
  CGPoint p = CGPointMake(slashPath.currentPoint.x + t.x,
                          _slashStartingPoint.y);
  
  if (p.x > _slashStartingPoint.x &&
      p.x < _slashEndingPoint.x)
  {
    if (t.x > 0.0) {
      [slashPath addLineToPoint:p];
      _slash.path = slashPath.CGPath;
    }
    else if (t.x < 0.0) {
      [slashPath removeAllPoints];
      [slashPath moveToPoint:_slashStartingPoint];
      [slashPath addLineToPoint:p];
      _slash.path = slashPath.CGPath;
    }
  }
}

- (void)endSlashAtPoint:(CGPoint)p withMagnitude:(CGFloat)m
{
  CABasicAnimation *slashimation = [CABasicAnimation animationWithKeyPath:@"path"];
  slashimation.duration = 0.25;
  slashimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  slashimation.fromValue = (id)_slash.path;
  UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_slash.path];
  if (m > 800.0) {
    [path addLineToPoint:_slashEndingPoint];
    _slash.path = path.CGPath;
  }
  else {
    [path removeAllPoints];
    _slash.path = path.CGPath;
    [path moveToPoint:_slashStartingPoint];
    [path addLineToPoint:CGPointMake(_slashStartingPoint.x + 0.0, _slashStartingPoint.y)];
  }
  slashimation.toValue = (id)path.CGPath;
  
  [_slash addAnimation:slashimation
                forKey:@"pathAnimation"];
}

#pragma mark - Private

- (void)commonInit
{
  float y = self.frame.size.height / 2.0;
  _slashStartingPoint = CGPointMake(SLASH_PADDING, y);
  _slashEndingPoint = CGPointMake(self.frame.size.width - SLASH_PADDING, y);
}

- (void)initSlash
{
  _slash = [CAShapeLayer layer];
  _slash.lineCap = kCALineCapRound;
  _slash.lineWidth = 3.0;
  _slash.strokeColor = [UIColor redColor].CGColor;
  [self.contentView.layer addSublayer:_slash];
}

- (void)resetSlash
{
  _slash.path = NULL;
}

@end

