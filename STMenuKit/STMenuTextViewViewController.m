//
//  STMenuTextFieldViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/19/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuTextViewViewController.h"

@implementation STMenuTextViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        [super setCell:
         [NSDictionary dictionaryWithObjectsAndKeys:
          @"TextView", @"class",
          [NSNumber numberWithBool:NO], @"deselectOnReturn",
          @"sentences", @"autocapitalizationType",
          nil]];
    }
    return self;
}

- (void)setCell:(id)cell
{
    // dont let user override cell
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165.0;
}


#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // center the cell (height - keyboard - cell height)/2 - cell header margin
    self.tableView.contentInset
      = UIEdgeInsetsMake((self.tableView.frame.size.height - 216 - 165)/2.0 - 10,
                         0, 0, 0);
}

@end

