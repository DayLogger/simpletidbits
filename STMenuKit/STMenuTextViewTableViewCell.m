//
//  STMenuTextFieldTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/4/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuTextViewTableViewCell.h"

#define kSTMenuTextViewMaxWidth    175

@interface STMenuTextViewTableViewCell ()
@property (nonatomic, retain) UITextView    *textView;
@property (nonatomic, retain) NSIndexPath   *st_nextCellIndexPath;
@property (nonatomic, assign) BOOL          st_deselectOnReturn;
@property (nonatomic, assign) BOOL          st_doneOnReturn;

- (void)st_deselectIfNotSelectedCell;
- (void)st_textViewValueDidChange;

@end


@implementation STMenuTextViewTableViewCell
@synthesize textView = _textView, st_nextCellIndexPath = _nextCellIndexPath,
            st_deselectOnReturn = _deselectOnReturn,
            st_doneOnReturn = _doneOnReturn;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (style == UITableViewCellStyleDefault)
    {
        // we do this because we copy styles from the detailTextLabel
        style   = UITableViewCellStyleValue1;
    }
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle     = UITableViewCellSelectionStyleNone;
        _textView              = [[UITextView alloc] init];
        // This is only enabled when the cell is selected, that way the cell is
        // selected even when the textView is tapped. We need this behavior
        // so we can cleanup when the cell is deselected.
        _textView.editable      = NO;
        _textView.font          = [UIFont systemFontOfSize:18];
        _textView.autoresizingMask = (UIViewAutoresizingFlexibleHeight
                                       | UIViewAutoresizingFlexibleLeftMargin);
        _textView.delegate     = self;
//        _textView.textColor    = self.detailTextLabel.textColor;
//        _textView.adjustsFontSizeToFitWidth    = YES;
//        _textView.minimumFontSize  = 13;
        _textView.autocapitalizationType   = UITextAutocapitalizationTypeNone;
        _textView.returnKeyType= UIReturnKeyDefault;
        [self.contentView addSubview:_textView];
        
        // defaults
        _deselectOnReturn       = YES;
    }
    return self;
}

- (void)dealloc
{
    [_textView release];
    // make sure we aren't still listening for notifications
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
    
    [super dealloc];
}

- (void)setTitle:(NSString *)title
{
    // ignore this
}


- (void)st_deselectIfNotSelectedCell
{
    if (self.menu &&
        [self.menu.tableView cellForRowAtIndexPath:
         [self.menu.tableView indexPathForSelectedRow]]
        != self)
    {
        [self setSelected:NO animated:YES];
    }
}
         
- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate menuTableViewCell:self didChangeValue:self.textView.text];
}

#pragma mark Properties

- (void)setAutocapitalizationType:(NSString *)type
{
    type        = [type lowercaseString];
    if ([type isEqualToString:@"sentences"])
    {
        self.textView.autocapitalizationType
          = UITextAutocapitalizationTypeSentences;
    }
    else if ([type isEqualToString:@"words"])
    {
        self.textView.autocapitalizationType
          = UITextAutocapitalizationTypeWords;
    }
    else if ([type isEqualToString:@"allcharacters"])
    {
        self.textView.autocapitalizationType
          = UITextAutocapitalizationTypeAllCharacters;
    }
    else
    {
        self.textView.autocapitalizationType
          = UITextAutocapitalizationTypeNone;
    }
}

- (NSString *)autocapitalizationType
{
    return nil;
}

- (void)setAutocorrectionType:(NSString *)type
{
    type        = [type lowercaseString];
    if ([type isEqualToString:@"no"])
    {
        self.textView.autocorrectionType
          = UITextAutocorrectionTypeNo;
    }
    else if ([type isEqualToString:@"yes"])
    {
        self.textView.autocorrectionType
          = UITextAutocorrectionTypeYes;
    }
    else
    {
        self.textView.autocorrectionType
          = UITextAutocorrectionTypeDefault;
    }
}

- (NSString *)autocorrectionType
{
    return nil;
}

- (void)setEnablesReturnKeyAutomatically:(NSNumber *)enables
{
    self.textView.enablesReturnKeyAutomatically    = [enables boolValue];
}

- (NSNumber *)enablesReturnKeyAutomatically
{
    return nil;
}

