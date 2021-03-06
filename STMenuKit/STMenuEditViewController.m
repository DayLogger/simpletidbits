//
//  STMenuEditViewController.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/1/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuEditViewController.h"
#import "STMenuBasicSectionController.h"

@interface STMenuEditViewController ()

@property (nonatomic, assign)   BOOL            purgeMode;
@property (nonatomic, retain)   UIActionSheet   *st_deleteActionSheet;

- (void)st_deleteButtonTapped;
- (void)st_delete;

@end


@implementation STMenuEditViewController
@synthesize showDeleteButton = _showDeleteButton,
            deleteMessage = _deleteMessage, purgeMode = _purgeMode,
            st_deleteActionSheet = _deleteActionSheet;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.navigationItem.rightBarButtonItem  = self.editButtonItem;
        self.hidesBottomBarWhenPushed   = YES;
    }
    return self;
}

- (void)dealloc
{
    [_showDeleteButton release];
    [_deleteMessage release];
    [_deleteActionSheet release];
    
    [super dealloc];
}

- (void)st_setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // hide back button when editing
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
    if (![self.newestMode boolValue])
    {
        // in not new mode
        
        // parent menu should only save if we are not in editing mode
        self.parentMenuShouldSave   = !editing;
    }
    
    if ([self.showDeleteButton boolValue] && [self isViewLoaded])
    {
        if (editing && ![self.newestMode boolValue])
        {
            // show delete button
            UIButton    *button     = [UIButton
                                       buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(st_deleteButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.deleteMessage ? self.deleteMessage : @"Delete"
                    forState:UIControlStateNormal];
            UIView      *backing    = [[UIView alloc] initWithFrame:
                                       CGRectMake(0, 0, 320, 64)];
            button.frame    = CGRectMake(10, 10, 300, 44);
            [backing addSubview:button];
            self.tableView.tableFooterView  = backing;
            [backing release];
        }
        else
        {
            self.tableView.tableFooterView  = nil;
        }
    }
}

- (void)st_deleteButtonTapped
{
    UIActionSheet   *actionSheet    = [[UIActionSheet alloc]
                                       initWithTitle:nil
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:self.deleteMessage
                                       otherButtonTitles:nil];
//    actionSheet.actionSheetStyle    = UIActionSheetStyleBlackTranslucent;
    self.st_deleteActionSheet       = actionSheet;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)st_delete
{
    if ([self.delegate
         respondsToSelector:@selector(editMenu:shouldDeleteItem:)])
    {
        if (![self.delegate editMenu:self shouldDeleteItem:self.value])
        {
            return;
        }
    }
    
    // if we are ok, just do it
    [self deleteItem];
}

- (void)saveItem
{
    if ([self.newestMode boolValue])
    {
        self.parentMenuShouldSave   = YES;
        [self dismiss];
    }
    else if (self.editing)
    {
        [self st_setEditing:NO animated:YES];
    }
}

- (void)deleteItem
{
    self.purgeMode      = YES;
    
    [self dismiss];
}

- (void)st_cancel
{
    self.purgeMode      = YES;
    
    [self dismiss];
}

#pragma mark STMenuFormattedTableViewController

- (Class)st_defaultSectionClass
{
    return [STMenuBasicSectionController class];
}

#pragma mark STMenuBaseTableViewController

- (NSString *)st_customCellPrefix
{
    return @"STMenuEdit";
}

- (UITableViewCellStyle)st_defaultCellStyle
{
    return UITableViewCellStyleValue2;
}

- (void)st_initializeCell:(STMenuTableViewCell *)cell
{

}

#pragma mark STMenuProtocol

- (void)done
{
    if (self.editing)
    {
        [self setEditing:NO animated:YES];
    }
    else
    {
        [self dismiss];
    }
}

- (void)setValue:(id)value
{
    if (![self.value isEqual:value])
    {
        [super setValue:value];

        if ([self isViewLoaded])
        {
            // scroll to top if value changes
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        }
    }
}

- (void)menuDidDismiss
{
    [super menuDidDismiss];
    
    if (self.editing)
    {
        [self st_setEditing:NO animated:NO];
    }
    
    if (self.purgeMode)
    {
        self.value          = nil;
        self.purgeMode      = NO;
    }
}

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
    
    self.showDeleteButton   = nil;
}

- (void)setNewestMode:(NSNumber *)newMode
{
    [super setNewestMode:newMode];
    
    if ([newMode boolValue])
    {
        // gotta be in edit mode
        [self st_setEditing:YES animated:NO];
        
        self.navigationItem.leftBarButtonItem
          = [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
              target:self
              action:@selector(st_cancel)]
             autorelease];
    }
    else
    {
        // start in not editing mode
        [self st_setEditing:NO animated:NO];
        self.navigationItem.leftBarButtonItem   = nil;
    }
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
    if (self.editing == editing)
    {
        return;
    }
    
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
        // if we are ok, just do it
        [self saveItem];
    }
    else
    {
        [self st_setEditing:editing animated:animated];
    }
}

#pragma mark Delegate Methods
#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.st_deleteActionSheet)
    {
        if (buttonIndex == [actionSheet destructiveButtonIndex])
        {
            [self st_delete];
        }
    }
}

@end
