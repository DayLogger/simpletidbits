//
//  STMenuListSectionController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/28/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuListSectionController.h"

@interface STMenuListSectionController ()

@property (nonatomic, assign)   BOOL        st_showingAddCell;
@property (nonatomic, retain)   id          st_currentlyShowingItem;

@end


@implementation STMenuListSectionController
@synthesize st_list     = _list;
@synthesize sortDescriptors     = _sortDescriptors;
@synthesize itemMenu    = _itemMenu;
@synthesize itemTitle   = _itemTitle;
@synthesize key         = _key;
@synthesize cell        = _cell;
@synthesize addTitle    = _addTitle;
@synthesize addCell     = _addCell;
@synthesize blankItem   = _blankItem;
@synthesize maxItems    = _maxItems;
@synthesize editable    = _editable;
@synthesize st_showingAddCell   = _showingAddCell;
@synthesize st_currentlyShowingItem = _currentlyShowingItem;

- (void)dealloc
{
    [_list release];
    [_sortDescriptors release];
    [_itemMenu release];
    [_itemTitle release];
    [_key release];
    [_cell release];
    [_addTitle release];
    [_addCell release];
    [_blankItem release];
    [_maxItems release];
    [_editable release];    
    
    [_currentlyShowingItem release];
    
    [super dealloc];
}

- (void)st_checkIfWeShouldShowAddCell:(BOOL)animated
{
    if (self.st_showingAddCell &&
        (!self.editing
         || ![self.editable boolValue]
         || (self.maxItems
             && [self.st_list count]
             >= [self.maxItems unsignedIntegerValue])))
    {
        self.st_showingAddCell  = NO;
        if ([self.menu isViewLoaded])
        {
            [self.menu.tableView
             deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:
              [NSIndexPath indexPathForRow:[self.st_list count]
                                 inSection:self.section]]
             withRowAnimation:
             animated?UITableViewRowAnimationTop:UITableViewRowAnimationNone];
        }
    }
    if (!self.st_showingAddCell &&
        (self.editing
         && [self.editable boolValue]
         && (!self.maxItems
             || [self.st_list count]
             < [self.maxItems unsignedIntegerValue])))
    {
        if ([self.menu isViewLoaded])
        {
            self.st_showingAddCell  = YES;
            [self.menu.tableView
             insertRowsAtIndexPaths:
             [NSArray arrayWithObject:
              [NSIndexPath indexPathForRow:[self.st_list count]
                                 inSection:self.section]]
             withRowAnimation:
             animated?UITableViewRowAnimationTop:UITableViewRowAnimationNone];
        }
    }
}

- (BOOL)isInList:(NSUInteger)row
{
    return row < [self.st_list count];
}

- (void)showItem:(id)item
{
    if (item && self.itemMenu)
    {
        // get menu
        UIViewController <STMenuProtocol>   *subMenu
          = [self.menu st_getMenuFromData:self.itemMenu forKey:self.key];
        // set value
        subMenu.value   = item;
        // set title
        subMenu.title   = self.itemTitle;
        
        // set current item
        self.st_currentlyShowingItem    = item;
        
        // push it
        [self.menu st_pushMenu:subMenu forSection:self.section];
    }
}

- (id)createItem
{
    if (!self.blankItem)
    {
        return nil;
    }
    if ([self.blankItem conformsToProtocol:@protocol(NSCopying)])
    {
        return [[self.blankItem copy] autorelease];
    }
    return self.blankItem;
}

