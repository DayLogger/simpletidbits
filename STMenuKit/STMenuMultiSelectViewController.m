//
//  STMenuMultiSelectViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 1/17/10.
//  Copyright 2010 Jason Gregori. All rights reserved.
//

#import "STMenuMultiSelectViewController.h"

@interface STMenuMultiSelectViewController ()

@property (nonatomic, retain)   NSDictionary        *st_labels;
@property (nonatomic, retain)   NSMutableDictionary *st_selectedRows;

- (void)st_resetSubValue;

@end

@implementation STMenuMultiSelectViewController
@synthesize defaultValue = _defaultValue, st_labels = _labels, st_selectedRows = _selectedRows;

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)dealloc
{
    [_defaultValue release];
    [_labels release];
    [_selectedRows release];
    
    [super dealloc];
}

- (void)st_resetSubValue
{
//    // take checkmark away from old guy
//    if (self.st_selectedRow)
//    {
//        [[self.tableView cellForRowAtIndexPath:self.st_selectedRow]
//         setAccessoryType:UITableViewCellAccessoryNone];
//    }
//    
//    NSUInteger  row;
//    self.st_selectedRow        = nil;
//    NSUInteger section, count = [self.st_values count];
//    for (section = 0; section < count; section++)
//    {
//        NSArray     *rows   = [self.st_values objectAtIndex:section];
//        row         = [rows indexOfObject:self.subValue];
//        if (row != NSNotFound)
//        {
//            self.st_selectedRow    = [NSIndexPath indexPathForRow:row
//                                                        inSection:section];
//            break;
//        }
//    }
//    
//    if (self.st_selectedRow)
//    {
//        // set checkmark for new cell
//        [[self.tableView cellForRowAtIndexPath:self.st_selectedRow]
//         setAccessoryType:UITableViewCellAccessoryCheckmark];
//    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.st_labels allKeys] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    STMenuTableViewCell *cell   = [self st_cellWithCellData:nil
                                                        key:self.key];

    NSArray *keys = [[self.st_labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id valuesKey = [keys objectAtIndex:indexPath.row];
    [cell setTitle:[[self.st_labels objectForKey:valuesKey] description]];
    BOOL isChecked = [(NSNumber *)[self.st_selectedRows objectForKey:valuesKey] boolValue];
	
    // checkmark
    if (isChecked)
    {
        cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [[self.st_labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id valuesKey = [keys objectAtIndex:indexPath.row];
    BOOL isChecked = ![(NSNumber *)[self.st_selectedRows objectForKey:valuesKey] boolValue];
    [self.st_selectedRows setObject:[NSNumber numberWithBool:isChecked] forKey:valuesKey];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // checkmark
    if (isChecked)
    {
        cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    // set sub value (setting it will also checkmark the cell)
    self.subValue   = [self.st_selectedRows copy];
    
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark STMenuSubMenuTableViewController

- (void)setSubValue:(id)subValue
{
    if (![self.subValue isEqual:subValue])
    {
        [super setSubValue:subValue];
        
        if ([self isViewLoaded])
        {
            [self st_resetSubValue];
        }
    }
}

#pragma mark STMenuProtocol

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
}

- (void)setSt_schema:(id)schema
{
    if (schema)
    {
        NSAssert([schema isKindOfClass:[NSDictionary class]],
                 @"MultiSelect Menu plist must be a dictionary!");

        NSDictionary     *labels    = [schema valueForKey:@"labels"];
        
        NSAssert([labels isKindOfClass:[NSDictionary class]],
                 @"MultiSelect Menu plist must have a dictionary value for the "
                 @"\"labels\" key");
        
        self.st_labels = labels;
        self.st_selectedRows = [NSMutableDictionary dictionary];
    }
    else
    {
        self.st_labels = nil;
    }

    if ([self isViewLoaded])
    {
        [self.tableView reloadData];
    }
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.st_selectedRows = [NSMutableDictionary dictionaryWithDictionary:self.subValue];
    
    NSArray *keys = [[self.st_labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
    int i = 0;
    for (NSNumber *valuesKey in keys) {
        BOOL isChecked = [(NSNumber *)[self.st_selectedRows objectForKey:valuesKey] boolValue];

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = isChecked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        i++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.contentOffset    = CGPointMake(0,0);
}

@end
