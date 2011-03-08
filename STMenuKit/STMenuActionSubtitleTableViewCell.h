//
//  STMenuFormLabelTableViewCell.h
//  STMenuKit
//
//  Created by Jason Gregori on 12/15/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMenuTableViewCell.h"

@interface STMenuActionSubtitleTableViewCell : STMenuTableViewCell {
    NSString *_imageName;
    NSString *_actionSelectorName;
}

@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *actionSelectorName;

@end
