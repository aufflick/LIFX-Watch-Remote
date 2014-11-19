//
//  LightDataSource.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "LightDataSource.h"

// because Nick uses CGFloats and otherwise we don't need to load CoreGraphics
// into the extension...

#undef CGFloat
#define CGFloat double

#import <LIFXKit/LIFXKit.h>

@interface LightDataSource () <LFXLightCollectionObserver>
{
    NSMutableArray * _lights;
}

@property (nonatomic, strong) LFXLightCollection * allLightsCollection;

@end

@implementation LightDataSource

@synthesize lights=_lights;

- (instancetype)init
{
    if (nil == (self = [super init]))
        return self;
    
    self.allLightsCollection = [[LFXClient sharedClient] localNetworkContext].allLightsCollection;
    [self.allLightsCollection addLightCollectionObserver:self];
    
    _lights = [self.allLightsCollection.lights mutableCopy];
    
    return self;
}

- (NSUInteger)count
{
    return [_lights count];
}

#pragma mark - LFXLightCollectionDelegate methods

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
    if (![self.lights containsObject:light])
    {
        [_lights addObject:light];
        [self.delegate lightDataSource:self didInsertLightAtIndex:[self.lights count]-1];
    }
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    NSUInteger idx = [self.lights indexOfObject:light];
    [_lights removeObjectAtIndex:idx];
    [self.delegate lightDataSource:self didRemoveLightAtIndex:idx];
}

@end
