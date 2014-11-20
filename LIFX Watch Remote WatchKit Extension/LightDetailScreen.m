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
@property (weak, nonatomic) IBOutlet WKInterfaceSlider * brightnessSlider;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider * colourTempSlider;

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
    
    LFXHSBKColor * colour = light.color;
    self.brightnessSlider.value = colour.brightness;
    self.colourTempSlider.value = colour.kelvin;
}

- (IBAction)changeBrightness:(float)value
{
    self.light.color = [self.light.color colorWithBrightness:value];
}

- (IBAction)changeColourTemp:(float)value
{
    double brightness = self.light.color.brightness;
    LFXHSBKColor * colour = [LFXHSBKColor whiteColorWithBrightness:brightness
                                                            kelvin:value];
    self.light.color = colour;
}

- (IBAction)redPress
{
    double brightness = self.light.color.brightness;
    LFXHSBKColor * colour = [LFXHSBKColor colorWithHue:0 saturation:1 brightness:brightness];
    self.light.color = colour;
}

- (IBAction)greenPress
{
    double brightness = self.light.color.brightness;
    LFXHSBKColor * colour = [LFXHSBKColor colorWithHue:119 saturation:1 brightness:brightness];
    self.light.color = colour;
}

- (IBAction)bluePress
{
    double brightness = self.light.color.brightness;
    LFXHSBKColor * colour = [LFXHSBKColor colorWithHue:230 saturation:1 brightness:brightness];
    self.light.color = colour;
}

@end
