//
//  NSDateAdditions.h
//  SimpleTidbits
//
//  Created by Jason Gregori on 9/26/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (SimpleTidbits)

// Uses NSDateFormattor with ShortStyle and LongStyle respectively (no time).
- (NSString *)st_shortStringValue;
- (NSString *)st_longStringValue;
- (NSString *)st_timeStringValue;

- (NSDate *)st_dateByRoundingToNearest:(NSUInteger)minutes;

@end
