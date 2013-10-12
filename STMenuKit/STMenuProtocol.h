//
//  STMenuProtocol.h
//  STMenuKit
//
//  Created by Jason Gregori on 11/8/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#include <Foundation/Foundation.h>

@protocol STMenuProtocol

@required

// plist can either be a string, in which case it will be used as a file name
// for loading a plist from disk, or a plist object.
// Must return what is put in so save plist strings separately from plist
// object.
// Should be copied if possible.
@property (nonatomic, copy)     id          plist;

// This is the value that is being displayed to the user.
// If your menu is one that allows the user to cancel or otherwise not save
// (like a sub menu), you must either not edit the original value that is
// giving you by your parent or you must rollback any changes made before
// canceling. For example you can set your value to a copy of the original or
// a new value.
@property (nonatomic, retain)   id          value;

@property (nonatomic, copy)     NSString    *key;
@property (nonatomic, assign)   BOOL        parentMenuShouldSave;

// Some menus may have a "new" mode. For example Edit Menu has a new mode with
// a cancel button instead of a back button.
@property (nonatomic, retain)   NSNumber    *newestMode;

// When a menu is loading, it should stop the user from accessing anything and
// display some kind of ui so the user knows what's going on.
@property (nonatomic, assign)   BOOL        loading;
@property (nonatomic, copy)     NSString    *loadingMessage;

// Intercommunication
@property (nonatomic, copy)     NSString    *menuKey;
@property (nonatomic, copy)     NSString    *delegateKey;

- (void)setPlist:(id)plist andValue:(id)value;

- (void)setLoading:(BOOL)loading animated:(BOOL)animated;

// This method can be called by others to "finish" whatever you are doing.
// The default does nothing.
- (void)done;

// Programmatically dismiss the menu (for example pop a VC menu in a nav)
- (void)dismiss;

// This method must be called on a menu after it has been dismissed. It is the
// job of the menu's parent menu to call this method. Default does nothing.
- (void)menuDidDismiss;

// create an instance of a menu
+ (id)menu;

#pragma mark For Subclass/Private Use Only

// tells you if this menu is in a modal, used for dismiss
@property (nonatomic, assign)   BOOL    st_inModal;

// This is called when a menu is reused. Reset all editable properties
- (void)st_prepareForReuse;

@end
