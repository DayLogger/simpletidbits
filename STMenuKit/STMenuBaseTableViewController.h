//
//  STMenuBaseTableViewController.h
//  STMenuKit
//
//  Created by Jason Gregori on 11/12/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "STMenuProtocol.h"
#import "STLoadingView.h"

@class STMenuTableViewCell;

@interface STMenuBaseTableViewController : UITableViewController
<STMenuProtocol>
{
  @private
    // used to store plist name
    NSString        *_plistName;
    // used to store plist data
    id              _schema;
    id              _value;
    BOOL            _loading;
    NSString        *_loadingMessage;
    STLoadingView   *_loadingView;
    NSString        *_menuKey;
    NSString        *_delegateKey;
    
    NSString        *_headerMessage;
    
    NSString        *_key;
    BOOL            _parentMenuShouldSave;
    
    NSNumber        *_newestMode;
    
    BOOL            _inModal;
    
    UIViewController <STMenuProtocol>   *_subMenu;
    NSMutableDictionary     *_cachedMenus;
}
// Intercommunication: returns the delegate from the intercom using delegateKey
@property (nonatomic, readonly) id          delegate;

// This is a message to display at the top of the table
@property (nonatomic, copy)     NSString    *headerMessage;

// Pops the menu from the nav controller
- (void)dismiss;

#pragma mark For Subclass or Private Use Only

// use this to know when schema was changed
// copied if possible
@property (nonatomic, copy, readonly)   NSString    *st_plistName;
@property (nonatomic, copy)   id        st_schema;
@property (nonatomic, readonly, retain) UIViewController <STMenuProtocol>
                                        *st_subMenu;

// default cell class
- (Class)st_defaultCellClass;
// This is used to get cell classes from names
// customCellPrefix + class data name + @"TableViewCell"
- (NSString *)st_customCellPrefix;

// default menu class, defaults to [self class]
- (Class)st_defaultMenuClass;

// Gets a cell from the table view or creates one.
// Cell is a STMenuMaker Item.
// Sets menu property and key property.
// Does not set cell properties if key is the same as dequeued cell.
// reuse id is className.
- (STMenuTableViewCell *)st_cellWithCellData:(id)data
                                         key:(NSString *)key;
// Default style to use with cells, cells may override this of course.
- (UITableViewCellStyle)st_defaultCellStyle;
// This is called whenever a cell is created. Default does nothing.
- (void)st_initializeCell:(STMenuTableViewCell *)cell;

// Use this to push a subMenu. It will set self.st_subMenu to this. It will set
// parentMenuShouldSave to NO on the submenu.
- (void)st_pushMenu:(UIViewController <STMenuProtocol> *)subMenu;

// Use this to show a subMenu in a modal. It will be put in a Navigation
// Controller. self.st_subMenu will be set to this menu. It will set
// parentMenuShouldSave to NO on the submenu.
- (void)st_presentMenu:(UIViewController <STMenuProtocol> *)subMenu;

// Override this to save values returned by sub menus. This will only be called
// if you pushed the sub menu using st_pushMenu and the menu has set
// parentMenuShouldSave to YES. Default does nothing.
- (void)st_saveValue:(id)value forSubMenuKey:(NSString *)key;
// Called when parentMenuShouldSave is set to NO. Default does nothing.
- (void)st_cancelForSubMenuKey:(NSString *)key;

// Gets an instance of a menu, either by creating one or by using a cached one.
// Data could be either a the class name (NSString) or a dictionary.
// For the class, we try to find a class named
// "STMenu"+className+"ViewController". If that doesn't work, we try className.
// If data is a dictionary, it must have a key named "class" that follows the
// above constaints.
// Uses "key" to determine if we are using the menu for a new use.
// If key is different, resets all values and calls 'st_prepareForReuse'.
// Use nil key to reset no matter what.
// Uses st_defaultMenuClass for the default menu class.
// Either returns a view controller or throws an exception.
- (UIViewController <STMenuProtocol> *)st_getMenuFromData:(id)data
                                                   forKey:(NSString *)key;

@end
