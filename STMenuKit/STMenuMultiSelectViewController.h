//
//  STMenuMultiSelectViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuSubMenuTableViewController.h"

/*
 
 STMenuMultiSelectViewController
 --------------------------
 
 This is a Select Menu.
 
 It is simply a list of items that the user may choose from.
 
 plist
 -----
 { // dictionary
    "labels"   =>  
        {
            key => <label>
        }
 }
 
 TODO: Multi Select
 
 */

@interface STMenuMultiSelectViewController : STMenuSubMenuTableViewController
{
  @protected
    id                      _defaultValue;
    NSDictionary            *_labels;
    NSMutableDictionary     *_selectedRows;
}

// This is the value to show when value is not in values or is nil, optional.
@property (nonatomic, retain)   id              defaultValue;

@end
