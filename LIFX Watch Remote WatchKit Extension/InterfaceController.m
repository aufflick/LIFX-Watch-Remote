//
//  InterfaceController.m
//  LIFX Watch Remote WatchKit Extension
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "InterfaceController.h"
#import "LightDataSource.h"
#import "LightRowController.h"

static NSString * const LightRowIdentifier = @"LightRowIdentifier";

@interface InterfaceController() <LightDataSourceDelegate>
{
    BOOL isShowing;
}

@property (nonatomic, strong) LightDataSource * dataSource;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;

@end


@implementation InterfaceController

#pragma mark - Interface Lifecycle

- (instancetype)initWithContext:(id)context
{
    if (nil == (self = [super initWithContext:context]))
        return nil;
    
    self.dataSource = [[LightDataSource alloc] init];
    self.dataSource.delegate = self;
    
    return self;
}

- (void)willActivate
{
    [self.table setNumberOfRows:self.dataSource.count withRowType:LightRowIdentifier];
    isShowing = YES;
    
    for (NSInteger i=0; i < self.table.numberOfRows; i++)
        [self updateRowAtIndex:i];
}

- (void)didDeactivate
{
    isShowing = NO;
}

- (void)updateRowAtIndex:(NSInteger)idx
{
    LightRowController * rowController = [self.table rowControllerAtIndex:idx];
    rowController.light = self.dataSource.lights[idx];
}

#pragma mark - Magical Table Delegate

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"show light at index: %ld", rowIndex);
}

#pragma mark - LightDataSourceDelegate

- (void)lightDataSource:(LightDataSource *)lightSource didInsertLightAtIndex:(NSInteger)idx
{
    if (isShowing)
    {
        [self.table insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx] withRowType:LightRowIdentifier];
        [self updateRowAtIndex:idx];
    }
}

- (void)lightDataSource:(LightDataSource *)lightSource didRemoveLightAtIndex:(NSInteger)idx
{
    if (isShowing)
        [self.table removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx]];
}

@end