- (void)setKeyboardType:(NSString *)type
{
    type        = [type lowercaseString];
    if ([type isEqualToString:@"asciicapable"])
    {
        self.textView.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([type isEqualToString:@"numbersandpunctuation"])
    {
        self.textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([type isEqualToString:@"url"])
    {
        self.textView.keyboardType = UIKeyboardTypeURL;
    }
    else if ([type isEqualToString:@"numberpad"])
    {
        self.textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([type isEqualToString:@"phonepad"])
    {
        self.textView.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([type isEqualToString:@"emailaddress"])
    {
        self.textView.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else
    {
        self.textView.keyboardType = UIKeyboardTypeDefault;
    }
}

- (NSString *)keyboardType
{
    return nil;
}

- (void)setSecureTextEntry:(NSNumber *)secureTextEntry
{
    self.textView.secureTextEntry  = [secureTextEntry boolValue];
}

- (NSNumber *)secureTextEntry
{
    return nil;
}

- (void)setReturnKeyType:(NSString *)type
{
    type        = [type lowercaseString];
    if ([type isEqualToString:@"go"])
    {
        self.textView.returnKeyType    = UIReturnKeyGo;
    }
    else if ([type isEqualToString:@"google"])
    {
        self.textView.returnKeyType    = UIReturnKeyGoogle;
    }
    else if ([type isEqualToString:@"join"])
    {
        self.textView.returnKeyType    = UIReturnKeyJoin;
    }
    else if ([type isEqualToString:@"next"])
    {
        self.textView.returnKeyType    = UIReturnKeyNext;
    }
    else if ([type isEqualToString:@"route"])
    {
        self.textView.returnKeyType    = UIReturnKeyRoute;
    }
    else if ([type isEqualToString:@"search"])
    {
        self.textView.returnKeyType    = UIReturnKeySearch;
    }
    else if ([type isEqualToString:@"send"])
    {
        self.textView.returnKeyType    = UIReturnKeySend;
    }
    else if ([type isEqualToString:@"yahoo"])
    {
        self.textView.returnKeyType    = UIReturnKeyYahoo;
    }
    else if ([type isEqualToString:@"done"])
    {
        self.textView.returnKeyType    = UIReturnKeyDone;
    }
    else if ([type isEqualToString:@"emergencycall"])
    {
        self.textView.returnKeyType    = UIReturnKeyEmergencyCall;
    }
    else
    {
        self.textView.returnKeyType    = UIReturnKeyDefault;
    }
}

- (NSString *)returnKeyType
{
    return nil;
}

- (void)setNextCellIndexPath:(NSString *)indexPathString
{
    if (indexPathString)
    {
        NSArray     *components     = [indexPathString
                                       componentsSeparatedByString:@","];
        self.st_nextCellIndexPath
          = [NSIndexPath
             indexPathForRow:[[components objectAtIndex:1] integerValue]
             inSection:[[components objectAtIndex:0] integerValue]];
        self.textView.returnKeyType    = UIReturnKeyNext;
    }
    else
    {
        self.st_nextCellIndexPath   = nil;
    }
}

- (NSString *)nextCellIndexPath
{
    return nil;
}

#pragma mark STMenuTableViewCell

- (void)st_prepareForReuse
{
    [super st_prepareForReuse];
    
    // reset all text attributes
    self.autocapitalizationType = nil;
    self.autocorrectionType     = nil;
    self.enablesReturnKeyAutomatically  = nil;
    self.keyboardType           = nil;
    self.secureTextEntry        = nil;
    
    self.nextCellIndexPath      = nil;
}

- (void)setValue:(id)value
{
    NSAssert(!value || [value isKindOfClass:[NSString class]],
             @"Value for STMenuTextFieldTableViewCell must be an NSString.");
    if (![value isEqualToString:self.textView.text])
    {
        self.textView.text = value;
    }
    
}

#pragma mark STMenuTableViewCell

+ (CGFloat)heightWithTitle:(NSString *)title value:(id)value
{
    return 170.0;
}

#pragma mark UITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        // when selected, start editing
        self.textView.editable  = YES;
        [self.textView becomeFirstResponder];
        
        // when set selected, listen for notifications of the tableView
        // changing selected cell we can resignFirstResponder. We need to do
        // because if the cell is off the screen it won't be told to deselect
        // when another cell is selected
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(st_deselectIfNotSelectedCell)
         name:UITableViewSelectionDidChangeNotification
         object:self.menu.tableView];
    }
    else
    {
        // if unselected, stop being first responder
        [self.textView resignFirstResponder];
        self.textView.editable  = NO;
        
        // stop observing tableView
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:UITableViewSelectionDidChangeNotification
         object:nil];
    }
}

#pragma UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.textLabel.text)
    {
        // move textfield over a bit
        CGFloat     width   = (self.contentView.bounds.size.width - 30
                               - self.textLabel.bounds.size.width);
        if (width > kSTMenuTextViewMaxWidth)
        {
            width   = kSTMenuTextViewMaxWidth;
        }
        self.textView.frame
        = CGRectMake(self.contentView.bounds.size.width - 10 - width,
                     0,
                     width,
                     self.contentView.bounds.size.height);
    }
    else
    {
        self.textView.frame    = CGRectInset(self.contentView.bounds, 10, 0);
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return self.selected;
}

@end
