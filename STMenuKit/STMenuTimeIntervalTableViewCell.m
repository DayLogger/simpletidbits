//
//  STMenuTimeIntervalTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/15/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuTimeIntervalTableViewCell.h"


@implementation STMenuTimeIntervalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
