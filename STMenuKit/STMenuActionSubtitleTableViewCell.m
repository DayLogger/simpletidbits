//
//  STMenuFormLabelTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/15/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuActionSubtitleTableViewCell.h"


@implementation STMenuActionSubtitleTableViewCell

@synthesize imageName = _imageName, actionSelectorName = _actionSelectorName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumFontSize = 12;
        self.detailTextLabel.font = [UIFont italicSystemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        self.detailTextLabel.minimumFontSize = 10;
        self.indentationWidth = 8;
        self.indentationLevel = 1;
    }
    return self;
}

- (void)setImageName:(NSString *)name {
    [name retain];
    [_imageName release];
    _imageName = name;
    
    self.imageView.image = [UIImage imageNamed:name];
}

- (void)setAccessoryTypeNumber:(NSNumber *)typeNumber {
    if ([typeNumber intValue] == 1) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)cellWasSelected {
    if ([_menu respondsToSelector:NSSelectorFromString(_actionSelectorName)]) {
        [_menu performSelector:NSSelectorFromString(_actionSelectorName)];
    }
    [self setSelected:NO animated:YES];
}


@end
