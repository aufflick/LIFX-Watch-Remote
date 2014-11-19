//
//  LightDetailScreen.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 20/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "LightDetailScreen.h"

@interface LightDetailScreen ()

@property (nonatomic, strong) LFXLight * light;

@end

@implementation LightDetailScreen

@synthesize light=_light;

- (instancetype)initWithContext:(id)context
{
    if (nil == (self = [super initWithContext:context]))
        return nil;
    
    self.light = context;
    
    return self;
}

- (void)setLight:(LFXLight *)light
{
    _light = light;
    [self setTitle:light.label];
}

@end
