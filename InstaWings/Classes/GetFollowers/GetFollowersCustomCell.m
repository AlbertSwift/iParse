//
//  GetFollowersCustomCell.m
//  InstaWings
//
//  Created by Tops on 9/15/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "GetFollowersCustomCell.h"

@implementation GetFollowersCustomCell

- (void)awakeFromNib {
    // Initialization code
    if (g_IS_IPHONE_4_SCREEN) {
        self.lblTitle.font =CustomFontMediumWithSize(13);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
