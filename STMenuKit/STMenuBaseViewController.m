//
//  STMenuBaseViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/14/09.
//  Copyright 2009 Slingshot Labs. All rights reserved.
//

#import "STMenuBaseViewController.h"
#import "STMenuMaker.h"

@interface STMenuBaseViewController ()

@property (nonatomic, copy)     NSString    *st_plistName;

@property (nonatomic, retain)   UIViewController <STMenuProtocol>   *st_subMenu;
@property (nonatomic, retain)   NSMutableDictionary     *st_cachedMenus;

@end

@implementation STMenuBaseViewController
@synthesize value = _value, key = _key, st_plistName = _plistName,
            st_schema = _schema, parentMenuShouldSave = _parentMenuShouldSave,
            st_subMenu = _subMenu, st_cachedMenus = _cachedMenus;

// create an instance of a menu
+ (id)menu
{
    return [[[self alloc] init] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _cachedMenus	= [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_plistName release];
    [_schema release];
    [_value release];
    [_key release];
    [_subMenu release];
    [_cachedMenus release];
    
    [super dealloc];
}

// default menu class
- (Class)st_defaultMenuClass
{
    return [self class];
}


#pragma mark STMenuProtocol

- (void)setPlist:(id)plist andValue:(id)value
{
    self.plist  = plist;
    self.value  = value;
}

- (NSString *)plist
{
    if (self.st_plistName)
    {
        return self.st_plistName;
    }
    return self.st_schema;
}

- (void)setPlist:(id)plist
{
    if ([plist isKindOfClass:[NSString class]])
    {
        self.st_plistName  = plist;
        
        NSData  *plistData  = [NSData dataWithContentsOfFile:
                               [[[NSBundle mainBundle] bundlePath]
                                stringByAppendingPathComponent:plist]];
        NSString    *error;
        self.st_schema      = [NSPropertyListSerialization
                               propertyListFromData:plistData
                               mutabilityOption:NSPropertyListImmutable
                               format:NULL
                               errorDescription:&error];
        if (error)
        {
            [NSException raise:@"STMenuBaseViewController Bad Plist"
                        format:
             @"Error loading plist with plist name from \"%@\". Error:\n%@",
             plist,
             error];
            [error release];
        }
    }
    else
    {
        self.st_plistName  = nil;
        self.st_schema    = plist;
    }
}

- (void)setLoading:(BOOL)loading
{
    [self setLoading:loading animated:NO];
}

- (BOOL)loading
{
    return _loading;
}

- (void)setLoading:(BOOL)loading animated:(BOOL)animated
{
    _loading    = loading;
    
    self.view.userInteractionEnabled    = !loading;
}

// This is called when a menu is reused. Reset all editable properties.
- (void)st_prepareForReuse
{
    
}

#pragma mark For Subclass Use

// Use this to push a subMenu. It will set _subMenu to this. It will set
// parentMenuShouldSave to NO.
- (void)st_pushMenu:(UIViewController <STMenuProtocol> *)subMenu
{
    self.st_subMenu    = subMenu;
    subMenu.parentMenuShouldSave    = NO;
    [self.navigationController pushViewController:subMenu
                                         animated:YES];
}

// Override this to save values returned by sub menus. Default does nothing.
- (void)st_saveValue:(id)value forSubMenuKey:(NSString *)key
{
    
}

// Gets an instance of a menu, either by creating one or by using a cached one.
// Data could be either a the class name (NSString) or a dictionary.
// For the class, we try to find a class named
// "STMenu"+className+"ViewController". If that doesn't work, we try className.
// If data is a dictionary, it must have a key named "class" that follows the
// above constaints.
// Uses "key" to determine if we are using the menu for a new use.
// If key is different, resets all values and calls 'st_prepareForReuse'.
// Use nil key to reset no matter what.
// Either returns a view controller or throws an exception
- (UIViewController <STMenuProtocol> *)st_getMenuFromData:(id)data
                                                   forKey:(NSString *)key
{
    return [STMenuMaker makeInstanceFromData:data
                                    useCache:self.st_cachedMenus
                                 propertyKey:key
                              useClassPrefix:@"STMenu"
                                      suffix:@"ViewController"
                                defaultClass:[self st_defaultMenuClass]];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // got to set loading correctly
    [self setLoading:self.loading];    
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
    
    // release all the cached menus
    [self.st_cachedMenus removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.st_subMenu)
    {
        // If there is a submenu we must have just popped back from it
        if (self.st_subMenu.parentMenuShouldSave)
        {
            // If the subMenu should be saved, tell menu to save it
            [self st_saveValue:self.st_subMenu.value
                 forSubMenuKey:self.st_subMenu.key];
        }
        // Release the subMenu so we won't accidentally save again
        self.st_subMenu    = nil;
    }
}


@end