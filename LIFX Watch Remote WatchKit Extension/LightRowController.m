//
//  LightRowController.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "LightRowController.h"
#import <WatchKit/WatchKit.h>

@interface LightRowController ()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel * label;
@property (weak, nonatomic) IBOutlet WKInterfaceButton * button;

@end

@implementation LightRowController

- (void)setLight:(LFXLight *)light
{
    _light = light;
    [self.label setText:light.label];
    [self updatePowerLabel];
}

- (void)updatePowerLabel
{
    if (self.light.powerState == LFXPowerStateOn)
    {
        [self.button setTitle:@"ON"];
        [self.button setColor:[UIColor greenColor]];
    }
    else
    {
        [self.button setTitle:@"OFF"];
        [self.button setColor:[UIColor darkGrayColor]];
    }
}

- (IBAction)togglePower
{
    self.light.powerState = self.light.powerState == LFXPowerStateOn ? LFXPowerStateOff : LFXPowerStateOn;
    [self updatePowerLabel];
}

@end
