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
    
    [self.table setNumberOfRows:self.dataSource.count withRowType:LightRowIdentifier];
    
    for (NSInteger i=0; i < self.table.numberOfRows; i++)
        [self updateRowAtIndex:i];
    
    return self;
}

- (void)willActivate
{
}

- (void)didDeactivate
{
}

- (void)updateRowAtIndex:(NSInteger)idx
{
    LightRowController * rowController = [self.table rowControllerAtIndex:idx];
    rowController.light = self.dataSource.lights[idx];
}

#pragma mark - Magical Table Delegate

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self pushControllerWithName:@"LightDetailScreen" context:self.dataSource.lights[rowIndex]];
}

#pragma mark - LightDataSourceDelegate

- (void)lightDataSource:(LightDataSource *)lightSource didInsertLightAtIndex:(NSInteger)idx
{
    [self.table insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx] withRowType:LightRowIdentifier];
    [self updateRowAtIndex:idx];
}

- (void)lightDataSource:(LightDataSource *)lightSource didRemoveLightAtIndex:(NSInteger)idx
{
    [self.table removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx]];
}

@end



