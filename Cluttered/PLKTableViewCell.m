//
//  PLKTableViewCell.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/8/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "PLKTableViewCell.h"

@implementation PLKTableViewCell

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

@end
