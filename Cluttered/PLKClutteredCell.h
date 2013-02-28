//
//  PLKClutteredListCell.h
//  Cluttered
//
//  Created by Sean Pilkenton on 11/26/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLKClutteredCell : UICollectionViewCell

- (void)shadowize;
- (void)unshadowize;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *preview;
@property (nonatomic, assign) CGFloat rotation;

@end
