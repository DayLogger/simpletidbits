//
//  STMenuEditViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/1/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuEditViewController.h"
#import "STMenuEditTableViewCell.h"
#import "STMenuBasicSectionController.h"


@implementation STMenuEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.navigationItem.rightBarButtonItem  = self.editButtonItem;
        self.hidesBottomBarWhenPushed   = YES;
    }
    return self;
}

- (void)save
{
    [self stopEditing];
}

- (void)stopEditing
{
    [super setEditing:NO animated:YES];
    
    // hide the back button when editing
    [self.navigationItem setHidesBackButton:NO animated:YES];    
}

#pragma mark STMenuFormattedTableViewController

- (Class)st_defaultSectionClass
{
    return [STMenuBasicSectionController class];
}

#pragma mark STMenuBaseTableViewController

- (Class)st_defaultCellClass
{
    return [STMenuEditTableViewCell class];
}

- (NSString *)st_customCellPrefix
{
    return @"STMenuEdit";
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsSelection  = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (!editing)
    {
        if ([self.delegate
             respondsToSelector:@selector(editMenu:shouldSaveItem:)])
        {
            if (![self.delegate editMenu:self shouldSaveItem:self.value])
            {
                return;
            }
        }
    }
    [super setEditing:editing animated:animated];
    
    // hide the back button when editing
    [self.navigationItem setHidesBackButton:editing animated:animated];
}

@end
