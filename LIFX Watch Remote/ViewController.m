//
//  ViewController.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "ViewController.h"
#import <LIFXKit/LIFXKit.h>

@interface ViewController () <LFXLightCollectionObserver, UITableViewDataSource, UITableViewDelegate>
{
    LFXLightCollection * allLightsCollection;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * lights;
@property (weak, nonatomic) IBOutlet UISlider * brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider * kelvinSlider;
@property (weak, nonatomic) IBOutlet UILabel * lightNameLabel;
@property (nonatomic, strong) LFXLight * selectedLight;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *controlsToDisable;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedLight = nil;
    
    allLightsCollection = [[LFXClient sharedClient] localNetworkContext].allLightsCollection;
    [allLightsCollection addLightCollectionObserver:self];

    self.lights = [allLightsCollection.lights mutableCopy];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
    if (![self.lights containsObject:light])
    {
        [self.lights addObject:light];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.lights count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    NSUInteger row = [self.lights indexOfObject:light];
    [self.lights removeObject:light];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setSelectedLight:(LFXLight *)selectedLight
{
    _selectedLight = selectedLight;
    
    if (nil == selectedLight)
    {
        for (UIView * view in self.controlsToDisable) [(id)view setEnabled:NO];
        self.onOffSwitch.on = NO;
        self.lightNameLabel.text = @"None Selected";
    }
    else
    {
        for (UIView * view in self.controlsToDisable) [(id)view setEnabled:YES];
        self.lightNameLabel.text = selectedLight.label;
        self.onOffSwitch.on = selectedLight.powerState == LFXPowerStateOn;

        LFXHSBKColor * colour = selectedLight.color;
        self.brightnessSlider.value = colour.brightness;
        self.kelvinSlider.value = colour.kelvin;
    }
}

- (IBAction)brightnessOrKelvinChanged:(UISlider *)sender
{
    LFXHSBKColor * colour = [LFXHSBKColor whiteColorWithBrightness:self.brightnessSlider.value
                                                            kelvin:self.kelvinSlider.value];
    self.selectedLight.color = colour;
}

- (IBAction)onOff:(UISwitch *)sender
{
    self.selectedLight.powerState = sender.on ? LFXPowerStateOn : LFXPowerStateOff;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell"];
    cell.textLabel.text = [self.lights[indexPath.row] label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLight = self.lights[indexPath.row];
}

@end
