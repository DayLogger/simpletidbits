//
//  STMenuFormWideButtonTableViewCell.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/15/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMenuTableViewCell.h"

/*
 A cell that doesn't allow any interaction
 */

@interface STMenuWideButtonTableViewCell : STMenuTableViewCell {
    id _background;
    id _notification;
    id _prompt;
    id _value;
    UIButton *_button;
}

@property (nonatomic, retain)   id          background;
@property (nonatomic, retain)   id          notification;
@property (nonatomic, retain)   id          prompt;

@property (nonatomic, retain)   UIButton    *button;

@end
