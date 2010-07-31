//
//  STMenuFormattedTableViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 11/12/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuFormattedTableViewController.h"
#import "STMenuMaker.h"
#import "STMenuFormattedSectionController.h"
#import "STMenuTableViewCell.h"
#import "STMenuBasicSectionController.h"

@interface STMenuFormattedTableViewController ()

@property (nonatomic, retain) NSArray           *st_sections;
@property (nonatomic, assign) NSUInteger        st_subMenuSection;

@end


@implementation STMenuFormattedTableViewController
@synthesize st_sections = _sections, st_subMenuSection = _subMenuSection;

- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and
    // want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style])
    {
        self.st_subMenuSection  = NSNotFound;
    }
    return self;
}

- (void)dealloc
{
    [_sections release];
    
    [super dealloc];
}

- (void)st_pushMenu:(UIViewController <STMenuProtocol> *)subMenu
         forSection:(NSUInteger)section
{
    self.st_subMenuSection  = section;
    [self st_pushMenu:subMenu];
}

- (NSArray *)st_sections
{
    if (!_sections)
    {
        // create sections
        NSUInteger i, count = [self.st_schema count];
        NSMutableArray  *sections   = [[NSMutableArray alloc]
                                       initWithCapacity:count];
        for (i = 0; i < count; i++)
        {
            STMenuFormattedSectionController    *section
              = [STMenuMaker makeInstanceFromData:
                 [self.st_schema objectAtIndex:i]
                                         useCache:nil
                                      propertyKey:nil
                                   useClassPrefix:@"STMenu"
                                           suffix:@"SectionController"
                                     defaultClass:[self
                                                   st_defaultSectionClass]];
            section.menu    = self;
            section.section = i;
            [sections addObject:section];
        }
        _sections   = sections;
    }
    return _sections;
}

- (Class)st_defaultSectionClass
{
    return NULL;
}

#pragma mark STMenuBaseTableViewController

- (void)st_saveValue:(id)value forSubMenuKey:(NSString *)key
{
    if (self.st_subMenuSection != NSNotFound)
    {
        STMenuFormattedSectionController    *section
          = [self.st_sections objectAtIndex:self.st_subMenuSection];
        [section saveValue:value forSubMenuKey:key];
        self.st_subMenuSection  = NSNotFound;
    }
    else
    {
        [self.value setValue:value forKeyPath:key];
    }
}

- (void)st_cancelForSubMenuKey:(NSString *)key
{
    if (self.st_subMenuSection != NSNotFound)
    {
        STMenuFormattedSectionController    *section
          = [self.st_sections objectAtIndex:self.st_subMenuSection];
        [section cancelForSubMenuKey:key];
        self.st_subMenuSection  = NSNotFound;
    }
}

#pragma mark STMenuProtocol

- (void)setPlist:(id)plist andValue:(id)value
{
    [super setPlist:plist];
    self.st_sections    = nil;
    [self setValue:value];
    if ([self isViewLoaded])
    {
        [self.tableView reloadData];
    }
}

- (void)setPlist:(id)plist
{
    if (![self.plist isEqual:plist])
    {
        // we only need to change any stuff if the plist changed
        [super setPlist:plist];
        self.st_sections    = nil;
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

- (void)setValue:(id)newValue
{
    if (self.value != newValue)
    {
        // we only need to reset this stuff it the value changed
        // we can't do isEqual: because we use KVO on it
        [super setValue:newValue];
        [self.st_sections
         makeObjectsPerformSelector:@selector(menuValueDidChange:)
         withObject:newValue];
        if ([self isViewLoaded])
        {
            [self.tableView reloadData];
        }
    }
}

#pragma mark UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self.tableView beginUpdates];
    
    [super setEditing:editing animated:animated];
    
    for (STMenuFormattedSectionController *section in self.st_sections)
    {
        [section setEditing:editing animated:animated];
    }
    
    [self.tableView endUpdates];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.st_schema count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString([[self.st_sections objectAtIndex:section]
            footer], nil);
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString([[self.st_sections objectAtIndex:section]
            title], nil);
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.st_sections objectAtIndex:section]
            numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.st_sections objectAtIndex:indexPath.section]
            heightForRow:indexPath.row];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.st_sections objectAtIndex:indexPath.section]
            cellForRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // let the cell know it was selected
    [((STMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath])
     cellWasSelected];

    // tell the section controller whats up
    [[self.st_sections objectAtIndex:indexPath.section]
     didSelectRow:indexPath.row];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.st_sections objectAtIndex:indexPath.section]
            canEditRow:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.st_sections objectAtIndex:indexPath.section]
            shouldIndentWhileEditingRow:indexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.st_sections objectAtIndex:indexPath.section]
            editingStyleForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.st_sections objectAtIndex:indexPath.section]
     commitEditingStyle:editingStyle
     forRow:indexPath.row];
}


@end

