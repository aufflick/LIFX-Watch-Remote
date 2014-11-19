//
//  ViewController.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "ViewController.h"
#import "LightDataSource.h"
#import <LIFXKit/LIFXKit.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, LightDataSourceDelegate>

@property (nonatomic, strong) LightDataSource * dataSource;

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UISlider * brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider * kelvinSlider;
@property (weak, nonatomic) IBOutlet UILabel * lightNameLabel;
@property (nonatomic, strong) LFXLight * selectedLight;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray * controlsToDisable;
@property (weak, nonatomic) IBOutlet UISwitch * onOffSwitch;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedLight = nil;
    self.dataSource = [[LightDataSource alloc] init];
    self.dataSource.delegate = self;
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

#pragma mark - IBActions

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

#pragma mark - LightDataSourceDelegate

- (void)lightDataSource:(LightDataSource *)lightSource didInsertLightAtIndex:(NSInteger)idx
{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)lightDataSource:(LightDataSource *)lightSource didRemoveLightAtIndex:(NSInteger)idx
{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell"];
    cell.textLabel.text = [self.dataSource.lights[indexPath.row] label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLight = self.dataSource.lights[indexPath.row];
}

@end
