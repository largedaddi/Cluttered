//
//  CListItemCell.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/6/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CListItemCell.h"

#define SLASH_PADDING 20.0

static CGPoint midpoint(CGPoint start, CGPoint end);
static void makeItSo(UIBezierPath *path);

@implementation CListItemCell {
  UIBezierPath *_slashPath;
  CGPoint _slashStartingPoint;
  CGPoint _slashEndingPoint;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (BOOL)startSlashAtPoint:(CGPoint)p
{
  if (p.x > self.frame.size.width / 3) {
    return NO;
  }
  
  if (!_slashPath) {
    [self initSlashPath];
  }
  
  [_slashPath moveToPoint:_slashStartingPoint];
  
  if (p.x > _slashStartingPoint.x) {
    [_slashPath addLineToPoint:p];
    
  }
  
  makeItSo(_slashPath);
  return YES;
}

- (void)drawSlashWithTranslation:(CGPoint)p
{
  CGPoint t = CGPointMake(_slashStartingPoint.x + p.x, self.frame.size.height / 2.0);
  [_slashPath addLineToPoint:t];
  makeItSo(_slashPath);
}

- (void)endSlashAtPoint:(CGPoint)p withMagnitude:(CGFloat)m
{
  
  makeItSo(_slashPath);
}

#pragma mark - Private

- (void)commonInit
{
  float y = self.frame.size.height / 2.0;
  _slashStartingPoint = CGPointMake(SLASH_PADDING, y);
  _slashEndingPoint = CGPointMake(self.frame.size.width - SLASH_PADDING, y);
}

- (void)initSlashPath
{
  _slashPath = [UIBezierPath bezierPath];
  [_slashPath setLineWidth:3.0];
  [_slashPath setLineCapStyle:kCGLineCapRound];
}

@end

CGPoint midpoint(CGPoint start, CGPoint end) {
  return CGPointMake((start.x + end.x) / 2.0, (start.y + end.y) / 2.0);
}

void makeItSo(UIBezierPath *path) {
  [[UIColor redColor] setStroke];
  [path stroke];
}