- (void)addItem:(id)item
{
    if (!item)
    {
        return;
    }
    NSUInteger  itemIndex       = [self.st_list indexOfObjectIdenticalTo:item];
    if (itemIndex == NSNotFound)
    {
        [self.st_list addObject:item];
    }
    // sort
    if (self.sortDescriptors)
    {
        [self.st_list sortUsingDescriptors:self.sortDescriptors];
    }
    if ([self.menu isViewLoaded])
    {
        // animate the table
        NSUInteger  newItemIndex    = [self.st_list
                                       indexOfObjectIdenticalTo:item];
        [self.menu.tableView beginUpdates];
        if (itemIndex == NSNotFound)
        {
            // this is an add
            [self.menu.tableView
             insertRowsAtIndexPaths:
             [NSArray arrayWithObject:
              [NSIndexPath indexPathForRow:newItemIndex inSection:self.section]]
              withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (itemIndex != newItemIndex)
        {
            // this was a move
            [self.menu.tableView
             deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:
              [NSIndexPath indexPathForRow:itemIndex inSection:self.section]]
             withRowAnimation:UITableViewRowAnimationFade];
            [self.menu.tableView
             insertRowsAtIndexPaths:
             [NSArray arrayWithObject:
              [NSIndexPath indexPathForRow:newItemIndex inSection:self.section]]
             withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            // reset cell
            [(STMenuTableViewCell *)
             [self.menu.tableView cellForRowAtIndexPath:
              [NSIndexPath indexPathForRow:itemIndex inSection:self.section]]
             setValue:item];
        }
        [self st_checkIfWeShouldShowAddCell:YES];
        [self.menu.tableView endUpdates];
    }
}

- (void)replaceItem:(id)item1 withItem:(id)item2
{
    if (!item1 || item1 == item2)
    {
        [self addItem:item2];
    }
    else
    {
        [self deleteItem:item1];
        [self addItem:item2];
    }
}

- (void)deleteItem:(id)item
{
    NSUInteger  itemIndex   = [self.st_list indexOfObjectIdenticalTo:item];
    if (itemIndex != NSNotFound)
    {
        // actual delete
        [self.st_list removeObjectAtIndex:itemIndex];
        
        if ([self.menu isViewLoaded])
        {
            [self.menu.tableView beginUpdates];
            [self.menu.tableView
             deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:
              [NSIndexPath indexPathForRow:itemIndex inSection:self.section]]
             withRowAnimation:UITableViewRowAnimationFade];
            [self st_checkIfWeShouldShowAddCell:YES];
            [self.menu.tableView endUpdates];
        }
    }
}

// Returns nil if item is not in list
- (NSIndexPath *)indexPathForItem:(id)item
{
    NSUInteger      row     = [self.st_list indexOfObject:item];
    if (row != NSNotFound)
    {
        return [NSIndexPath indexPathForRow:row inSection:self.section];
    }
    return nil;
}

// Returns nil if addCell is not showing
- (NSIndexPath *)indexPathForAddCell
{
    if (self.st_showingAddCell)
    {
        return [NSIndexPath indexPathForRow:[self.st_list count]
                                  inSection:self.section];
    }
    return nil;
}

#pragma mark Properties

- (id)list
{
    return [[_list copy] autorelease];
}

- (void)setList:(id)list
{
    if (_list != list)
    {
        [_list release];
        if ([list isKindOfClass:[NSSet class]])
        {
            _list   = [[list allObjects] mutableCopy];
        }
        else if ([list isKindOfClass:[NSArray class]])
        {
            _list   = [list mutableCopy];
        }
        else if (!list || [list isKindOfClass:[NSNull class]])
        {
            _list   = nil;
        }
        else
        {
            [NSException raise:@"STMenuListSectionControllerBadListException"
                        format:@"List must be set or array. Given: %@", list];
        }
        
        [self reloadSection:NO];
    }
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors
{
    if (_sortDescriptors != sortDescriptors)
    {
        [_sortDescriptors release];
        if (!sortDescriptors)
        {
            // no sort descriptors
            _sortDescriptors    = nil;
            return;
        }
        NSMutableArray  *sorts  = [[NSMutableArray alloc]
                                   initWithCapacity:[sortDescriptors count]];
        for (NSDictionary *sortDescriptorDictionary in sortDescriptors)
        {
            NSSortDescriptor    *sortDescriptor;
            if ([sortDescriptorDictionary valueForKey:@"selector"])
            {
                sortDescriptor
                  = [[NSSortDescriptor alloc]
                     initWithKey:[sortDescriptorDictionary valueForKey:@"key"]
                     ascending:[[sortDescriptorDictionary
                                 valueForKey:@"ascending"]
                                boolValue]
                     selector:NSSelectorFromString([sortDescriptorDictionary
                                                    valueForKey:@"selector"])];
            }
            else
            {
                sortDescriptor
                  = [[NSSortDescriptor alloc]
                     initWithKey:[sortDescriptorDictionary valueForKey:@"key"]
                     ascending:[[sortDescriptorDictionary
                                 valueForKey:@"ascending"]
                                boolValue]];
            }
            [sorts addObject:sortDescriptor];
            [sortDescriptor release];
        }
        _sortDescriptors    = sorts;
        
        [self reloadSection:NO];
    }
}

- (void)setMaxItems:(NSNumber *)newMaxItems
{
    if (_maxItems != newMaxItems)
    {
        [_maxItems release];
        _maxItems = [newMaxItems copy];
        [self st_checkIfWeShouldShowAddCell:NO];
    }
}

- (void)setEditable:(NSNumber *)newEditable
{
    if (_editable != newEditable)
    {
        [_editable release];
        _editable = [newEditable copy];
        [self st_checkIfWeShouldShowAddCell:NO];
    }
}

#pragma mark STMenuFormattedSectionController

- (void)saveValue:(id)value forSubMenuKey:(NSString *)key
{
    if ([key isEqualToString:self.key])
    {
        BOOL    selectNewValue  = NO;
        
        if ([self.menu isViewLoaded])
        {
            // !!!: test
            // see if we should select this new item
            NSIndexPath     *currentIndexPath   = nil;
            if (self.st_currentlyShowingItem)
            {
                // this was the item that was selected
                // It has been replaced by a new item, select that new item so
                // the user can see which item was changed
                currentIndexPath    = [self indexPathForItem:
                                       self.st_currentlyShowingItem];
            }
            else
            {
                // maybe the add cell was selected
                // This is a new item that got added. Select the new item so
                // the user can see which item is the one.
                currentIndexPath    = [self indexPathForAddCell];
            }
            selectNewValue  = ([[self.menu.tableView indexPathForSelectedRow]
                                compare:currentIndexPath]
                               == NSOrderedSame);
        }

        [self replaceItem:self.st_currentlyShowingItem withItem:value];
        self.st_currentlyShowingItem    = nil;
        
        if (selectNewValue)
        {
            // !!!: test
            NSIndexPath     *newValueIndexPath  = [self indexPathForItem:value];
            if (newValueIndexPath)
            {
                [self.menu.tableView
                 selectRowAtIndexPath:newValueIndexPath
                 animated:NO
                 scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

- (void)cancelForSubMenuKey:(NSString *)key
{
    self.st_currentlyShowingItem    = nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self st_checkIfWeShouldShowAddCell:animated];
}

- (void)reloadSection:(BOOL)animated
{
    // sort
    if (self.sortDescriptors)
    {
        [_list sortUsingDescriptors:self.sortDescriptors];
    }
    
    [super reloadSection:animated];
    
    [self st_checkIfWeShouldShowAddCell:NO];
}

- (void)didSelectRow:(NSUInteger)row
{
    if ([self isInList:row])
    {
        [self showItem:[self.st_list objectAtIndex:row]];
    }
    else
    {
        [self showItem:[self createItem]];
    }
}

- (NSInteger)numberOfRows
{
    return [self.st_list count] + (self.st_showingAddCell ? 1 : 0);
}

// Default does nothing
- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                    forRow:(NSUInteger)row
{
    if ([self isInList:row])
    {
        // delete item
        [self deleteItem:[self.st_list objectAtIndex:row]];
    }
    else if (self.st_showingAddCell)
    {
        // add new item
        [self.menu.tableView
         selectRowAtIndexPath:
         [NSIndexPath indexPathForRow:row inSection:self.section]
         animated:YES
         scrollPosition:UITableViewScrollPositionNone];
        [self didSelectRow:row];
    }
}

- (BOOL)canEditRow:(NSUInteger)row
{
    return [self.editable boolValue];
}

- (UITableViewCellEditingStyle)editingStyleForRow:(NSUInteger)row
{
    if ([self isInList:row])
    {
        // delete item
        return UITableViewCellEditingStyleDelete;
    }
    else if (self.st_showingAddCell)
    {
        // add new item
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

// Subclass these! OR height and cellForRow methods OR both
// Defaults: nil
- (NSString *)titleForRow:(NSUInteger)row
{
    if ([self isInList:row])
    {
        return nil;
    }
    else if (self.st_showingAddCell)
    {
        return self.addTitle;
    }
    return nil;
}

- (id)valueForRow:(NSUInteger)row
{
    if ([self isInList:row])
    {
        return [self.st_list objectAtIndex:row];
    }
    return nil;
}

- (id)cellDataForRow:(NSUInteger)row
{
    if ([self isInList:row])
    {
        return self.cell;
    }
    else if (self.st_showingAddCell)
    {
        if (self.addCell)
        {
            return self.addCell;
        }
        // Default add cell
        return @"AddItem";
    }
    return nil;
}

- (NSString *)keyForRow:(NSUInteger)row
{
    return self.key;
}

- (id)menuDataForRow:(NSUInteger)row
{
    return self.itemMenu;
}

@end
