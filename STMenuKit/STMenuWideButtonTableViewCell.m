//
//  STMenuFormWideButtonTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/15/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuWideButtonTableViewCell.h"


@implementation STMenuWideButtonTableViewCell

@synthesize background = _background, notification = _notification, button = _button, prompt = _prompt;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]))
    {
        self.backgroundColor = [UIColor clearColor];

        CGRect frame = self.contentView.bounds;
        frame.size.width = frame.size.width - 20;
        UIButton *cellButton = [[UIButton alloc] initWithFrame:frame];
        [cellButton addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        cellButton.hidden = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:cellButton];
        self.button = cellButton;
        [cellButton release];
    }
    return self;
}

- (void)setBackground:(id)newBackground {
    [newBackground retain];
    [_background release];
    _background = newBackground;
    UIImage *theImage = [[UIImage imageNamed:_background] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [_button setBackgroundImage:theImage forState:UIControlStateNormal];
}

- (void)setPrompt:(id)newPrompt {
    [newPrompt retain];
    [_prompt release];
    _prompt = newPrompt;
    [_button setTitle:_prompt forState:UIControlStateNormal];
}

- (void)setValue:(id)newValue {
    [newValue retain];
    [_value release];
    _value = newValue;
}

- (void)setTitle:(NSString *)title {
    
}

- (void)clicked {
    // Somehow get a reference to the object that has the Reminder object
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:_value forKey:@"value"]];
}

@end
