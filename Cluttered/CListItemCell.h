//
//  CListItemCell.h
//  Cluttered
//
//  Created by Sean Pilkenton on 1/6/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CListItemCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;

- (BOOL)startSlashAtPoint:(CGPoint)p;
- (void)drawSlashWithTranslation:(CGPoint)t;
- (void)endSlashAtPoint:(CGPoint)p
          withMagnitude:(CGFloat)m;

@end
