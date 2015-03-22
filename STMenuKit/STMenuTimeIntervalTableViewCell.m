//
//  STMenuTimeIntervalTableViewCell.m
//  STMenuKit
//
//  Created by Jason Gregori on 12/15/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STMenuTimeIntervalTableViewCell.h"
#import <SimpleTidbits/NSDateAdditions.h>


@implementation STMenuTimeIntervalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setValue:(id)value
{
    NSAssert(!value || [value isKindOfClass:[NSNumber class]],
             @"Set value of Time Interval Cell to non number.");
    
    // Midnight
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSDate *midnight = [gregorian dateFromComponents:components];
    [gregorian release];
    
    NSDate *equivalent = [NSDate dateWithTimeInterval:[value doubleValue] sinceDate:midnight];
    NSString *text = [equivalent st_timerStyleStringValue];
    
    [self setValueString:text];
}

@end
